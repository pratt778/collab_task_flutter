import 'package:flutter/material.dart';
import 'package:collab_task/core/config/constants/app_size_constant.dart';
import 'package:collab_task/core/config/theme/app_colors_extension.dart';

class AppUI {
  // Standard Card Decoration — theme-aware, call with a BuildContext
  static BoxDecoration cardDecorationOf(BuildContext context) {
    final colors = context.appColors;
    return BoxDecoration(
      color: colors.scaffold,
      borderRadius: BorderRadius.circular(AppSizes.radiusM),
      border: Border.all(color: colors.border),
      boxShadow: [
        BoxShadow(
          color: colors.shadow,
          offset: const Offset(0, 1),
          blurRadius: 4,
        ),
      ],
    );
  }

  // Input Field Decoration — theme-aware
  static InputDecoration inputDecoration(BuildContext context, String hint) {
    final colors = context.appColors;
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: colors.surface,
      contentPadding: const EdgeInsets.all(AppSizes.m),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
        borderSide: BorderSide(color: colors.divider),
      ),
    );
  }
}
