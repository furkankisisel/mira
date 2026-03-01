import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../tokens/colors.dart';
import 'pressable_scale.dart';

class PrimaryGradientButton extends StatelessWidget {
  const PrimaryGradientButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.icon,
    this.color,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    this.borderRadius = 16.0,
    this.isLoading = false,
    this.enabled = true,
    this.elevation = 4.0,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final IconData? icon;
  final Color? color;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final bool isLoading;
  final bool enabled;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = color ?? theme.colorScheme.primary;
    // Disabled appearance
    final actualColor = (enabled && onPressed != null)
        ? baseColor
        : theme.colorScheme.onSurface.withValues(alpha: 0.12);

    final gradient = (enabled && onPressed != null)
        ? actualColor.toGradient
        : LinearGradient(
            colors: [actualColor, actualColor],
          );

    return PressableScale(
      onTap: (enabled && onPressed != null && !isLoading) ? onPressed : null,
      scale: 0.95,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: gradient,
          boxShadow: (enabled && onPressed != null && elevation > 0)
              ? [
                  BoxShadow(
                    color: actualColor.withValues(alpha: 0.3),
                    blurRadius: elevation * 2,
                    offset: Offset(0, elevation),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap:
                (enabled && onPressed != null && !isLoading) ? onPressed : null,
            borderRadius: BorderRadius.circular(borderRadius),
            splashColor: Colors.white.withValues(alpha: 0.1),
            highlightColor: Colors.white.withValues(alpha: 0.1),
            child: Padding(
              padding: padding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading) ...[
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ] else if (icon != null) ...[
                    Icon(icon, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                  ],
                  DefaultTextStyle(
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    child: child,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
