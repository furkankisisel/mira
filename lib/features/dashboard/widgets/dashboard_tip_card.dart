import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mira/l10n/app_localizations.dart';
import '../../../../features/habit/data/server_ai_habit_service.dart';
import '../../../../features/habit/domain/ai_habit_repository.dart';
import '../presentation/ai_support_screen.dart';
import '../../../../design_system/theme/theme_variations.dart';

import 'package:mira/design_system/theme/app_theme.dart';

class DashboardTipCard extends StatelessWidget {
  final VoidCallback onTap;
  final ThemeVariant variant;

  const DashboardTipCard({
    super.key,
    required this.onTap,
    required this.variant,
  });

  @override
  Widget build(BuildContext context) {
    // Check if we are in World theme
    final isWorld = variant == ThemeVariant.world;

    // Build the content widget
    Widget content = _DashboardTipCardContent(onTap: onTap, variant: variant);

    // If World theme, override with Purple (Mystic) theme to ensure exact match
    if (isWorld) {
      final brightness = Theme.of(context).brightness;
      final purpleTheme = brightness == Brightness.dark
          ? AppTheme.dark(ThemeVariant.purple)
          : AppTheme.light(ThemeVariant.purple);

      return Theme(data: purpleTheme, child: content);
    }

    return content;
  }
}

class _DashboardTipCardContent extends StatefulWidget {
  final VoidCallback onTap;
  final ThemeVariant variant;

  const _DashboardTipCardContent({required this.onTap, required this.variant});

  @override
  State<_DashboardTipCardContent> createState() =>
      _DashboardTipCardContentState();
}

class _DashboardTipCardContentState extends State<_DashboardTipCardContent> {
  late int _tipIndex;
  // Cache localized tips to avoid rebuilding on every tick if needed
  List<String>? _cachedTips;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context);
    _cachedTips = [
      l10n.aiTip0,
      l10n.aiTip1,
      l10n.aiTip2,
      l10n.aiTip3,
      l10n.aiTip4,
      l10n.aiTip5,
      l10n.aiTip6,
      l10n.aiTip7,
    ];
    // Pick random index if not set
    _tipIndex = Random().nextInt(_cachedTips!.length);
  }

  @override
  Widget build(BuildContext context) {
    // Current theme (potentially overridden by parent)
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    final currentTip = _cachedTips?[_tipIndex] ?? l10n.aiTip0;

    // Use primary color - which will be Purple if overridden, or theme default otherwise
    final neonColor = colorScheme.primary;

    return GestureDetector(
      onTap: () {
        final service = ServerAiHabitService(
          apiKey: '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',
        );
        final repository = AiHabitRepository(service);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AiSupportScreen(
              repository: repository,
              startingContext: currentTip,
              variant: widget.variant,
            ),
          ),
        );
      },
      child: Container(
        constraints: const BoxConstraints(minHeight: 64),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // Use alphaBlend with neonColor to ensure harmony with the specific theme's background
          color: Color.alphaBlend(
            neonColor.withValues(alpha: 0.05),
            colorScheme.surfaceContainer,
          ),
          border: Border.all(
            color: neonColor.withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: neonColor.withValues(alpha: 0.25),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 0),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: neonColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: neonColor.withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: neonColor.withValues(alpha: 0.2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Icon(Icons.auto_awesome, size: 18, color: neonColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.aiAssistantTitle,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: neonColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      shadows: [
                        Shadow(
                          color: neonColor.withValues(alpha: 0.4),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    currentTip,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.9),
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: neonColor.withValues(alpha: 0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
