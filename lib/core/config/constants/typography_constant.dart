import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography tokens. Colors are intentionally NOT set here so that
/// `Text` widgets inherit from the active theme's `textTheme`
/// (which flips between light and dark). Widgets that need a
/// specific color should use `.copyWith(color: context.appColors.xxx)`.
class AppTypography {
  static final TextStyle _baseStyle = GoogleFonts.inter();

  // Headlines
  static TextStyle h1 = _baseStyle.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    fontFamily: 'Inter',
  );

  static TextStyle h2 = _baseStyle.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    fontFamily: 'Inter',
  );

  static TextStyle h3 = _baseStyle.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    fontFamily: 'Inter',
  );

  // Body Text
  static TextStyle bodyLarge = _baseStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    fontFamily: 'Inter',
  );

  static TextStyle bodyMedium = _baseStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    fontFamily: 'Inter',
  );

  // Specialized
  static TextStyle buttonLabel = _baseStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontFamily: 'Inter',
  );

  static TextStyle caption = _baseStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: 'Inter',
  );
}
