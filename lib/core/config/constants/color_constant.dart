import 'package:flutter/material.dart';

class AppColors {
  // --- Brand & Primary Colors ---
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color primaryTeal = Color(0xFF0D9488); 
  static const Color primaryIndigo = Color(0xFF4F46E5);
  static const Color primaryViolet = Color(0xFF7C3AED);

  // --- Brand Gradients ---
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF10B981), Color(0xFF059669)],
  );

  // --- Backgrounds & Surfaces ---
  static const Color scaffoldBackground = Color(0xFFF8FAFC);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color surfaceSubtle = Color(0xFFF1F5F9);
  
  // Soft Accent Surfaces
  static const Color surfaceBlue = Color(0xFFEFF6FF);
  static const Color surfaceIndigo = Color(0xFFEEF2FF);
  static const Color surfaceEmerald = Color(0xFFECFDF5);
  static const Color surfaceRose = Color(0xFFFFF1F2);
  static const Color surfaceAmber = Color(0xFFFFFBEB);

  // --- Box Shadows ---
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> mediumShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  // --- Status & Functional ---
  static const Color successGreen = Color(0xFF10B981);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color warningAmber = Color(0xFFF59E0B);
  static const Color infoBlue = Color(0xFF3B82F6);

  // --- Grayscale / Text Colors ---
  static const Color textDark = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textDisabled = Color(0xFFCBD5E1);

  // --- Borders & Dividers ---
  static const Color borderSubtle = Color(0xFFE2E8F0);
  static const Color borderMedium = Color(0xFFCBD5E1);
  static const Color divider = Color(0xFFF1F5F9);

  // Legacy/Internal mappings (keeping for compatibility where needed)
  static const Color primaryTeal2 = Color(0xFF1E40AF);
  static const Color secondaryTeal = Color(0xFF60A5FA);
  static const Color primaryGreen = Color(0xFF2563EB);
  static const Color surfaceGreyLight = Color(0xFFF7F7F7);
  static const Color surfaceGreyMedium = Color(0xFFF0F0F0);
  static const Color surfaceGreyLight2 = Color(0xFFE8E8E8);
  static const Color surfaceGreyLight3 = Color(0xFFFAFAFA);
  static const Color surfaceGreyLight4 = Color(0xFF5C5C5C);
  static const Color surfaceGreyLight5 = Color(0xFFA3A3A3);
  static const Color surfaceGreyLight6 = Color(0xFFD2D2D2);
  static const Color surfaceGreyLight7 = Color(0xFF606060);
  static const Color surfaceGreyLight8 = Color(0xFFE9EAEB);
  static const LinearGradient loginGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFFFF), Color(0xFFA9E2E6)],
  );
  static const Color shadowOutline = Color(0x40C1BDBD);
  static const Color successBg = Color(0xFFCAF2DE);
  static const Color errorBg = Color(0xFFFB9D8E);
  static const Color errorLight = Color(0xFFFFB3A8);
  static const Color warningGold = Color(0xFFD6AA3E);
  static const Color warningDeep = Color(0xFFB17D04);
  static const Color warningTransparent = Color(0xBFCA8F00);
  static const Color textBlack = Color(0xFF000000);
  static const Color textGreyDeep = Color(0xFF464646);
  static const Color textGreyMedium = Color(0xFF696969);
  static const Color textGreyLight = Color(0xFF939393);
  static const Color textGreyLight2 = Color(0xFF717171);
  static const Color borderLight = Color(0xFFE6E6E6);
  static const Color borderLight2 = Color(0xFFE5E5E5);
  static const Color infoBlueBg = Color(0xFFE7F2FD);
  static const Color greySubtle = Color(0xFFE9E9E9);
}
