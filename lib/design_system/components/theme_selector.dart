import 'package:flutter/material.dart';
import '../../design_system/theme/theme_variations.dart';
import 'package:mira/l10n/app_localizations.dart';
import 'theme_preview.dart';
import '../../services/premium_manager.dart';
import '../../ui/premium_gate.dart';

/// Theme selector widget for choosing theme variants
class ThemeSelector extends StatelessWidget {
  const ThemeSelector({
    super.key,
    required this.currentVariant,
    required this.onVariantChanged,
  });

  final ThemeVariant currentVariant;
  final ValueChanged<ThemeVariant> onVariantChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return StreamBuilder<bool>(
      stream: PremiumManager.instance.premiumStatusStream,
      initialData: PremiumManager.instance.isPremium,
      builder: (context, snapshot) {
        final isPremiumUser = snapshot.data ?? false;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Tema Seçimi',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Theme previews
            SizedBox(
              height: 110,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: ThemeVariations.variants.map((variant) {
                    final isSelected = variant == currentVariant;
                    final isLocked = variant.isPremium && !isPremiumUser;

                    return GestureDetector(
                      onTap: () async {
                        if (variant.isPremium && !isPremiumUser) {
                          if (!await requirePremium(context)) return;
                        }
                        onVariantChanged(variant);
                      },
                      child: Container(
                        width: 100,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              children: [
                                ThemePreview(
                                  variant: variant,
                                  isSelected: isSelected,
                                ),
                                if (isLocked)
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.4),
                                        borderRadius: BorderRadius.circular(
                                          12,
                                        ), // Assuming ThemePreview radius
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.lock,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Flexible(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      variant.getDisplayName(context),
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                            color: isSelected
                                                ? variant.config.primary
                                                : scheme.onSurfaceVariant,
                                          ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  if (variant.isPremium && !isLocked) ...[
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.star,
                                      size: 10,
                                      color: variant.config.primary,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Detailed list view
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                AppLocalizations.of(context).themeDetails,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ...ThemeVariations.variants.map((variant) {
              final isSelected = variant == currentVariant;
              final config = variant.config;
              final isLocked = variant.isPremium && !isPremiumUser;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? config.primary : scheme.outline,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          config.primary,
                          config.primary.withValues(alpha: 0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: scheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Icon(
                      isLocked
                          ? Icons.lock
                          : isSelected
                          ? Icons.check
                          : _getIconForVariant(variant),
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    variant.getDisplayName(context),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    variant.getDescription(context),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.radio_button_checked, color: config.primary)
                      : isLocked
                      ? Icon(Icons.lock_outline, color: scheme.outline)
                      : Icon(
                          Icons.radio_button_unchecked,
                          color: scheme.outline,
                        ),
                  onTap: () async {
                    if (variant.isPremium && !isPremiumUser) {
                      if (!await requirePremium(context)) return;
                    }
                    onVariantChanged(variant);
                  },
                ),
              );
            }),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  IconData _getIconForVariant(ThemeVariant variant) {
    return switch (variant) {
      ThemeVariant.cotton => Icons.spa,
      ThemeVariant.matcha => Icons.eco,
      ThemeVariant.lavender => Icons.local_florist,
      ThemeVariant.sky => Icons.cloud_queue,
      ThemeVariant.rose => Icons.filter_vintage,
      ThemeVariant.slate => Icons.layers,
      ThemeVariant.ocean => Icons.water_drop,
      ThemeVariant.sunset => Icons.wb_twilight,
      ThemeVariant.forest => Icons.forest,
      ThemeVariant.cream => Icons.cookie,
      ThemeVariant.midnight => Icons.nightlight,
      ThemeVariant.mauve => Icons.palette,
      ThemeVariant.blush => Icons.favorite,
      ThemeVariant.crimson => Icons.whatshot,
      ThemeVariant.abyss => Icons.nights_stay,
      ThemeVariant.vintageRed => Icons.history_edu,
    };
  }
}
