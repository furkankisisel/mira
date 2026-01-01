import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mira/l10n/app_localizations.dart';
import '../../../../features/habit/data/server_ai_habit_service.dart';
import '../../../../features/habit/domain/ai_habit_repository.dart';
import '../presentation/ai_support_screen.dart';
import 'package:mira/design_system/tokens/radii.dart';
import '../../../../design_system/theme/theme_variations.dart';

import 'package:mira/core/config/api_config.dart';

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
    final isWorld = false;

    Widget content = _DashboardTipCardContent(onTap: onTap, variant: variant);

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
        final service = ServerAiHabitService(apiKey: ApiConfig.groqApiKey);
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
          borderRadius: BorderRadius.circular(AppRadii.card),
          color: colorScheme.surfaceContainer,
          boxShadow: [
            // Layer 1: Ambient deep shadow for "lift"
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 24,
              offset: const Offset(0, 12),
              spreadRadius: 2,
            ),
            // Layer 2: Closer shadow for definition
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
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
                color: neonColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                // Subtle inner light for the icon container
                boxShadow: [
                  BoxShadow(
                    color: neonColor.withValues(alpha: 0.12),
                    blurRadius: 12,
                    spreadRadius: -2,
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
                      fontSize: 11, // Increased slightly for readability
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
