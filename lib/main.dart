import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'dart:ui' as ui;
// removed dart:math; not needed for minimal XP toast
import 'package:share_plus/share_plus.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:shared_preferences/shared_preferences.dart';
import 'design_system/theme/app_theme.dart';
import 'design_system/theme/theme_variations.dart';
import 'design_system/tokens/colors.dart';
import 'design_system/components/cotton_bottom_bar.dart';
import 'design_system/components/xp_celebration_overlay.dart';
import 'core/language_manager.dart';

import 'features/habit/presentation/habit_screen.dart';
import 'features/timer/timer_screen.dart';
import 'features/finance/finance_screen.dart';
import 'features/future/presentation/future_screen.dart';
import 'features/vision/presentation/vision_screen.dart';
import 'features/profile/profile_screen.dart';

import 'features/profile/settings_screen.dart';
import 'features/social/presentation/social_hub_screen.dart';
import 'core/timer/timer_controller.dart';
import 'features/timer/widgets/landscape_timer_screen.dart';
import 'ui/premium_gate.dart';

// Removed Decision Egg feature
import 'features/gamification/gamification_repository.dart';
import 'features/notifications/data/notification_settings_repository.dart';
import 'features/notifications/services/notification_service.dart';
import 'features/habit/domain/habit_repository.dart';
import 'features/quick_create/presentation/quick_create_sheet.dart';
// Removed unused imports related to text/image sticker creation relocated to Vision FAB
import 'core/settings/settings_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'core/presentation/splash_screen.dart';
import 'features/onboarding/data/onboarding_repository.dart';
import 'core/privacy/privacy_service.dart';
import 'features/profile/auth_repository.dart';
import 'features/auth/sign_in_screen.dart';
import 'features/auth/test_choice_screen.dart';
// In-app purchase and premium management
import 'services/premium_manager.dart';
import 'services/iap_service.dart';
import 'features/backup/auto_backup_service.dart';
import 'services/home_widget_service.dart';
import 'package:provider/provider.dart';
import 'providers/premium_provider.dart';

import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Android 15 Edge-to-Edge enforcement
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize Mobile Ads SDK
  unawaited(MobileAds.instance.initialize());

  // In widget tests, Firebase may not be available; guard initialization.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {
    // ignore: avoid_print
    if (kDebugMode) {
      debugPrint('Firebase.initializeApp skipped in this context');
    }
  }
  runApp(
    ChangeNotifierProvider(
      create: (_) => PremiumProvider()..loadPremiumStatus(),
      child: const MiraApp(),
    ),
  );
}

class MiraApp extends StatefulWidget {
  const MiraApp({super.key});
  @override
  State<MiraApp> createState() => _MiraAppState();
}

class _MiraAppState extends State<MiraApp> {
  ThemeMode _mode = ThemeMode.light;
  ThemeVariant _variant = AppTheme.defaultVariant;
  late LanguageManager _languageManager;

  @override
  void initState() {
    super.initState();
    _languageManager = LanguageManager();
    _languageManager.addListener(_onLanguageChanged);
    _initializeLanguageManager();
    _initializeThemePreferences();
    // Initialize global settings
    // ignore: discarded_futures
    SettingsRepository.instance.initialize();
    unawaited(_initializeNotifications());
    // Initialize subscription/premium system
    unawaited(_initializeSubscriptionSystem());
    // Privacy service (consent toggles)
    // ignore: discarded_futures
    PrivacyService.instance.initialize();

    // Auto Backup initialization
    // ignore: discarded_futures
    AutoBackupService.instance.initialize();

    // Initialize Home Widget Service
    // ignore: discarded_futures
    HomeWidgetService.instance.initialize();
  }

  static const _prefThemeMode = 'pref_theme_mode_v1';
  static const _prefThemeVariant = 'pref_theme_variant_v1';

  Future<void> _initializeThemePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final modeIndex = prefs.getInt(_prefThemeMode);
      final variantIndex = prefs.getInt(_prefThemeVariant);
      if (modeIndex != null &&
          modeIndex >= 0 &&
          modeIndex < ThemeMode.values.length) {
        _mode = ThemeMode.values[modeIndex];
      }
      if (variantIndex != null &&
          variantIndex >= 0 &&
          variantIndex < ThemeVariant.values.length) {
        _variant = ThemeVariant.values[variantIndex];
      }
      if (mounted) setState(() {});
    } catch (_) {
      // ignore
    }
  }

  Future<void> _initializeLanguageManager() async {
    await _languageManager.initialize();
  }

  Future<void> _initializeNotifications() async {
    try {
      await NotificationSettingsRepository.instance.initialize();
      await NotificationService.instance.initialize();
      await NotificationService.instance.applySettings(
        NotificationSettingsRepository.instance,
      );

      // Initialize habit reminders
      await _initializeHabitReminders();
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error initializing notifications: $e');
      // ignore failures so they do not block app launch
    }
  }

  /// Initialize subscription/premium system.
  /// Loads premium status from storage and sets up purchase listeners.
  /// Also syncs Firebase Custom Claims (from admin-granted premium).
  Future<void> _initializeSubscriptionSystem() async {
    try {
      debugPrint('🔄 Initializing subscription system...');
      // Initialize premium manager (loads from SharedPreferences)
      await PremiumManager.instance.init();
      // Initialize IAP service (sets up Google Play billing)
      await IAPService.instance.init();

      // Sync Firebase Custom Claims with PremiumManager
      // This checks if admin granted premium via setCustomUserClaims
      await _syncFirebasePremiumClaims();

      debugPrint('✅ Subscription system initialized');
    } catch (e) {
      debugPrint('❌ Error initializing subscription system: $e');
      // Continue app launch even if subscription init fails
    }
  }

  /// Sync Firebase Custom Claims with local PremiumManager.
  /// If user has premium: true in their Firebase token, enable locally.
  /// If user does NOT have premium claim, clear local premium status.
  Future<void> _syncFirebasePremiumClaims() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint('[Premium] No user signed in, clearing local premium');
        // No user = no premium entitlement from Firebase
        if (PremiumManager.instance.isPremium) {
          await PremiumManager.instance.setPremium(false);
        }
        return;
      }

      // Force refresh to get latest custom claims
      final tokenResult = await user.getIdTokenResult(true);
      final claims = tokenResult.claims;
      final firebasePremium = claims?['premium'] == true;

      debugPrint(
        '[Premium] Firebase claims check: premium=$firebasePremium, local=${PremiumManager.instance.isPremium}',
      );

      if (firebasePremium && !PremiumManager.instance.isPremium) {
        // Firebase says premium but local doesn't know - sync it
        debugPrint('[Premium] Syncing Firebase premium=true to local storage');
        await PremiumManager.instance.setPremium(true);
      } else if (!firebasePremium && PremiumManager.instance.isPremium) {
        // Firebase says NOT premium but local thinks it is - clear it
        debugPrint(
          '[Premium] Firebase says NOT premium, clearing local premium',
        );
        await PremiumManager.instance.setPremium(false);
      }
    } catch (e) {
      debugPrint('[Premium] Error syncing Firebase claims: $e');
    }
  }

  Future<void> _initializeHabitReminders() async {
    try {
      if (kDebugMode) debugPrint('🔍 Initializing habit reminders...');
      final repo = HabitRepository.instance;
      await repo.initialize();
      final habits = repo.habits;
      if (kDebugMode) debugPrint('   Found ${habits.length} habits');

      int reminderCount = 0;
      for (final habit in habits) {
        if (kDebugMode) debugPrint('   Checking habit: ${habit.title}');
        if (kDebugMode) {
          debugPrint('     - reminderEnabled: ${habit.reminderEnabled}');
        }
        if (kDebugMode) {
          debugPrint('     - reminderTime: ${habit.reminderTime}');
        }

        if (habit.reminderEnabled && habit.reminderTime != null) {
          reminderCount++;
          await NotificationService.instance.scheduleHabitReminder(habit);
        }
      }
      if (kDebugMode) {
        debugPrint('✅ Initialized $reminderCount habit reminders');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error initializing habit reminders: $e');
      // ignore failures
    }
  }

  @override
  void dispose() {
    _languageManager.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
  }

  Future<void> _persistTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_prefThemeMode, _mode.index);
      await prefs.setInt(_prefThemeVariant, _variant.index);
    } catch (_) {
      // ignore
    }
  }

  void _toggleTheme() {
    setState(() {
      _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
    _persistTheme();
    // Update widgets with new theme
    HomeWidgetService.instance.updateThemeData(isDark: _mode == ThemeMode.dark);
  }

  void _changeThemeVariant(ThemeVariant variant) {
    setState(() => _variant = variant);
    _persistTheme();
    // Update widgets with new theme
    HomeWidgetService.instance.updateThemeData(isDark: _mode == ThemeMode.dark);
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        navigatorKey: NotificationService.navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Mira',
        locale: _languageManager.currentLocale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: _languageManager.supportedLocales,
        theme: AppTheme.light(_variant),
        darkTheme: AppTheme.dark(_variant),
        themeMode: _mode,
        home: OnboardingCheckWrapper(
          onToggleTheme: _toggleTheme,
          themeMode: _mode,
          currentVariant: _variant,
          onVariantChanged: _changeThemeVariant,
          languageManager: _languageManager,
        ),
      );
}

/// Wrapper widget that checks onboarding status and shows appropriate screen
class OnboardingCheckWrapper extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;
  final ThemeVariant currentVariant;
  final ValueChanged<ThemeVariant> onVariantChanged;
  final LanguageManager languageManager;

  const OnboardingCheckWrapper({
    super.key,
    required this.onToggleTheme,
    required this.themeMode,
    required this.currentVariant,
    required this.onVariantChanged,
    required this.languageManager,
  });

  @override
  State<OnboardingCheckWrapper> createState() => _OnboardingCheckWrapperState();
}

class _OnboardingCheckWrapperState extends State<OnboardingCheckWrapper> {
  bool _showSplash = true;
  bool? _isOnboardingCompleted;
  bool _authInitialized = false;
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
    // Listen to auth changes to update UI after sign-in
    AuthRepository.instance.addListener(_onAuthChanged);
  }

  Future<void> _initializeApp() async {
    // Initialize auth (silent sign-in) and check onboarding status in parallel
    try {
      await AuthRepository.instance.initialize();
    } catch (_) {}
    final isCompleted = await OnboardingRepository().isOnboardingCompleted();
    if (!mounted) return;
    setState(() {
      _isOnboardingCompleted = isCompleted;
      _authInitialized = true;
      _isSignedIn = AuthRepository.instance.isSignedIn;
    });
  }

  void _onSplashComplete() {
    setState(() {
      _showSplash = false;
    });
  }

  void _onAuthChanged() {
    if (!mounted) return;
    setState(() {
      _isSignedIn = AuthRepository.instance.isSignedIn;
    });
  }

  @override
  void dispose() {
    AuthRepository.instance.removeListener(_onAuthChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show splash screen first
    if (_showSplash) {
      return SplashScreen(onInitializationComplete: _onSplashComplete);
    }

    // If checks are still loading after splash, keep showing splash briefly
    if (_isOnboardingCompleted == null || !_authInitialized) {
      return SplashScreen(onInitializationComplete: _onSplashComplete);
    }

    // If onboarding is not completed, require Google sign-in first
    if (!_isOnboardingCompleted!) {
      if (!_isSignedIn) {
        return const SignInScreen();
      }
      // Show test choice screen with callbacks to update wrapper state
      return TestChoiceScreen(
        onSkip: () async {
          final isCompleted =
              await OnboardingRepository().isOnboardingCompleted();
          if (!mounted) return;
          setState(() => _isOnboardingCompleted = isCompleted);
        },
        onStart: () async {
          // when returning from onboarding, refresh flag
          // We attach a post-frame callback to check later
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            final isCompleted =
                await OnboardingRepository().isOnboardingCompleted();
            if (!mounted) return;
            setState(() => _isOnboardingCompleted = isCompleted);
          });
        },
      );
    }

    // Show main home page if completed
    return PrototypeHomePage(
      onToggleTheme: widget.onToggleTheme,
      themeMode: widget.themeMode,
      currentVariant: widget.currentVariant,
      onVariantChanged: widget.onVariantChanged,
      languageManager: widget.languageManager,
    );
  }
}

class PrototypeHomePage extends StatefulWidget {
  const PrototypeHomePage({
    super.key,
    required this.onToggleTheme,
    required this.themeMode,
    required this.currentVariant,
    required this.onVariantChanged,
    required this.languageManager,
  });
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;
  final ThemeVariant currentVariant;
  final ValueChanged<ThemeVariant> onVariantChanged;
  final LanguageManager languageManager;
  @override
  State<PrototypeHomePage> createState() => _PrototypeHomePageState();
}

class _PrototypeHomePageState extends State<PrototypeHomePage> {
  int _currentIndex = 0;
  late final PageController _pageController;
  final GlobalKey<HabitScreenState> _habitKey = GlobalKey<HabitScreenState>();
  final GlobalKey<FutureScreenState> _futureKey =
      GlobalKey<FutureScreenState>();
  int _futureSubIndex = 0;
  final GlobalKey<FinanceScreenState> _financeKey =
      GlobalKey<FinanceScreenState>();
  final ValueNotifier<bool> _visionFreeform = ValueNotifier(false);
  final ValueNotifier<bool> _visionRoundCorners = ValueNotifier(true);
  final ValueNotifier<bool> _visionShowText = ValueNotifier(true);
  final ValueNotifier<bool> _visionShowProgress = ValueNotifier(false);
  late final StreamSubscription<int> _xpSub;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onNavTap(int i) {
    if (_currentIndex != i) {
      setState(() => _currentIndex = i);
    }
    _pageController.animateToPage(
      i,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int i) {
    if (i == 0 && _currentIndex != 0) {
      _habitKey.currentState?.reanimate();
    }
    setState(() => _currentIndex = i);
  }

  void _handleAssistantNavigation(String command) {
    if (command == 'habits' || command == 'schedule' || command == 'weekly') {
      _onNavTap(0);
      if (command == 'weekly' || command == 'schedule') {
        _habitKey.currentState?.switchToWeekly();
      } else {
        _habitKey.currentState?.switchToToday();
      }
    } else if (command == 'timer') {
      _onNavTap(1);
    } else if (command == 'social' || command == 'rooms') {
      _onNavTap(2);
    } else if (command == 'vision' || command == 'finance' || command == 'future') {
      _onNavTap(3);
      if (command == 'finance') {
        _futureKey.currentState?.switchToTab(1);
      } else if (command == 'vision') {
        _futureKey.currentState?.switchToTab(0);
      }
    } else if (command == 'profile') {
      _openProfile(context);
    } else if (command == 'settings') {
      _openSettings(context);
    }
  }

  void _openProfile(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isTr = l10n.localeName.startsWith('tr');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: Text(isTr ? 'Profil' : 'Profile'),
            actions: [
              IconButton(
                tooltip: l10n.settings,
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => _openSettings(context),
              ),
            ],
          ),
          body: const ProfileScreen(),
        ),
      ),
    );
  }

  void _openSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SettingsScreen(
          onToggleTheme: widget.onToggleTheme,
          themeMode: widget.themeMode,
          currentVariant: widget.currentVariant,
          onVariantChanged: widget.onVariantChanged,
          languageManager: widget.languageManager,
        ),
      ),
    );
  }

  Widget _buildPage(int index) => switch (index) {
        0 => HabitScreen(
            key: _habitKey,
            variant: widget.currentVariant,
            onViewModeChanged: (mode) {
              setState(() {});
            },
            onDateChanged: (date) {
              setState(() {});
            },
            onOpenGoals: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => VisionScreen(
                    variant: widget.currentVariant,
                    freeformNotifier: _visionFreeform,
                    roundCornersNotifier: _visionRoundCorners,
                    showTextNotifier: _visionShowText,
                    showProgressNotifier: _visionShowProgress,
                    boardBoundaryKey: _visionBoardKey,
                  ),
                ),
              );
            },
          ),
        1 => TimerScreen(
            variant: widget.currentVariant,
            showAppBar: false,
          ),
        2 => const SocialHubScreen(
            showAppBar: false,
          ),
        3 => FutureScreen(
            key: _futureKey,
            variant: widget.currentVariant,
            initialSubTab: _futureSubIndex,
            onSubTabChanged: (i) {
              setState(() => _futureSubIndex = i);
            },
            onMonthChanged: (_) {
              setState(() {});
            },
            visionFreeformNotifier: _visionFreeform,
            visionRoundCornersNotifier: _visionRoundCorners,
            visionShowTextNotifier: _visionShowText,
            visionShowProgressNotifier: _visionShowProgress,
            visionBoardBoundaryKey: _visionBoardKey,
            financeKey: _financeKey,
          ),
        _ => const SizedBox.shrink(),
      };

  Widget _buildBody() => PageView.builder(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        // Disable outer swipe so child screens (HabitScreen today/weekly, Finance tabs)
        // have full control over horizontal swipe gestures without navigating to Timer
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        itemBuilder: (context, index) => _buildPage(index),
      );

  String _titleFor(int i, BuildContext context, AppLocalizations l10n) => switch (i) {
        0 => _habitKey.currentState?.title(context, l10n) ?? l10n.today,
        1 => l10n.timerType,
        2 => l10n.socialRoomsTitle,
        3 => l10n.finance,
        _ => '',
      };

  Widget _buildTimerTitlePill(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme cs,
    bool isDark,
    ThemeData theme,
  ) {
    return AnimatedBuilder(
      animation: TimerController.instance,
      builder: (context, _) {
        final controller = TimerController.instance;
        final isRunning = controller.isRunning;
        final activeHabitId = controller.activeTimerHabitId;
        String modeName = l10n.timerTabStopwatch;
        if (controller.activeMode == TimerMode.countdown) {
          modeName = l10n.timerTabCountdown;
        } else if (controller.activeMode == TimerMode.pomodoro) {
          modeName = l10n.timerTabPomodoro;
        }
        String pillLabel = l10n.timerType;
        if (activeHabitId != null) {
          final h = HabitRepository.instance.findById(activeHabitId);
          if (h != null) pillLabel = h.title;
        }

        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: isDark ? cs.surfaceContainerHigh : Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.12)
                  : Colors.white.withValues(alpha: 0.95),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isDark ? 0.25 : 0.05,
                ),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
              if (!isDark)
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.8),
                  blurRadius: 2,
                  offset: const Offset(0, -1),
                ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: isRunning
                      ? Colors.green.withValues(alpha: 0.15)
                      : cs.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isRunning
                      ? Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green,
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        )
                      : Icon(
                          Icons.timer_outlined,
                          size: 13,
                          color: cs.primary,
                        ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  pillLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    letterSpacing: -0.2,
                    color: cs.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Text(
                '• $modeName',
                style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.5),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSocialTitlePill(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme cs,
    bool isDark,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: isDark ? cs.surfaceContainerHigh : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.12)
              : Colors.white.withValues(alpha: 0.95),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.25 : 0.05,
            ),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
          if (!isDark)
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.8),
              blurRadius: 2,
              offset: const Offset(0, -1),
            ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.group_rounded,
              size: 14,
              color: Color(0xFF6366F1),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _titleFor(2, context, l10n),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              letterSpacing: -0.2,
              color: cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceTitlePill(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme cs,
    bool isDark,
    ThemeData theme,
  ) {
    final currentMonth =
        _financeKey.currentState?.currentMonth ?? DateTime.now();
    final locale = Localizations.localeOf(context).toString();
    final rawMonth = DateFormat('MMMM yyyy', locale).format(currentMonth);
    final monthLabel = rawMonth.isNotEmpty
        ? rawMonth[0].toUpperCase() + rawMonth.substring(1)
        : rawMonth;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          _financeKey.currentState?.showMonthPicker();
        },
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: isDark ? cs.surfaceContainerHigh : Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.12)
                  : Colors.white.withValues(alpha: 0.95),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isDark ? 0.25 : 0.05,
                ),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
              if (!isDark)
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.8),
                  blurRadius: 2,
                  offset: const Offset(0, -1),
                ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  size: 14,
                  color: Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                monthLabel,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  letterSpacing: -0.2,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: cs.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    NotificationService.instance.updateLocalizations(l10n);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: false,
        // Remove overrides to let ThemeVariations apply Cotton style (surface color + shadow)
        title: _currentIndex == 0
            ? Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _habitKey.currentState?.showCalendar();
                  },
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? cs.surfaceContainerHigh
                          : Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.12)
                            : Colors.white.withValues(alpha: 0.95),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: isDark ? 0.25 : 0.05,
                          ),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                        if (!isDark)
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.8),
                            blurRadius: 2,
                            offset: const Offset(0, -1),
                          ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: cs.primary.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _habitKey.currentState?.isWeeklyView ?? false
                                ? Icons.calendar_view_week_rounded
                                : Icons.calendar_today_rounded,
                            size: 14,
                            color: cs.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _titleFor(0, context, l10n),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            letterSpacing: -0.2,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 18,
                          color: cs.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : _currentIndex == 1
                ? _buildTimerTitlePill(context, l10n, cs, isDark, theme)
                : _currentIndex == 2
                    ? _buildSocialTitlePill(context, l10n, cs, isDark, theme)
                    : _buildFinanceTitlePill(context, l10n, cs, isDark, theme),
        actions: [
          // Mood button for Habits screen (only in today mode)
          if (_currentIndex == 0 &&
              !(_habitKey.currentState?.isWeeklyView ?? false))
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? cs.surfaceContainerHigh
                      : Colors.white,
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.12)
                        : Colors.white.withValues(alpha: 0.95),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.25 : 0.05,
                      ),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                    if (!isDark)
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.8),
                        blurRadius: 2,
                        offset: const Offset(0, -1),
                      ),
                  ],
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 20,
                  tooltip: l10n.mood,
                  icon: const Icon(Icons.mood_outlined),
                  onPressed: () => _habitKey.currentState?.openMoodScreen(),
                ),
              ),
            ),
          // 3-dots popup menu on Habits screen (Filter, Lists, Settings/Profile)
          if (_currentIndex == 0)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? cs.surfaceContainerHigh
                      : Colors.white,
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.12)
                        : Colors.white.withValues(alpha: 0.95),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.25 : 0.05,
                      ),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                    if (!isDark)
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.8),
                        blurRadius: 2,
                        offset: const Offset(0, -1),
                      ),
                  ],
                ),
                child: PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  iconSize: 20,
                  tooltip: l10n.localeName.startsWith('tr') ? 'Seçenekler' : 'Options',
                  icon: const Icon(Icons.more_vert),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: cs.surface,
                  elevation: 6,
                  onSelected: (value) {
                    if (value == 'filter') {
                      _habitKey.currentState?.showFilterSheet();
                    } else if (value == 'lists') {
                      _habitKey.currentState?.openManageListsSheet();
                    } else if (value == 'profile') {
                      _openProfile(context);
                    } else if (value == 'settings') {
                      _openSettings(context);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'filter',
                      child: Row(
                        children: [
                          Icon(
                            Icons.tune_rounded,
                            size: 20,
                            color: cs.onSurface,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            l10n.localeName.startsWith('tr')
                                ? 'Filtrele'
                                : l10n.filterTitle,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'lists',
                      child: Row(
                        children: [
                          Icon(
                            Icons.format_list_bulleted_rounded,
                            size: 20,
                            color: cs.onSurface,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            l10n.localeName.startsWith('tr')
                                ? 'Listeler'
                                : l10n.manageLists,
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                      value: 'profile',
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_outline_rounded,
                            size: 20,
                            color: cs.onSurface,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            l10n.localeName.startsWith('tr')
                                ? 'Profil'
                                : 'Profile',
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'settings',
                      child: Row(
                        children: [
                          Icon(
                            Icons.settings_outlined,
                            size: 20,
                            color: cs.onSurface,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            l10n.localeName.startsWith('tr')
                                ? 'Ayarlar'
                                : l10n.settings,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Timer actions (index 1)
          if (_currentIndex == 1) ...[
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: AnimatedBuilder(
                animation: TimerController.instance,
                builder: (context, _) {
                  final isHardMode = TimerController.instance.hardMode;
                  return Tooltip(
                    message: l10n.hardMode,
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isHardMode
                            ? Colors.red.withValues(alpha: isDark ? 0.22 : 0.12)
                            : (isDark ? cs.surfaceContainerHigh : Colors.white),
                        border: Border.all(
                          color: isHardMode
                              ? Colors.red.withValues(alpha: 0.5)
                              : (isDark
                                  ? Colors.white.withValues(alpha: 0.12)
                                  : Colors.white.withValues(alpha: 0.95)),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isHardMode
                                ? Colors.red.withValues(alpha: 0.15)
                                : Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                          if (!isDark && !isHardMode)
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.8),
                              blurRadius: 2,
                              offset: const Offset(0, -1),
                            ),
                        ],
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 18,
                        icon: Icon(
                          isHardMode ? Icons.lock_rounded : Icons.lock_open_rounded,
                          color: isHardMode ? Colors.red : cs.onSurface.withValues(alpha: 0.75),
                        ),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          TimerController.instance.toggleHardMode();
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Tooltip(
                message: 'Masa Saati / Yatay Mod',
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? cs.surfaceContainerHigh : Colors.white,
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.12)
                          : Colors.white.withValues(alpha: 0.95),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                      if (!isDark)
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.8),
                          blurRadius: 2,
                          offset: const Offset(0, -1),
                        ),
                    ],
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 19,
                    icon: Icon(
                      Icons.stay_current_landscape_rounded,
                      color: cs.onSurface.withValues(alpha: 0.75),
                    ),
                    onPressed: () async {
                      if (!await requirePremium(context)) return;
                      if (!context.mounted) return;
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              LandscapeTimerScreen(variant: widget.currentVariant),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],

          // Social actions (index 2)
          if (_currentIndex == 2)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? cs.surfaceContainerHigh : Colors.white,
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.12)
                        : Colors.white.withValues(alpha: 0.95),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.25 : 0.05,
                      ),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                    if (!isDark)
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.8),
                        blurRadius: 2,
                        offset: const Offset(0, -1),
                      ),
                  ],
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 19,
                  tooltip: l10n.roomFabLabel,
                  icon: Icon(
                    Icons.group_add_rounded,
                    color: cs.onSurface.withValues(alpha: 0.75),
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    SocialHubScreen.showFabOptions(context);
                  },
                ),
              ),
            ),

          // Finance actions (index 3)
          if (_currentIndex == 3) ...[
            if (!(_financeKey.currentState?.isViewingCurrentMonth ?? true))
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? cs.surfaceContainerHigh : Colors.white,
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.12)
                          : Colors.white.withValues(alpha: 0.95),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.25 : 0.05,
                        ),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                      if (!isDark)
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.8),
                          blurRadius: 2,
                          offset: const Offset(0, -1),
                        ),
                    ],
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 19,
                    tooltip: l10n.localeName.startsWith('tr')
                        ? 'Bu Aya Dön'
                        : l10n.thisMonth,
                    icon: const Icon(Icons.today_rounded),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      _financeKey.currentState?.selectCurrentMonth();
                    },
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? cs.surfaceContainerHigh : Colors.white,
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.12)
                        : Colors.white.withValues(alpha: 0.95),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.25 : 0.05,
                      ),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                    if (!isDark)
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.8),
                        blurRadius: 2,
                        offset: const Offset(0, -1),
                      ),
                  ],
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 19,
                  tooltip: l10n.localeName.startsWith('tr')
                      ? 'AI Belge / Fiş Tara'
                      : 'AI Statement Import',
                  icon: const Icon(Icons.document_scanner_outlined),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _financeKey.currentState?.pickAndAnalyzeStatement();
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? cs.surfaceContainerHigh : Colors.white,
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.12)
                        : Colors.white.withValues(alpha: 0.95),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.25 : 0.05,
                      ),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                    if (!isDark)
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.8),
                        blurRadius: 2,
                        offset: const Offset(0, -1),
                      ),
                  ],
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 19,
                  tooltip: l10n.localeName.startsWith('tr')
                      ? 'Finansal Analiz'
                      : 'Analytics',
                  icon: const Icon(Icons.insights_rounded),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _financeKey.currentState?.openAnalysisScreen();
                  },
                ),
              ),
            ),
          ],
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: CottonBottomBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onNavTap,
        variant: widget.currentVariant,
        onActionPressed: () =>
            showQuickCreateSheet(context, variant: widget.currentVariant),
        destinations: [
          CottonDestination(
            icon: Icons.wb_sunny_outlined,
            selectedIcon: Icons.wb_sunny_rounded,
            label: l10n.today,
          ),
          CottonDestination(
            icon: Icons.timer_outlined,
            selectedIcon: Icons.timer_rounded,
            label: l10n.timerType,
          ),
          CottonDestination(
            icon: Icons.groups_outlined,
            selectedIcon: Icons.groups_rounded,
            label: l10n.social,
          ),
          CottonDestination(
            icon: Icons.account_balance_wallet_outlined,
            selectedIcon: Icons.account_balance_wallet_rounded,
            label: l10n.finance,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    // Listen to XP gains and show a small animated toast
    GamificationRepository.instance.initialize();
    _xpSub = GamificationRepository.instance.xpGains.listen((gain) {
      if (!mounted) return;
      final color = Theme.of(context).colorScheme.primary;
      _showXpCelebration(gain, color);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _xpSub.cancel();
    super.dispose();
  }

  void _showXpCelebration(int gain, Color color) {
    final overlay = Overlay.of(context);
    final media = MediaQuery.of(context);
    final double targetTop = media.padding.top + 16;
    final entry = OverlayEntry(
      builder: (ctx) => Positioned(
        top: targetTop,
        left: 0,
        right: 0,
        child: Align(
          alignment: Alignment.topCenter,
          child: IgnorePointer(
            child: XpCelebrationToast(
              amount: gain,
              primaryColor: color,
            ),
          ),
        ),
      ),
    );
    overlay.insert(entry);
    Future.delayed(const Duration(milliseconds: 2700), () {
      if (entry.mounted) entry.remove();
    });
  }

  void _showFreeformSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.ios_share_outlined),
              title: Text(AppLocalizations.of(context).shareBoard),
              onTap: () async {
                Navigator.pop(ctx);
                await _shareVisionBoard(context);
              },
            ),
            const Divider(height: 1),
            ValueListenableBuilder<bool>(
              valueListenable: _visionRoundCorners,
              builder: (_, val, __) => SwitchListTile(
                title: Text(AppLocalizations.of(context).roundCorners),
                value: val,
                onChanged: (v) => _visionRoundCorners.value = v,
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _visionShowText,
              builder: (_, val, __) => SwitchListTile(
                title: Text(AppLocalizations.of(context).showText),
                value: val,
                onChanged: (v) => _visionShowText.value = v,
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _visionShowProgress,
              builder: (_, val, __) => SwitchListTile(
                title: Text(AppLocalizations.of(context).showProgress),
                value: val,
                onChanged: (v) => _visionShowProgress.value = v,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  final GlobalKey _visionBoardKey = GlobalKey();

  Future<void> _shareVisionBoard(BuildContext context) async {
    try {
      // Find the boundary in the currently built VisionScreen
      final boundary = _visionBoardKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return;
      // Render to image
      final ui.Image image = await boundary.toImage(pixelRatio: 4.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      if (byteData == null) return;
      final bytes = byteData.buffer.asUint8List();
      // Share directly from memory (no temp file needed)
      final xfile = XFile.fromData(
        bytes,
        name: 'vision_board.png',
        mimeType: 'image/png',
      );
      await SharePlus.instance.share(
        ShareParams(text: AppLocalizations.of(context).myBoard, files: [xfile]),
      );
    } catch (_) {
      // silent
    }
  }

  // Creation actions for text/image stickers are owned by Vision screen's FAB now.

  Color _getGradientColor(BuildContext context) {
    // Panel için mor renk
    return AppColors.accentPurple;
  }
}

