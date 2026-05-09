import 'package:flutter/material.dart';
import 'package:collab_task/core/config/constants/color_constant.dart';

/// Semantic color tokens that flip between light and dark mode.
///
/// Access via `context.appColors.surface` instead of `AppColors.surfaceWhite`.
/// Raw brand colors (primaryTeal, errorRed, etc.) stay in `AppColors` because
/// they don't change between modes.
@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color primary;
  final Color secondary;
  final Color textDark;
  final Color surfaceWhite;
  final Color scaffold;
  final Color surface;
  final Color surfaceAlt;
  final Color surfaceMuted;
  final Color surfaceGreyLight;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textDisabled;
  final Color divider;
  final Color dividerLight;
  final Color border;
  final Color shadow;

  const AppColorsExtension({
    required this.primary,
    required this.secondary,
    required this.textDark,
    required this.surfaceWhite,
    required this.scaffold,
    required this.surface,
    required this.surfaceAlt,
    required this.surfaceMuted,
    required this.surfaceGreyLight,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textDisabled,
    required this.divider,
    required this.dividerLight,
    required this.border,
    required this.shadow,
  });

  static const light = AppColorsExtension(
    primary: AppColors.primaryTeal,
    secondary: AppColors.secondaryTeal,
    textDark: AppColors.textDark,
    surfaceWhite: AppColors.surfaceWhite,
    scaffold: Color(0xFFF9F9F9),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFFAFAFA),
    surfaceMuted: Color(0xFFF0F0F0),
    surfaceGreyLight: Color(0xFFF7F7F7),
    textPrimary: Color(0xFF080808),
    textSecondary: Color(0xFF464646),
    textTertiary: Color(0xFF696969),
    textDisabled: Color(0xFF939393),
    divider: Color(0xFFCDCDCD),
    dividerLight: Color(0xFFE9E9E9),
    border: Color(0xFFE6E6E6),
    shadow: Color(0x40C1BDBD),
  );

  static const dark = AppColorsExtension(
    primary: AppColors.primaryTeal,
    secondary: AppColors.secondaryTeal,
    textDark: AppColors.surfaceWhite, // In dark mode, textDark might be white?
    surfaceWhite: AppColors.surfaceWhite,
    scaffold: Color(0xFF0E1213),
    surface: Color(0xFF161B1D),
    surfaceAlt: Color(0xFF1E2527),
    surfaceMuted: Color(0xFF252C2F),
    surfaceGreyLight: Color(0xFF1A2022),
    textPrimary: Color(0xFFF5F5F5),
    textSecondary: Color(0xFFCFD3D5),
    textTertiary: Color(0xFF9BA3A6),
    textDisabled: Color(0xFF6B7478),
    divider: Color(0xFF2E3639),
    dividerLight: Color(0xFF2E3639),
    border: Color(0xFF2A3235),
    shadow: Color(0x66000000),
  );

  @override
  AppColorsExtension copyWith({
    Color? primary,
    Color? secondary,
    Color? textDark,
    Color? surfaceWhite,
    Color? scaffold,
    Color? surface,
    Color? surfaceAlt,
    Color? surfaceMuted,
    Color? surfaceGreyLight,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textDisabled,
    Color? divider,
    Color? dividerLight,
    Color? border,
    Color? shadow,
  }) {
    return AppColorsExtension(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      textDark: textDark ?? this.textDark,
      surfaceWhite: surfaceWhite ?? this.surfaceWhite,
      scaffold: scaffold ?? this.scaffold,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      surfaceGreyLight: surfaceGreyLight ?? this.surfaceGreyLight,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textDisabled: textDisabled ?? this.textDisabled,
      divider: divider ?? this.divider,
      dividerLight: dividerLight ?? this.dividerLight,
      border: border ?? this.border,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  AppColorsExtension lerp(
    ThemeExtension<AppColorsExtension>? other,
    double t,
  ) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      textDark: Color.lerp(textDark, other.textDark, t)!,
      surfaceWhite: Color.lerp(surfaceWhite, other.surfaceWhite, t)!,
      scaffold: Color.lerp(scaffold, other.scaffold, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      surfaceGreyLight:
          Color.lerp(surfaceGreyLight, other.surfaceGreyLight, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      dividerLight: Color.lerp(dividerLight, other.dividerLight, t)!,
      border: Color.lerp(border, other.border, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}

extension AppColorsContextX on BuildContext {
  AppColorsExtension get appColors =>
      Theme.of(this).extension<AppColorsExtension>()!;
}
