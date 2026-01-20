import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../ui/subscription_screen.dart';
import '../../../services/premium_manager.dart';
import 'rhythm_onboarding_screen.dart';

/// Premium teaser screen shown after personality test
/// Promotes the Canlı Ritim feature to non-premium users
class RhythmTeaserScreen extends StatefulWidget {
  const RhythmTeaserScreen({super.key});

  @override
  State<RhythmTeaserScreen> createState() => _RhythmTeaserScreenState();
}

class _RhythmTeaserScreenState extends State<RhythmTeaserScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onViewPackages() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const SubscriptionScreen()),
    );

    // If user purchased premium, go to rhythm onboarding
    if (result == true || PremiumManager.instance.isPremium) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const RhythmOnboardingScreen()),
        );
      }
    }
  }

  void _onSkip() {
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.surface,
              colorScheme.primaryContainer.withOpacity(0.3),
              colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button at top right
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextButton(
                    onPressed: _onSkip,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.rhythmTeaserSkip,
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        // Animated DNA/Clock emoji
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  colorScheme.primary.withOpacity(0.2),
                                  colorScheme.tertiary.withOpacity(0.2),
                                ],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text(
                                '🧬✨',
                                style: TextStyle(fontSize: 48),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Main headline
                        Text(
                          l10n.rhythmTeaserTitle,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            height: 1.3,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 12),

                        Text(
                          l10n.rhythmTeaserSubtitle,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 32),

                        // Rhythm windows preview card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: colorScheme.primary.withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            children: [
                              _buildWindowRow(
                                '🧠',
                                l10n.rhythmWindowFocus,
                                l10n.rhythmWindowFocusDesc,
                                colorScheme,
                              ),
                              const SizedBox(height: 12),
                              _buildWindowRow(
                                '⚡',
                                l10n.rhythmWindowEnergy,
                                l10n.rhythmWindowEnergyDesc,
                                colorScheme,
                              ),
                              const SizedBox(height: 12),
                              _buildWindowRow(
                                '🌤️',
                                l10n.rhythmWindowLight,
                                l10n.rhythmWindowLightDesc,
                                colorScheme,
                              ),
                              const SizedBox(height: 12),
                              _buildWindowRow(
                                '🌙',
                                l10n.rhythmWindowReflection,
                                l10n.rhythmWindowReflectionDesc,
                                colorScheme,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Benefits list
                        _buildBenefitItem(
                          Icons.schedule_rounded,
                          l10n.rhythmBenefit1,
                          colorScheme,
                        ),
                        const SizedBox(height: 12),
                        _buildBenefitItem(
                          Icons.psychology_rounded,
                          l10n.rhythmBenefit2,
                          colorScheme,
                        ),
                        const SizedBox(height: 12),
                        _buildBenefitItem(
                          Icons.auto_awesome_rounded,
                          l10n.rhythmBenefit3,
                          colorScheme,
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom CTA button
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
                child: Column(
                  children: [
                    FilledButton(
                      onPressed: _onViewPackages,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star_rounded, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            l10n.rhythmTeaserCta,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWindowRow(
    String emoji,
    String title,
    String description,
    ColorScheme colorScheme,
  ) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 20)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitItem(
    IconData icon,
    String text,
    ColorScheme colorScheme,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface.withOpacity(0.85),
            ),
          ),
        ),
      ],
    );
  }
}
