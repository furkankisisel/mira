import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'dart:ui' as ui;
// removed dart:math; not needed for minimal XP toast
import 'package:share_plus/share_plus.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'design_system/theme/app_theme.dart';
import 'design_system/theme/theme_variations.dart';
import 'design_system/tokens/colors.dart';
import 'design_system/components/cotton_bottom_bar.dart';
import 'core/language_manager.dart';

import 'features/habit/presentation/habit_screen.dart';
import 'features/timer/timer_screen.dart';
import 'features/finance/finance_screen.dart';
import 'features/finance/finance_analysis_screen.dart';
import 'features/vision/presentation/vision_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/schedule/presentation/weekly_schedule_screen.dart';

import 'features/profile/settings_screen.dart';
// Removed Decision Egg feature
import 'features/gamification/gamification_repository.dart';
import 'features/notifications/data/notification_settings_repository.dart';
import 'features/notifications/services/notification_service.dart';
import 'features/habit/domain/habit_repository.dart';
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
import 'features/reports/presentation/reports_screen.dart';

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
  final GlobalKey<FinanceScreenState> _financeKey =
      GlobalKey<FinanceScreenState>();
  final ValueNotifier<bool> _visionFreeform = ValueNotifier(false);
  final ValueNotifier<bool> _visionRoundCorners = ValueNotifier(true);
  final ValueNotifier<bool> _visionShowText = ValueNotifier(true);
  final ValueNotifier<bool> _visionShowProgress = ValueNotifier(false);
  late final StreamSubscription<int> _xpSub;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onNavTap(int i) {
    _pageController.animateToPage(
      i,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int i) => setState(() => _currentIndex = i);

  void _handleAssistantNavigation(String command) {
    if (command == 'habits') {
      _onNavTap(0);
    } else if (command == 'vision') {
      _onNavTap(1);
    } else if (command == 'finance') {
      _onNavTap(3);
    }
  }

  Widget _buildPage(int index) => switch (index) {
        0 => HabitScreen(key: _habitKey, variant: widget.currentVariant),
        1 => VisionScreen(
            variant: widget.currentVariant,
            freeformNotifier: _visionFreeform,
            roundCornersNotifier: _visionRoundCorners,
            showTextNotifier: _visionShowText,
            showProgressNotifier: _visionShowProgress,
            boardBoundaryKey: _visionBoardKey,
          ),
        2 => WeeklyScheduleScreen(
            variant: widget.currentVariant,
          ),
        3 => FinanceScreen(key: _financeKey, variant: widget.currentVariant),
        4 => const ProfileScreen(),
        _ => const SizedBox.shrink(),
      };

  Widget _buildBody() => PageView.builder(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        // Disable swipe on Vision screen (index 1) to prevent accidental navigation
        physics: (_currentIndex == 1)
            ? const NeverScrollableScrollPhysics()
            : const PageScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) => _buildPage(index),
      );

  String _titleFor(int i, AppLocalizations l10n) => switch (i) {
        0 => l10n.habits,
        1 => l10n.vision,
        2 => l10n.weeklySchedule,
        3 => l10n.finance,
        4 => l10n.profile,
        _ => '',
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    NotificationService.instance.updateLocalizations(l10n);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: false,
        // Remove overrides to let ThemeVariations apply Cotton style (surface color + shadow)
        title: _currentIndex == 0
            ? GestureDetector(
                onTap: () => _habitKey.currentState?.showCalendar(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.today),
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_down, size: 20),
                  ],
                ),
              )
            : Text(_titleFor(_currentIndex, l10n)),
        actions: [
          // Mood button for Habits screen
          if (_currentIndex == 0)
            IconButton(
              tooltip: l10n.mood,
              icon: const Icon(Icons.mood_outlined),
              onPressed: () => _habitKey.currentState?.openMoodScreen(),
            ),
          // Weekly Schedule screen actions (index 2)
          if (_currentIndex == 2)
            IconButton(
              tooltip: l10n.weeklyReportsTitle,
              icon: const Icon(Icons.analytics_outlined),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ReportsScreen(),
                  ),
                );
              },
            ),
          // Vision actions (index 1)
          if (_currentIndex == 1)
            ValueListenableBuilder<bool>(
              valueListenable: _visionFreeform,
              builder: (context, isFreeform, _) => isFreeform
                  ? IconButton(
                      tooltip: l10n.visionSettingsTooltip,
                      icon: const Icon(Icons.tune),
                      onPressed: () => _showFreeformSettings(context),
                    )
                  : const SizedBox.shrink(),
            ),
          if (_currentIndex == 1)
            ValueListenableBuilder<bool>(
              valueListenable: _visionFreeform,
              builder: (context, isFreeform, _) => IconButton(
                tooltip: isFreeform
                    ? l10n.visionBoardViewTooltip
                    : l10n.visionFreeformTooltip,
                icon: Icon(isFreeform ? Icons.grid_view : Icons.open_in_full),
                onPressed: () => _visionFreeform.value = !isFreeform,
              ),
            ),
          if (_currentIndex == 0)
            IconButton(
              tooltip: l10n.timerType,
              icon: const Icon(Icons.timer_outlined),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => TimerScreen(variant: widget.currentVariant),
                  ),
                );
              },
            ),
          // Finance actions (index 3)
          if (_currentIndex == 3)
            IconButton(
              tooltip: l10n.selectMonthTooltip,
              icon: const Icon(Icons.calendar_month_outlined),
              onPressed: () => _financeKey.currentState?.showMonthPicker(),
            ),
          if (_currentIndex == 3)
            IconButton(
              tooltip: l10n.analysisTooltip,
              icon: const Icon(Icons.insights_outlined),
              onPressed: () {
                final month =
                    _financeKey.currentState?.currentMonth ?? DateTime.now();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => FinanceAnalysisScreen(
                      month: DateTime(month.year, month.month, 1),
                      variant: widget.currentVariant,
                    ),
                  ),
                );
              },
            ),
          // Profile Actions (Settings)
          if (_currentIndex == 4)
            IconButton(
              tooltip: l10n.settings,
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {
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
              },
            ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: CottonBottomBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onNavTap,
        variant: widget.currentVariant,
        destinations: [
          CottonDestination(
            icon: Icons.wb_sunny_outlined,
            selectedIcon: Icons.wb_sunny,
            label: l10n.today,
          ),
          CottonDestination(
            icon: Icons.terrain_outlined,
            selectedIcon: Icons.terrain,
            label: l10n.vision,
          ),
          CottonDestination(
            icon: Icons.calendar_view_week_outlined,
            selectedIcon: Icons.calendar_view_week,
            label: l10n.weeklySchedule,
          ),
          CottonDestination(
            icon: Icons.water_drop_outlined,
            selectedIcon: Icons.water_drop,
            label: l10n.finance,
          ),
          CottonDestination(
            icon: Icons.person_outlined,
            selectedIcon: Icons.person,
            label: l10n.profile,
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
    final double targetTop = media.padding.top + (kToolbarHeight / 2) - 8;
    final entry = OverlayEntry(
      builder: (ctx) => Positioned(
        top: targetTop,
        left: 0,
        right: 0,
        child: IgnorePointer(
          child: _XpMinimalToast(amount: gain, color: color),
        ),
      ),
    );
    overlay.insert(entry);
    Future.delayed(const Duration(milliseconds: 3300), () {
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

class _XpMinimalToast extends StatefulWidget {
  const _XpMinimalToast({required this.amount, required this.color});
  final int amount;
  final Color color;

  @override
  State<_XpMinimalToast> createState() => _XpMinimalToastState();
}

class _XpMinimalToastState extends State<_XpMinimalToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _morph; // 0 → 1 → 0 (dot → pill → dot)
  late final Animation<double> _fadeIn;
  late final Animation<double> _fadeOut;
  late final Animation<double> _offsetY; // drop into AppBar then rise back
  // Offset removed for pill open/close effect centered on AppBar

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _morph = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 50,
      ),
      // slight hold at full pill
      TweenSequenceItem(
        tween: ConstantTween(1.0),
        weight: 50, // much longer plateau at full pill
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInCubic)),
        weight: 35,
      ),
    ]).animate(_c);
    _offsetY = TweenSequence<double>([
      // drop from above (-32) to center (0)
      TweenSequenceItem(
        tween: Tween(
          begin: -36.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeOutQuad)),
        weight: 40,
      ),
      // hold in center
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 30),
      // rise back up
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: -36.0,
        ).chain(CurveTween(curve: Curves.easeInQuad)),
        weight: 30,
      ),
    ]).animate(_c);
    _fadeIn = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.02, 0.14, curve: Curves.easeOut),
    );
    _fadeOut = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.92, 1.0, curve: Curves.easeIn),
    );
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        // Morph dot → pill → dot around AppBar center
        final opacity = _fadeIn.value * (1 - _fadeOut.value + 1e-6);
        final g = _morph.value.clamp(0.0, 1.0);

        // Text style and target width measurement
        // Use black text on light theme for readability, white on dark
        final isLight = Theme.of(context).brightness == Brightness.light;
        final textStyle = TextStyle(
          color: isLight ? Colors.black : Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
          decoration: TextDecoration.none,
        );
        final text = '+${widget.amount} XP';
        final tp = TextPainter(
          text: const TextSpan(text: ''),
          textDirection: TextDirection.ltr,
        );
        tp.text = TextSpan(text: text, style: textStyle);
        tp.layout();
        final targetWidth = tp.width + 28; // 14px padding each side

        final width = ui.lerpDouble(6.0, targetWidth, g)!;
        final height = ui.lerpDouble(6.0, 28.0, g)!;
        final radius = height / 2;

        double smoothStep(double x, double a, double b) {
          if (x <= a) return 0.0;
          if (x >= b) return 1.0;
          final t = (x - a) / (b - a);
          return t.clamp(0.0, 1.0);
        }

        // Keep text visible while in pill form; fade in as it becomes a pill.
        // We tie it to morph (g) so plateau at g=1 keeps text fully visible.
        final textAppear = smoothStep(g, 0.35, 0.75);
        final textOpacity = (opacity * textAppear).clamp(0.0, 1.0);

        // Background opacity ramps with morph, softer at ends
        final tail = g < 0.15 ? g / 0.15 : (g > 0.85 ? (1 - g) / 0.15 : 1.0);
        final bgOpacity = 0.16 * tail.clamp(0.0, 1.0);

        return Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: Center(
            child: Transform.translate(
              offset: Offset(0, _offsetY.value),
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(bgOpacity),
                  borderRadius: BorderRadius.circular(radius),
                  boxShadow: [
                    if (bgOpacity > 0)
                      BoxShadow(
                        color: widget.color.withOpacity(0.18 * tail),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                alignment: Alignment.center,
                child: Opacity(
                  opacity: textOpacity,
                  child: Text(text, style: textStyle),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
