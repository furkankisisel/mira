import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  static TextTheme build(TextTheme base) {
    return GoogleFonts.outfitTextTheme(base);
  }
}
