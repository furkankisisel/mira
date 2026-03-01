import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  static const Color seed = Color(0xFF5B6B4F);
  static const Color background = Color(0xFFEFE9DD);
  static const Color surface = Color(0xFFF5EFE4);

  static const Color accentBlue = Color(0xFF90B6C9);
  static const Color accentGold = Color(0xFFD8C27A);
  static const Color accentClay = Color(0xFFB59785);
  static const Color accentSand = Color(0xFFC1BA9F);
  static const Color accentGreen = Color(0xFF547341);
  static const Color accentGreenDark = Color(0xFF628353);
  static const Color accentPurple = Color(0xFF8B7AC7);

  // New Theme Accents
  static const Color accentMatcha = Color(0xFF8BA888); // Soft Green
  static const Color accentLavender = Color(0xFFB8B5E0); // Soft Purple
  static const Color accentSky = Color(0xFFA4C5E6); // Soft Blue
  static const Color accentRose = Color(0xFFE0B5B5); // Soft Pink/Rose
  static const Color accentSlate = Color(0xFF7F8C8D); // Modern Slate
  static const Color accentOcean = Color(0xFF6699CC); // Calm Blue
  static const Color accentSunset = Color(0xFFE6AA88); // Warm Sunset
  static const Color accentForest = Color(0xFF5F8A5F); // Deep Green

  static Color shadowSm([double o = .15]) => Colors.black.withValues(alpha: o);
  static Color overlay([double o = .08]) => Colors.black.withValues(alpha: o);
}

enum MoodToken { awful, ok, good, great }

extension MoodTokenColor on MoodToken {
  Color get color => switch (this) {
        MoodToken.awful => AppColors.accentClay,
        MoodToken.ok => AppColors.accentSand,
        MoodToken.good => AppColors.accentBlue,
        MoodToken.great => AppColors.accentGold,
      };
}

/// Extension to easily generate a slightly tilted, harmonious gradient from a single base color.
extension GradientExtension on Color {
  LinearGradient get toGradient {
    final hsl = HSLColor.fromColor(this);
    // Shift hue slightly (+15 degrees) and make it slightly lighter for a modern, energetic gradient
    final hslLight = hsl
        .withHue((hsl.hue + 15) % 360)
        .withLightness((hsl.lightness + 0.08).clamp(0.0, 1.0));

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        this,
        hslLight.toColor(),
      ],
    );
  }
}
