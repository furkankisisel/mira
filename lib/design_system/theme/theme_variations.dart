import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
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
    ThemeVariant.terracotta,
    ThemeVariant.fjord,
    ThemeVariant.sandstone,
    ThemeVariant.moss,
    ThemeVariant.heather,
    ThemeVariant.amber,
    ThemeVariant.basalt,
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
  terracotta,
  fjord,
  sandstone,
  moss,
  heather,
  amber,
  basalt;

  String getDisplayName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isTr = l10n.localeName.startsWith('tr');
    return switch (this) {
      ThemeVariant.cotton => l10n.themeCotton,
      ThemeVariant.terracotta => 'Terracotta',
      ThemeVariant.fjord => isTr ? 'Kuzey Fiyordu' : 'Nordic Fjord',
      ThemeVariant.sandstone => isTr ? 'Kumlu Taş' : 'Sandstone',
      ThemeVariant.moss => isTr ? 'Orman Yosunu' : 'Forest Moss',
      ThemeVariant.heather => isTr ? 'Funda Sisi' : 'Heather Mist',
      ThemeVariant.amber => isTr ? 'Sıcak Kehribar' : 'Warm Amber',
      ThemeVariant.basalt => isTr ? 'Volkanik Bazalt' : 'Basalt Stone',
    };
  }

  String getDescription(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isTr = l10n.localeName.startsWith('tr');
    return switch (this) {
      ThemeVariant.cotton => isTr
          ? 'Nötr, huzurlu adaçayı ve doğal keten'
          : l10n.themeCottonDesc,
      ThemeVariant.terracotta => isTr
          ? 'Sıcak pişmiş kil ve doğal seramik dokusu'
          : 'Warm baked clay and earthy ceramic warmth',
      ThemeVariant.fjord => isTr
          ? 'İskandinav denizleri ve sakin sis mavisi'
          : 'Serene Scandinavian sea and mist blue',
      ThemeVariant.sandstone => isTr
          ? 'Sakin kumullar, yulaf ve ham ahşap tonları'
          : 'Calm coastal dunes, oat, and raw wood',
      ThemeVariant.moss => isTr
          ? 'Kuzey çam ormanları ve kadifemsi yosun'
          : 'Nordic pine woods and velvety mountain moss',
      ThemeVariant.heather => isTr
          ? 'Bozkır fundalıkları ve dingin alacakaranlık'
          : 'Moorland heather and tranquil twilight dusk',
      ThemeVariant.amber => isTr
          ? 'Hygge mum ışığı ve bal kehribarı parıltısı'
          : 'Hygge candlelight and golden honey glow',
      ThemeVariant.basalt => isTr
          ? 'Yalın mineral grisi, minimalist granit ve taş dokusu'
          : 'Pure mineral grey, minimalist granite and stone texture',
    };
  }

  bool get isPremium {
    return switch (this) {
      ThemeVariant.cotton => false,
      ThemeVariant.terracotta => false,
      ThemeVariant.fjord => false,
      ThemeVariant.sandstone => false,
      ThemeVariant.moss => true,
      ThemeVariant.heather => true,
      ThemeVariant.amber => true,
      ThemeVariant.basalt => true,
    };
  }
}

/// Extension to get theme configuration for each variant
extension ThemeVariantConfig on ThemeVariant {
  ThemeConfig get config => switch (this) {
        ThemeVariant.cotton => const ThemeConfig(
            primary: Color(0xFF5B6B4F),
            lightBackground: Color(0xFFF7F5F0),
            lightSurface: Color(0xFFFFFFFF),
            darkBackground: Color(0xFF141713),
            darkSurface: Color(0xFF1E221D),
          ),
        ThemeVariant.terracotta => const ThemeConfig(
            primary: Color(0xFFC07355),
            lightBackground: Color(0xFFFAF5F2),
            lightSurface: Color(0xFFFFFFFF),
            darkBackground: Color(0xFF1C1513),
            darkSurface: Color(0xFF261D1A),
          ),
        ThemeVariant.fjord => const ThemeConfig(
            primary: Color(0xFF4A6E82),
            lightBackground: Color(0xFFF3F6F8),
            lightSurface: Color(0xFFFFFFFF),
            darkBackground: Color(0xFF12171C),
            darkSurface: Color(0xFF1B2228),
          ),
        ThemeVariant.sandstone => const ThemeConfig(
            primary: Color(0xFF9E846A),
            lightBackground: Color(0xFFF9F7F3),
            lightSurface: Color(0xFFFFFFFF),
            darkBackground: Color(0xFF1A1713),
            darkSurface: Color(0xFF24201A),
          ),
        ThemeVariant.moss => const ThemeConfig(
            primary: Color(0xFF3F6D55),
            lightBackground: Color(0xFFF3F7F5),
            lightSurface: Color(0xFFFFFFFF),
            darkBackground: Color(0xFF111814),
            darkSurface: Color(0xFF19231D),
          ),
        ThemeVariant.heather => const ThemeConfig(
            primary: Color(0xFF7A688A),
            lightBackground: Color(0xFFF7F5F9),
            lightSurface: Color(0xFFFFFFFF),
            darkBackground: Color(0xFF17141C),
            darkSurface: Color(0xFF211D27),
          ),
        ThemeVariant.amber => const ThemeConfig(
            primary: Color(0xFFC28135),
            lightBackground: Color(0xFFFAF7F2),
            lightSurface: Color(0xFFFFFFFF),
            darkBackground: Color(0xFF1A150F),
            darkSurface: Color(0xFF251E16),
          ),
        ThemeVariant.basalt => const ThemeConfig(
            primary: Color(0xFF525252),
            lightBackground: Color(0xFFF5F5F5),
            lightSurface: Color(0xFFFFFFFF),
            darkBackground: Color(0xFF141414),
            darkSurface: Color(0xFF1E1E1E),
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
