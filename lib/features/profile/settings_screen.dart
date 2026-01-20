import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../design_system/theme/theme_variations.dart';
import '../../design_system/components/theme_selector.dart';
import '../../design_system/components/language_selector.dart';
import '../../core/language_manager.dart';
import '../../core/settings/settings_repository.dart';
import '../notifications/presentation/notification_settings_screen.dart';
import 'privacy_security_screen.dart';
import 'auth_repository.dart';
import '../onboarding/presentation/onboarding_screen.dart';
import '../rhythm/presentation/rhythm_onboarding_screen.dart';
import '../../features/backup/backup_page.dart';
import '../../ui/manage_subscription_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/premium_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.onToggleTheme,
    required this.themeMode,
    required this.currentVariant,
    required this.onVariantChanged,
    required this.languageManager,
  });

  final VoidCallback? onToggleTheme;
  final ThemeMode? themeMode;
  final ThemeVariant? currentVariant;
  final ValueChanged<ThemeVariant>? onVariantChanged;
  final LanguageManager? languageManager;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    AuthRepository.instance.initialize();
    AuthRepository.instance.addListener(_onAuthChange);
  }

  @override
  void dispose() {
    AuthRepository.instance.removeListener(_onAuthChange);
    super.dispose();
  }

  void _onAuthChange() {
    if (mounted) setState(() {});
  }

  LanguageManager get _languageManager =>
      widget.languageManager ?? LanguageManager();

  String _getThemeText(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (widget.themeMode) {
      case ThemeMode.light:
        return l10n.lightTheme;
      case ThemeMode.dark:
        return l10n.darkTheme;
      case ThemeMode.system:
      default:
        return l10n.systemTheme;
    }
  }

  void _showThemeVariantSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: ThemeSelector(
            currentVariant: widget.currentVariant ?? ThemeVariant.matcha,
            onVariantChanged: (variant) {
              widget.onVariantChanged?.call(variant);
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  void _showLanguageSelector(BuildContext context) {
    showLanguageSelector(
      context: context,
      currentLanguage: _languageManager.currentLanguage,
      onLanguageChanged: (language) async {
        await _languageManager.changeLanguage(language);
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  Future<void> _handleSignOut(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.signOut),
        content: Text(l10n.signOutConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.signOut),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      context.read<PremiumProvider>().reset();
      await AuthRepository.instance.signOut();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        children: [
          const SizedBox(height: 12),
          _SettingsSection(
            title: l10n.appearance,
            children: [
              AnimatedBuilder(
                animation: SettingsRepository.instance,
                builder: (context, _) => SwitchListTile(
                  secondary: const Icon(Icons.local_fire_department_outlined),
                  title: Text(l10n.streakIndicator),
                  subtitle: Text(l10n.streakIndicatorDesc),
                  value: SettingsRepository.instance.showStreakIndicators,
                  onChanged: (v) =>
                      SettingsRepository.instance.setShowStreakIndicators(v),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(l10n.language),
                subtitle: Text(
                  '${_languageManager.currentLanguage.flag} ${_languageManager.currentLanguage.displayName}',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showLanguageSelector(context),
              ),
              ListTile(
                leading: const Icon(Icons.color_lens_outlined),
                title: Text(l10n.theme),
                subtitle: Text(_getThemeText(context)),
                trailing: Switch(
                  value: widget.themeMode == ThemeMode.dark,
                  onChanged: widget.onToggleTheme != null
                      ? (_) => widget.onToggleTheme!()
                      : null,
                ),
                onTap: widget.onToggleTheme,
              ),
              if (widget.currentVariant != null &&
                  widget.onVariantChanged != null)
                ListTile(
                  leading: const Icon(Icons.palette_outlined),
                  title: Text(l10n.colorTheme),
                  subtitle: Text(
                    widget.currentVariant?.getDisplayName(context) ?? '',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showThemeVariantSheet(context),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _SettingsSection(
            title: l10n.notifications,
            children: [
              ListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: Text(l10n.notificationSettings),
                subtitle: Text(l10n.notificationSettingsSubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => NotificationSettingsScreen(
                        variant: widget.currentVariant,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SettingsSection(
            title: l10n.backupRestore,
            children: [
              ListTile(
                leading: const Icon(Icons.backup_outlined),
                title: Text(l10n.backupRestore),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const BackupPage()),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SettingsSection(
            title: l10n.subscription,
            children: [
              ListTile(
                leading: const Icon(Icons.workspace_premium_outlined),
                title: Text(l10n.manageSubscription),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const ManageSubscriptionScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SettingsSection(
            title: l10n.testsSection,
            children: [
              ListTile(
                leading: const Icon(Icons.psychology_outlined),
                title: Text(l10n.retakePersonalityTest),
                subtitle: Text(l10n.retakePersonalityTestDesc),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const OnboardingScreen(
                        isRetake: true,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.schedule_outlined),
                title: Text(l10n.retakeRhythmTest),
                subtitle: Text(l10n.retakeRhythmTestDesc),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const RhythmOnboardingScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SettingsSection(
            title: l10n.privacySecurity,
            children: [
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: Text(l10n.privacySecurity),
                subtitle: Text(l10n.privacySecuritySubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const PrivacySecurityScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SettingsSection(
            title: l10n.account,
            children: [
              if (AuthRepository.instance.account == null)
                ListTile(
                  leading: const Icon(
                    Icons.login,
                    color: Colors.blue,
                  ), // Use app primary color locally or explicit color
                  title: Text(l10n.signInToSaveData),
                  subtitle: Text(l10n.guestAccount),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    await AuthRepository.instance.signIn();
                  },
                )
              else
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: Text(
                    l10n.signOut,
                    style: const TextStyle(color: Colors.red),
                  ),
                  onTap: () => _handleSignOut(context),
                ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Theme.of(
                context,
              ).colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (int i = 0; i < children.length; i++) ...[
                if (i > 0)
                  Divider(
                    height: 1,
                    indent: 16,
                    color: Theme.of(
                      context,
                    ).colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                children[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}
