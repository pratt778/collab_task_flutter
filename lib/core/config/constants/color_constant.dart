import 'package:flutter/material.dart';

class AppColors {
  // --- Brand & Primary Colors ---
  static const Color primaryTeal = Color(0xFF096B72);
  static const Color primaryTeal2 = Color(0xFF1F787E);
  static const Color secondaryTeal = Color(0xFF0FB8C4);
  static const Color primaryBlue = Color(0xFF154D71);
  static const Color primaryGreen = Color(0xFF1E8E3E);

  // --- Backgrounds & Surfaces ---
  static const Color scaffoldBackground = Color(0xFFF9F9F9);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color surfaceGreyLight = Color(0xFFF7F7F7);
  static const Color surfaceGreyMedium = Color(0xFFF0F0F0);
  static const Color surfaceGreyLight2 = Color(0xFFE8E8E8);
  static const Color surfaceGreyLight3 = Color(0xFFFAFAFA);
  static const Color surfaceGreyLight4 = Color(0xFF5C5C5C);
  static const Color surfaceGreyLight5 = Color(0xFFA3A3A3);
  static const Color surfaceGreyLight6 = Color(0xFFD2D2D2);
  static const Color surfaceGreyLight7 = Color(0xFF606060);
  static const Color surfaceGreyLight8 = Color(0xFFE9EAEB);
  // --- Gradients ---
  static const LinearGradient loginGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFFFF), Color(0xFFA9E2E6)],
  );
  // --- Box Shadow outline ---
  static const Color shadowOutline = Color(0x40C1BDBD);
  // --- Status & Functional ---
  static const Color successGreen = Color(0xFF1B9500);
  static const Color successBg = Color(0xFFCAF2DE);
  static const Color errorRed = Color(0xFFF44336);
  static const Color errorBg = Color(0xFFFB9D8E);
  static const Color errorLight = Color(0xFFFFB3A8);
  
  static const Color warningGold = Color(0xFFD6AA3E);
  static const Color warningDeep = Color(0xFFB17D04);
  static const Color warningTransparent = Color(
    0xBFCA8F00,
  ); // BF is 75% opacity

  // --- Grayscale / Text Colors ---
  static const Color textDark = Color(0xFF080808);
  static const Color textBlack = Color(0xFF000000);
  static const Color textGreyDeep = Color(0xFF464646);
  static const Color textGreyMedium = Color(0xFF696969);
  static const Color textGreyLight = Color(0xFF939393);
  static const Color textGreyLight2 = Color(0xFF717171);

  // --- Borders & Dividers ---
  static const Color borderLight = Color(0xFFE6E6E6);
  static const Color borderMedium = Color(0xFFDEDEDE);
  static const Color divider = Color(0xFFCDCDCD);
  // #E5E5E5
  static const Color borderLight2 = Color(0xFFE5E5E5);
  // --- Special Elements ---
  static const Color infoBlueBg = Color(0xFFE7F2FD);
  static const Color greySubtle = Color(0xFFE9E9E9);
}
