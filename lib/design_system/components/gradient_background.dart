import 'package:flutter/material.dart';

import '../tokens/colors.dart';

/// A reusable generic background widget that applies a harmonious gradient
/// based on the provided base color. Useful for headers, cards, or full screens.
class GradientBackground extends StatelessWidget {
  const GradientBackground({
    super.key,
    required this.child,
    this.baseColor,
    this.borderRadius = BorderRadius.zero,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.opacity =
        0.1, // Often backgrounds use a very light version of the gradient
  });

  /// The widget below this background in the tree
  final Widget child;

  /// The base color for the gradient. If null, it defaults to the theme's primary color.
  final Color? baseColor;

  /// Adding border radius if this is used as a card
  final BorderRadiusGeometry borderRadius;

  /// Inner padding
  final EdgeInsetsGeometry padding;

  /// Outer margin
  final EdgeInsetsGeometry margin;

  /// Opacity multiplier for the gradient to make it subtle
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = baseColor ?? theme.colorScheme.primary;

    // Use the toGradient extension, but wrap it in a slightly faded context if needed.
    // For backgrounds, we might want the exact gradient or a faded one.
    // The toGradient extension already creates a nice tilted gradient.
    final gradient = color.toGradient;

    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: gradient.begin,
          end: gradient.end,
          colors: gradient.colors.map((c) => c.withOpacity(opacity)).toList(),
        ),
      ),
      child: child,
    );
  }
}
