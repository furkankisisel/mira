import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../l10n/app_localizations.dart';
import '../../design_system/components/primary_gradient_button.dart';


/// Tüm wizard ekranları için ortak scaffold yapısı
class WizardScaffold extends StatelessWidget {
  const WizardScaffold({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.child,
    this.onBack,
    this.onClose,
    this.showProgress = true,
  });

  final int currentStep;
  final int totalSteps;
  final Widget child;
  final VoidCallback? onBack;
  final VoidCallback? onClose;
  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header with tactile back button and capsule progress
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(
                children: [
                  // Tactile circular back/close button
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      if (onBack != null) {
                        onBack!();
                      } else if (onClose != null) {
                        onClose!();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark
                            ? colorScheme.surfaceContainerHigh
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
                      child: Center(
                        child: Icon(
                          currentStep == 0
                              ? Icons.close_rounded
                              : Icons.arrow_back_rounded,
                          color: colorScheme.onSurface,
                          size: 19,
                        ),
                      ),
                    ),
                  ),
                  // Progress indicator
                  if (showProgress && totalSteps > 1)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: WizardProgressBar(
                          currentStep: currentStep,
                          totalSteps: totalSteps,
                        ),
                      ),
                    )
                  else
                    const Spacer(),
                  // Placeholder for symmetry
                  const SizedBox(width: 38),
                ],
              ),
            ),
            // Content
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

/// Animasyonlu kapsül ilerleme çubuğu
class WizardProgressBar extends StatelessWidget {
  const WizardProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final progress = totalSteps > 0 ? (currentStep + 1) / totalSteps : 0.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.white.withValues(alpha: 0.9),
              width: 1,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Align(
                alignment: Alignment.centerLeft,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: progress),
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) {
                    return Container(
                      width: constraints.maxWidth * value.clamp(0.0, 1.0),
                      height: constraints.maxHeight,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary,
                            Color.lerp(colorScheme.primary, Colors.white, 0.2) ??
                                colorScheme.primary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.35),
                            blurRadius: 6,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.09),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${currentStep + 1} / $totalSteps',
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}

/// Wizard sayfası için standart yapı
class WizardPage extends StatelessWidget {
  const WizardPage({
    super.key,
    required this.title,
    this.subtitle,
    this.emoji,
    required this.child,
    this.bottomWidget,
    this.isOptional = false,
    this.onSkip,
  });

  final String title;
  final String? subtitle;
  final String? emoji;
  final Widget child;
  final Widget? bottomWidget;
  final bool isOptional;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Emoji if provided
                if (emoji != null) ...[
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Text(
                          emoji!,
                          style: const TextStyle(fontSize: 48),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                // Title with animation
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // Subtitle
                if (subtitle != null) ...[
                  const SizedBox(height: 8),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Opacity(opacity: value, child: child);
                    },
                    child: Text(
                      subtitle!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],

                // Optional badge
                if (isOptional) ...[
                  const SizedBox(height: 8),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        AppLocalizations.of(context).wizardOptional,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                // Main content
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 30 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: child,
                ),
              ],
            ),
          ),
        ),

        // Bottom widget (usually navigation buttons)
        if (bottomWidget != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: bottomWidget,
          ),
      ],
    );
  }
}

/// İleri ve Atla butonları
class WizardNavigationButtons extends StatelessWidget {
  const WizardNavigationButtons({
    super.key,
    required this.onNext,
    this.onSkip,
    this.nextLabel,
    this.skipLabel,
    this.isNextEnabled = true,
    this.showSkip = false,
    this.isLastStep = false,
    this.accentColor,
  });

  final VoidCallback onNext;
  final VoidCallback? onSkip;
  final String? nextLabel;
  final String? skipLabel;
  final bool isNextEnabled;
  final bool showSkip;
  final bool isLastStep;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final buttonColor = accentColor ?? colorScheme.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Main action button with elevated capsule styling and glowing shadow
        SizedBox(
          width: double.infinity,
          height: 52,
          child: PrimaryGradientButton(
            onPressed: isNextEnabled
                ? () {
                    HapticFeedback.lightImpact();
                    onNext();
                  }
                : null,
            color: buttonColor,
            elevation: 4,
            borderRadius: 26,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  nextLabel ??
                      (isLastStep
                          ? AppLocalizations.of(context).wizardFinish
                          : AppLocalizations.of(context).wizardNext),
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
                if (!isLastStep) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded, size: 20),
                ],
              ],
            ),
          ),
        ),

        // Skip button
        if (showSkip && onSkip != null) ...[
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              onSkip!();
            },
            child: Text(
              skipLabel ?? AppLocalizations.of(context).wizardSkip,
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Karşılama sayfası şablonu
class WizardWelcomePage extends StatelessWidget {
  const WizardWelcomePage({
    super.key,
    required this.title,
    required this.description,
    required this.emoji,
    required this.buttonText,
    required this.onStart,
    this.accentColor,
  });

  final String title;
  final String description;
  final String emoji;
  final String buttonText;
  final VoidCallback onStart;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final color = accentColor ?? colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          // Animated emoji container
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 64)),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 48),

          // Title
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Text(
              title,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 20),

          // Description
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                description,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const Spacer(),

          // Start button
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.scale(
                  scale: 0.8 + (0.2 * value),
                  child: child,
                ),
              );
            },
            child: SizedBox(
              width: double.infinity,
              child: PrimaryGradientButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onStart();
                },
                color: color,
                elevation: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      buttonText,
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, size: 20),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/// Önizleme kartı
class WizardPreviewCard extends StatelessWidget {
  const WizardPreviewCard({
    super.key,
    required this.emoji,
    this.imagePath,
    required this.title,
    this.subtitle,
    this.tags = const [],
    required this.color,
  });

  final String emoji;
  final String? imagePath;
  final String title;
  final String? subtitle;
  final List<String> tags;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final hasImage = imagePath != null && imagePath!.isNotEmpty;
    final isFile = hasImage &&
        (imagePath!.startsWith('/') ||
            imagePath!.contains('\\') ||
            imagePath!.contains(':\\'));

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHigh
            : Color.alphaBlend(color.withValues(alpha: 0.08), Colors.white),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.12)
              : Colors.white.withValues(alpha: 0.95),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
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
        children: [
          // Photo or Emoji Container with rim border
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: color.withValues(alpha: 0.25),
                width: 1.2,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: hasImage
                ? (isFile
                    ? Image.file(
                        File(imagePath!),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Center(
                          child:
                              Text(emoji, style: const TextStyle(fontSize: 32)),
                        ),
                      )
                    : Image.asset(
                        imagePath!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Center(
                          child:
                              Text(emoji, style: const TextStyle(fontSize: 32)),
                        ),
                      ))
                : Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 32)),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    letterSpacing: -0.2,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: 12.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (tags.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: tags
                        .map(
                          (tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 3.5,
                            ),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: color.withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              tag,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: color,
                                fontWeight: FontWeight.w700,
                                fontSize: 10.5,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Seçim kartı (emoji, renk vb. için)
class WizardSelectionCard extends StatelessWidget {
  const WizardSelectionCard({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.child,
    this.size = 48,
    this.borderRadius = 12,
    this.selectedColor,
  });

  final bool isSelected;
  final VoidCallback onTap;
  final Widget child;
  final double size;
  final double borderRadius;
  final Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final color = selectedColor ?? colorScheme.primary;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.18)
              : (isDark
                  ? colorScheme.surfaceContainerHigh
                  : Colors.white),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: isSelected
                ? color
                : (isDark
                    ? Colors.white.withValues(alpha: 0.12)
                    : Colors.white.withValues(alpha: 0.95)),
            width: isSelected ? 2 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? color.withValues(alpha: 0.25)
                  : Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: isSelected ? 10 : 6,
              offset: const Offset(0, 2),
            ),
            if (!isDark && !isSelected)
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.8),
                blurRadius: 2,
                offset: const Offset(0, -1),
              ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}
