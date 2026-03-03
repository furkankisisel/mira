import 'package:flutter/material.dart';

import '../tokens/radii.dart';
import '../theme/theme_variations.dart';
import 'pressable_scale.dart';

class CottonBottomBar extends StatelessWidget {
  const CottonBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    required this.variant,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<CottonDestination> destinations;
  final ThemeVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    // Use theme surface color to match AppBar with transparency for glassmorphism
    final bgColor = scheme.surface.withValues(alpha: 0.85);

    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            // Deep ambient shadow for lift
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, -4),
            ),
            // Sharp detail shadow
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
            ),
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(destinations.length, (index) {
                    final item = destinations[index];
                    final isSelected = selectedIndex == index;

                    // Decide active color
                    // If globally World theme, we might want specific colors per tab,
                    // otherwise use primary.
                    // For simplicity in this reusable component, we use the item's color if provided,
                    // or fall back to scheme.primary.
                    final activeColor = item.color ?? scheme.primary;

                    return _CottonNavItem(
                      icon: item.icon,
                      selectedIcon: item.selectedIcon,
                      label: item.label,
                      isSelected: isSelected,
                      activeColor: activeColor,
                      onTap: () => onDestinationSelected(index),
                    );
                  }),
                ),
              ),
            ),
          ),
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

class _CottonNavItem extends StatelessWidget {
  const _CottonNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.activeColor,
    required this.onTap,
  });

  final IconData icon;
  final IconData? selectedIcon;
  final String label;
  final bool isSelected;
  final Color activeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Unselected color
    final iconColor = isSelected
        ? activeColor
        : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6);

    // Background for the selected pill
    final pillColor =
        isSelected ? activeColor.withValues(alpha: 0.12) : Colors.transparent;

    return PressableScale(
      onTap: onTap,
      scale: 0.9,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: isSelected
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 10)
            : const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ), // slight padding even when unselected for touch target
        decoration: BoxDecoration(
          color: pillColor,
          borderRadius: BorderRadius.circular(AppRadii.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? (selectedIcon ?? icon) : icon,
              color: iconColor,
              size: 24,
            ),
            // Animate width AND opacity for the text
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: isSelected ? null : 0,
                child: Padding(
                  padding: isSelected
                      ? const EdgeInsets.only(left: 8)
                      : EdgeInsets.zero,
                  child: Text(
                    label,
                    style: TextStyle(
                      color: activeColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
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
