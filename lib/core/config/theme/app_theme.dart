import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:collab_task/core/config/constants/color_constant.dart';
import 'package:collab_task/core/config/theme/app_colors_extension.dart';

class AppTheme {
  static final ThemeData light = _buildTheme(
    ColorScheme.fromSeed(
      seedColor: AppColors.primaryBlue,
      primary: AppColors.primaryBlue,
      secondary: AppColors.primaryIndigo,
      error: AppColors.errorRed,
      surface: AppColorsExtension.light.surface,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColorsExtension.light.textPrimary,
      onError: Colors.white,
    ),
    AppColorsExtension.light,
  );

  static final ThemeData dark = _buildTheme(
    ColorScheme.fromSeed(
      seedColor: AppColors.primaryBlue,
      brightness: Brightness.dark,
      primary: AppColors.primaryBlue,
      secondary: AppColors.primaryIndigo,
      error: AppColors.errorRed,
      surface: AppColorsExtension.dark.surface,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColorsExtension.dark.textPrimary,
      onError: Colors.white,
    ),
    AppColorsExtension.dark,
  );

  static ThemeData _buildTheme(
    ColorScheme colorScheme,
    AppColorsExtension appColors,
  ) {
    final textTheme = GoogleFonts.interTextTheme(
      ThemeData(brightness: colorScheme.brightness).textTheme,
    ).apply(
      bodyColor: appColors.textPrimary,
      displayColor: appColors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: appColors.scaffold,
      extensions: <ThemeExtension<dynamic>>[appColors],

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: appColors.scaffold,
        foregroundColor: appColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: appColors.textPrimary,
        ),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: appColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),

      // Input
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: appColors.surface,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: appColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: appColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: appColors.primary, width: 1.5),
        ),
        hintStyle: GoogleFonts.inter(fontSize: 14, color: appColors.textTertiary),
      ),

      // Card
      cardTheme: CardThemeData(
        color: appColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: appColors.border, width: 0.5),
        ),
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: appColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),

      // Progress
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: appColors.primary,
      ),
    );
  }
}
