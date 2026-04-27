import 'package:flutter/material.dart';

class AppSizes {
  // Spacing (Padding/Margin)
  static const double xs = 4.0;
  static const double s = 8.0;
  static const double m = 14.0;
  static const double l = 16.0;
  static const double xl = 32.0;

  // Border Radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 20.0;
  static const double radiusXL = 32.0;

  // Reusable SizedBoxes (Performance optimization)
  static const gapH8 = SizedBox(height: s);
  static const gapH16 = SizedBox(height: m);
  static const gapW8 = SizedBox(width: s);
}