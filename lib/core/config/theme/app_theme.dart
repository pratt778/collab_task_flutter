import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:collab_task/core/config/constants/color_constant.dart';
import 'package:collab_task/core/config/theme/app_colors_extension.dart';

class AppTheme {
  static final ThemeData light = _buildTheme(
    ColorScheme.fromSeed(
      seedColor: AppColors.primaryTeal,
      primary: AppColors.primaryTeal,
      secondary: AppColors.secondaryTeal,
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
      seedColor: AppColors.primaryTeal,
      brightness: Brightness.dark,
      primary: AppColors.secondaryTeal,
      secondary: AppColors.primaryTeal,
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

      // AppBar — primaryTeal in both modes (brand color)
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryTeal,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryTeal,
          side: const BorderSide(color: AppColors.primaryTeal),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryTeal,
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: appColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: appColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: appColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppColors.primaryTeal, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.errorRed),
        ),
        hintStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: appColors.textDisabled,
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        color: appColors.surface,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: appColors.divider,
        thickness: 1,
        space: 1,
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: appColors.surface,
        selectedItemColor: AppColors.primaryTeal,
        unselectedItemColor: appColors.textTertiary,
      ),

      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: Colors.white,
      ),

      // Icon
      iconTheme: IconThemeData(
        color: appColors.textSecondary,
      ),

      // Checkbox
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryTeal;
          }
          return appColors.surface;
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryTeal;
          }
          return appColors.surface;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.secondaryTeal;
          }
          return appColors.surfaceMuted;
        }),
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: appColors.textPrimary,
        contentTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: appColors.surface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: appColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // ProgressIndicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryTeal,
      ),
    );
  }
}
