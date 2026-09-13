import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../tokens/colors.dart';
import '../tokens/typography.dart';
import '../tokens/radii.dart';
import 'package:mira/l10n/app_localizations.dart';

/// Theme variations based on different accent colors from our design system
class ThemeVariations {
  ThemeVariations._();

  /// Available theme variants
  /// Available theme variants
  static const List<ThemeVariant> variants = [
    ThemeVariant.cotton,
    ThemeVariant.matcha,
    ThemeVariant.lavender,
    ThemeVariant.sky,
    ThemeVariant.rose,
    ThemeVariant.slate,
    ThemeVariant.ocean,
    ThemeVariant.sunset,
    ThemeVariant.forest,
    ThemeVariant.cream,
    ThemeVariant.midnight,
    ThemeVariant.mauve,
    ThemeVariant.blush,
    ThemeVariant.crimson,
    ThemeVariant.abyss,
    ThemeVariant.vintageRed,
  ];

  /// Generate light theme for a specific variant
  static ThemeData light(ThemeVariant variant) {
    final base = ThemeData.light(useMaterial3: true);
    final config = variant.config;

    final scheme = ColorScheme.fromSeed(
      seedColor: config.primary,
      surface: config.lightSurface,
      surfaceContainerHighest: config.lightBackground,
    );

    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: config.lightBackground,
      textTheme: AppTypography.build(base.textTheme),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      // Make popups/sheets match page background
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: config.lightBackground,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: config.lightBackground,
      ),
      dialogTheme: DialogThemeData(backgroundColor: config.lightBackground),
      popupMenuTheme: PopupMenuThemeData(color: config.lightBackground),
      cardTheme: CardThemeData(
        color: config.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
      ),
      iconTheme: IconThemeData(color: config.primary),
      appBarTheme: AppBarTheme(
        backgroundColor: config.lightSurface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        toolbarHeight: 64, // Slightly taller to accommodate 26px font
        centerTitle: false,
        titleTextStyle: GoogleFonts.outfit(
          color: scheme.onSurface,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: config.primary, size: 28),
        actionsIconTheme: IconThemeData(color: config.primary, size: 28),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: config.lightSurface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: config.primary.withValues(alpha: 0.12),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: config.primary);
          }
          return IconThemeData(color: scheme.onSurfaceVariant);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(color: config.primary, fontSize: 12);
          }
          return TextStyle(color: scheme.onSurfaceVariant, fontSize: 12);
        }),
      ),
      // --- BUTTON THEMES (Cotton Style) ---
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          elevation: 0,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          elevation: 2, // Soft lift
          shadowColor: config.primary.withValues(alpha: 0.3),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          side: BorderSide(color: config.primary.withValues(alpha: 0.5)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Generate dark theme for a specific variant
  static ThemeData dark(ThemeVariant variant) {
    final base = ThemeData.dark(useMaterial3: true);
    final config = variant.config;

    final scheme = ColorScheme.fromSeed(
      seedColor: config.primary,
      brightness: Brightness.dark,
      surface: config.darkSurface,
      surfaceContainerHighest: config.darkBackground,
    );

    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: config.darkBackground,
      textTheme: AppTypography.build(
        base.textTheme.apply(
          bodyColor: scheme.onSurface,
          displayColor: scheme.onSurface,
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      // Make popups/sheets match page background
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: config.darkBackground,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: config.darkBackground,
      ),
      dialogTheme: DialogThemeData(backgroundColor: config.darkBackground),
      popupMenuTheme: PopupMenuThemeData(color: config.darkBackground),
      cardTheme: CardThemeData(
        color: config.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
      ),
      iconTheme: IconThemeData(color: config.primary),
      appBarTheme: AppBarTheme(
        backgroundColor: config.darkSurface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.black.withValues(alpha: 0.2),
        toolbarHeight: 64,
        centerTitle: false,
        titleTextStyle: GoogleFonts.outfit(
          color: scheme.onSurface,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: config.primary, size: 28),
        actionsIconTheme: IconThemeData(color: config.primary, size: 28),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: config.darkSurface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: config.primary.withValues(alpha: 0.24),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: config.primary);
          }
          return IconThemeData(color: scheme.onSurfaceVariant);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(color: config.primary, fontSize: 12);
          }
          return TextStyle(color: scheme.onSurfaceVariant, fontSize: 12);
        }),
      ),
      // --- BUTTON THEMES (Cotton Style) ---
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          elevation: 0,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.3),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          side: BorderSide(color: config.primary.withValues(alpha: 0.5)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Available theme variants
enum ThemeVariant {
  cotton,
  matcha,
  lavender,
  sky,
  rose,
  slate,
  ocean,
  sunset,
  forest,
  cream,
  midnight,
  mauve,
  blush,
  crimson,
  abyss,
  vintageRed;

  String getDisplayName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (this) {
      ThemeVariant.cotton => l10n.themeCotton,
      ThemeVariant.matcha => l10n.themeMatcha,
      ThemeVariant.lavender => l10n.themeLavender,
      ThemeVariant.sky => l10n.themeSky,
      ThemeVariant.rose => l10n.themeRose,
      ThemeVariant.slate => l10n.themeSlate,
      ThemeVariant.ocean => l10n.themeOcean,
      ThemeVariant.sunset => l10n.themeSunset,
      ThemeVariant.forest => l10n.themeForest,
      ThemeVariant.cream => l10n.themeCream,
      ThemeVariant.midnight => l10n.themeMidnight,
      ThemeVariant.mauve => l10n.themeMauve,
      ThemeVariant.blush => l10n.themeBlush,
      ThemeVariant.crimson => l10n.themeCrimson,
      ThemeVariant.abyss => l10n.themeAbyss,
      ThemeVariant.vintageRed => l10n.themeVintageRed,
    };
  }

  String getDescription(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (this) {
      ThemeVariant.cotton => l10n.themeCottonDesc,
      ThemeVariant.matcha => l10n.themeMatchaDesc,
      ThemeVariant.lavender => l10n.themeLavenderDesc,
      ThemeVariant.sky => l10n.themeSkyDesc,
      ThemeVariant.rose => l10n.themeRoseDesc,
      ThemeVariant.slate => l10n.themeSlateDesc,
      ThemeVariant.ocean => l10n.themeOceanDesc,
      ThemeVariant.sunset => l10n.themeSunsetDesc,
      ThemeVariant.forest => l10n.themeForestDesc,
      ThemeVariant.cream => l10n.themeCreamDesc,
      ThemeVariant.midnight => l10n.themeMidnightDesc,
      ThemeVariant.mauve => l10n.themeMauveDesc,
      ThemeVariant.blush => l10n.themeBlushDesc,
      ThemeVariant.crimson => l10n.themeCrimsonDesc,
      ThemeVariant.abyss => l10n.themeAbyssDesc,
      ThemeVariant.vintageRed => l10n.themeVintageRedDesc,
    };
  }

  bool get isPremium {
    return switch (this) {
      ThemeVariant.cotton => false,
      ThemeVariant.matcha => false,
      ThemeVariant.lavender => false,
      ThemeVariant.sky => false,
      ThemeVariant.rose => false,
      ThemeVariant.slate => false,
      ThemeVariant.ocean => false,
      _ => true,
    };
  }
}

/// Extension to get theme configuration for each variant
extension ThemeVariantConfig on ThemeVariant {
  ThemeConfig get config => switch (this) {
        ThemeVariant.cotton => ThemeConfig(
            primary: AppColors.seed,
            lightBackground: const Color(0xFFFAFAFA),
            lightSurface: const Color(0xFFFFFFFF),
            darkBackground: const Color(0xFF121212),
            darkSurface: const Color(0xFF1E1E1E),
          ),
        ThemeVariant.matcha => ThemeConfig(
            primary: AppColors.accentMatcha,
            lightBackground: const Color(0xFFFAFAFA),
            lightSurface: const Color(0xFFFFFFFF),
            darkBackground: const Color(0xFF121212),
            darkSurface: const Color(0xFF1E1E1E),
          ),
        ThemeVariant.lavender => ThemeConfig(
            primary: AppColors.accentLavender,
            lightBackground: const Color(0xFFFAFAFA),
            lightSurface: const Color(0xFFFFFFFF),
            darkBackground: const Color(0xFF121212),
            darkSurface: const Color(0xFF1E1E1E),
          ),
        ThemeVariant.sky => ThemeConfig(
            primary: AppColors.accentSky,
            lightBackground: const Color(0xFFFAFAFA),
            lightSurface: const Color(0xFFFFFFFF),
            darkBackground: const Color(0xFF121212),
            darkSurface: const Color(0xFF1E1E1E),
          ),
        ThemeVariant.rose => ThemeConfig(
            primary: AppColors.accentRose,
            lightBackground: const Color(0xFFFAFAFA),
            lightSurface: const Color(0xFFFFFFFF),
            darkBackground: const Color(0xFF121212),
            darkSurface: const Color(0xFF1E1E1E),
          ),
        ThemeVariant.slate => ThemeConfig(
            primary: AppColors.accentSlate,
            lightBackground: const Color(0xFFFAFAFA),
            lightSurface: const Color(0xFFFFFFFF),
            darkBackground: const Color(0xFF121212),
            darkSurface: const Color(0xFF1E1E1E),
          ),
        ThemeVariant.ocean => ThemeConfig(
            primary: AppColors.accentOcean,
            lightBackground: const Color(0xFFFAFAFA),
            lightSurface: const Color(0xFFFFFFFF),
            darkBackground: const Color(0xFF121212),
            darkSurface: const Color(0xFF1E1E1E),
          ),
        ThemeVariant.sunset => ThemeConfig(
            primary: AppColors.accentSunset,
            lightBackground: const Color(0xFFFAFAFA),
            lightSurface: const Color(0xFFFFFFFF),
            darkBackground: const Color(0xFF121212),
            darkSurface: const Color(0xFF1E1E1E),
          ),
        ThemeVariant.forest => ThemeConfig(
            primary: AppColors.accentForest,
            lightBackground: const Color(0xFFFAFAFA),
            lightSurface: const Color(0xFFFFFFFF),
            darkBackground: const Color(0xFF121212),
            darkSurface: const Color(0xFF1E1E1E),
          ),
        // New themes based on user's hex colors - keeping standard backgrounds
        ThemeVariant.cream => ThemeConfig(
            primary: const Color(0xFFefe1ad), // #efe1ad - Warm cream/beige
            lightBackground: const Color(0xFFFAFAFA),
            lightSurface: const Color(0xFFFFFFFF),
            darkBackground: const Color(0xFF121212),
            darkSurface: const Color(0xFF1E1E1E),
          ),
        ThemeVariant.midnight => ThemeConfig(
            primary: const Color(0xFF22243b), // #22243b - Dark navy
            lightBackground: const Color(0xFFFAFAFA),
            lightSurface: const Color(0xFFFFFFFF),
            darkBackground: const Color(0xFF121212),
            darkSurface: const Color(0xFF1E1E1E),
          ),
        ThemeVariant.mauve => ThemeConfig(
            primary: const Color(0xFFaa93ad), // #aa93ad - Lavender mauve
            lightBackground: const Color(0xFFFAFAFA),
            lightSurface: const Color(0xFFFFFFFF),
            darkBackground: const Color(0xFF121212),
            darkSurface: const Color(0xFF1E1E1E),
          ),
        ThemeVariant.blush => ThemeConfig(
            primary: const Color(0xFFeed0c8), // #eed0c8 - Soft peach/blush
            lightBackground: const Color(0xFFFAFAFA),
            lightSurface: const Color(0xFFFFFFFF),
            darkBackground: const Color(0xFF121212),
            darkSurface: const Color(0xFF1E1E1E),
          ),
        ThemeVariant.crimson => ThemeConfig(
            primary: const Color(0xFFD7263D), // #D7263D - Bold crimson red
            lightBackground: const Color(0xFFFAFAFA),
            lightSurface: const Color(0xFFFFFFFF),
            darkBackground: const Color(0xFF121212),
            darkSurface: const Color(0xFF1E1E1E),
          ),
        ThemeVariant.abyss => ThemeConfig(
            primary: const Color(0xFF02182B), // #02182B - Deep navy abyss
            lightBackground: const Color(0xFFFAFAFA),
            lightSurface: const Color(0xFFFFFFFF),
            darkBackground: const Color(0xFF121212),
            darkSurface: const Color(0xFF1E1E1E),
          ),
        ThemeVariant.vintageRed => ThemeConfig(
            primary: const Color(0xFFb43a38), // #b43a38 - Vintage Red
            lightBackground: const Color(0xFFFAFAFA),
            lightSurface: const Color(0xFFFFFFFF),
            darkBackground: const Color(0xFF121212),
            darkSurface: const Color(0xFF1E1E1E),
          ),
      };
}

/// Theme configuration class
class ThemeConfig {
  const ThemeConfig({
    required this.primary,
    required this.lightBackground,
    required this.lightSurface,
    required this.darkBackground,
    required this.darkSurface,
  });

  final Color primary;
  final Color lightBackground;
  final Color lightSurface;
  final Color darkBackground;
  final Color darkSurface;
}
