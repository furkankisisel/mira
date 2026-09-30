import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/theme_variations.dart';
import 'pressable_scale.dart';

/// A floating, capsule-shaped navigation bar paired with a standalone
/// claymorphic circular action button on the right.
class CottonBottomBar extends StatelessWidget {
  const CottonBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    required this.variant,
    this.onActionPressed,
    this.onCenterAction,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<CottonDestination> destinations;
  final ThemeVariant variant;
  final VoidCallback? onActionPressed;
  final VoidCallback? onCenterAction;

  VoidCallback? get _effectiveAction => onActionPressed ?? onCenterAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Translucent frosted glass background for the capsule, adapted dynamically to the theme
    final capsuleBgColor = isDark
        ? Color.alphaBlend(
            scheme.primary.withValues(alpha: 0.08),
            scheme.surfaceContainerHighest.withValues(alpha: 0.65),
          )
        : Color.alphaBlend(
            scheme.primary.withValues(alpha: 0.07),
            Color.alphaBlend(
              Colors.black.withValues(alpha: 0.04),
              theme.scaffoldBackgroundColor,
            ),
          );

    final capsuleBorderColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : Colors.white.withValues(alpha: 0.75);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left: Capsule navigation container
            Expanded(
              child: Container(
                height: 58,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                    if (!isDark)
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.6),
                        blurRadius: 4,
                        offset: const Offset(0, -1),
                      ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: capsuleBgColor,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: capsuleBorderColor,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(destinations.length, (index) {
                          final item = destinations[index];
                          final isSelected = selectedIndex == index;

                          return _CapsuleNavItem(
                            item: item,
                            isSelected: isSelected,
                            onTap: () => onDestinationSelected(index),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Right: Standalone circular action button (+)
            if (_effectiveAction != null) ...[
              const SizedBox(width: 12),
              _StandaloneActionButton(
                onTap: _effectiveAction!,
                color: scheme.primary,
                onColor: scheme.onPrimary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class CottonDestination {
  final IconData icon;
  final IconData? selectedIcon;
  final String label;
  final Color? color;

  const CottonDestination({
    required this.icon,
    required this.label,
    this.selectedIcon,
    this.color,
  });
}

/// An individual navigation item inside the capsule.
/// When selected, renders as an elevated white pill with icon + label.
/// When unselected, renders as a clean minimalist icon.
class _CapsuleNavItem extends StatelessWidget {
  const _CapsuleNavItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final CottonDestination item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Active pill background color: pure white in light mode, elevated container in dark mode
    final activePillColor = isDark
        ? scheme.surfaceContainerHigh
        : Colors.white;

    final activeTextColor = isDark
        ? scheme.onSurface
        : const Color(0xFF1E293B);

    final inactiveIconColor = isDark
        ? scheme.onSurfaceVariant.withValues(alpha: 0.6)
        : const Color(0xFF64748B);

    final activeIconColor = item.color ?? activeTextColor;

    return PressableScale(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      scale: 0.92,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        padding: isSelected
            ? const EdgeInsets.symmetric(horizontal: 14, vertical: 8)
            : const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activePillColor : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
          border: isSelected
              ? Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.12)
                      : Colors.white.withValues(alpha: 0.95),
                  width: 1,
                )
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? (item.selectedIcon ?? item.icon) : item.icon,
              size: 21,
              color: isSelected ? activeIconColor : inactiveIconColor,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: isSelected ? null : 0,
                child: Padding(
                  padding: isSelected
                      ? const EdgeInsets.only(left: 7)
                      : EdgeInsets.zero,
                  child: Text(
                    item.label,
                    style: TextStyle(
                      color: activeTextColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      letterSpacing: -0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    softWrap: false,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Standalone circular 3D claymorphic action button on the right of the navbar.
class _StandaloneActionButton extends StatelessWidget {
  const _StandaloneActionButton({
    required this.onTap,
    required this.color,
    required this.onColor,
  });

  final VoidCallback onTap;
  final Color color;
  final Color onColor;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: () {
        HapticFeedback.mediumImpact();
        onTap();
      },
      scale: 0.88,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color,
              Color.lerp(color, Colors.black, 0.14) ?? color,
            ],
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.25),
            width: 1,
          ),
          boxShadow: [
            // Deep primary color glow
            BoxShadow(
              color: color.withValues(alpha: 0.44),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
            // Ambient soft shadow
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
            // Subtle top highlight
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.35),
              blurRadius: 1,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            Icons.add_rounded,
            color: onColor,
            size: 30,
          ),
        ),
      ),
    );
  }
}
