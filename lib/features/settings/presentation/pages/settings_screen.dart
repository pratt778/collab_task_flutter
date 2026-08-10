import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collab_task/core/config/constants/color_constant.dart';
import 'package:collab_task/features/locale/presentation/cubit/locale_cubit.dart';
import 'package:collab_task/features/theme/presentation/cubit/theme_cubit.dart';
import 'package:collab_task/features/shared/widget/logout_dialog.dart';
import 'package:collab_task/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:collab_task/l10n/gen/app_localizations.dart';

import 'package:collab_task/core/config/theme/app_colors_extension.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _pushNotifications = true;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l = AppLocalizations.of(context);
    final themeMode = context.watch<ThemeCubit>().state;
    final localeCode = context.watch<LocaleCubit>().state.languageCode;
    return Scaffold(
      backgroundColor: colors.scaffold,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colors.textPrimary,
        title: Text(
          l.settings,
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20.sp),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        children: [
          _buildSectionHeader(l.account.toUpperCase(), colors),
          _buildGroupedContainer([
            _buildSettingsTile(
              icon: Icons.person_rounded,
              title: l.profile,
              subtitle: l.updatePersonalInfo,
              colors: colors,
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: Icons.lock_rounded,
              title: l.security,
              subtitle: l.passwordAndBiometric,
              colors: colors,
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: Icons.notifications_rounded,
              title: l.notifications,
              subtitle: l.notificationsPreferencesAndAlerts,
              colors: colors,
              onTap: () {},
            ),
          ], colors),

          SizedBox(height: 32.h),

          _buildSectionHeader(l.preferences.toUpperCase(), colors),
          _buildGroupedContainer([
            _buildSettingsTile(
              icon: Icons.palette_rounded,
              title: l.theme,
              subtitle: _getThemeLabel(l, themeMode),
              colors: colors,
              onTap: () => _showThemeBottomSheet(colors),
            ),
            _buildSettingsTile(
              icon: Icons.translate_rounded,
              title: l.language,
              subtitle: _getLanguageLabel(l, localeCode),
              colors: colors,
              onTap: () => _showLanguageBottomSheet(colors),
            ),
          ], colors),

          SizedBox(height: 32.h),

          _buildSectionHeader(l.appSettings.toUpperCase(), colors),
          _buildGroupedContainer([
            _buildSwitchTile(
              icon: Icons.cloud_done_rounded,
              title: l.autoSync,
              subtitle: l.keepDataUpdated,
              value: _notificationsEnabled,
              colors: colors,
              onChanged: (v) => setState(() => _notificationsEnabled = v),
            ),
            _buildSwitchTile(
              icon: Icons.vibration_rounded,
              title: l.hapticFeedback,
              subtitle: l.softVibrations,
              value: _pushNotifications,
              colors: colors,
              onChanged: (v) => setState(() => _pushNotifications = v),
            ),
          ], colors),

          SizedBox(height: 48.h),

          Container(
            width: double.infinity,
            decoration: const BoxDecoration(boxShadow: []),
            child: ElevatedButton.icon(
              onPressed: () => showLogoutDialog(
                context,
                onConfirm: () => context.read<AuthCubit>().logout(),
              ),
              icon: const Icon(Icons.logout_rounded, color: Colors.white),
              label: Text(
                l.logoutAccount,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorRed,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
            ),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, AppColorsExtension colors) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, bottom: 12.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w900,
          color: colors.textTertiary,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildGroupedContainer(List<Widget> children, AppColorsExtension colors) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: colors.border, width: 0.5),
      ),
      child: Column(
        children: children.asMap().entries.map((entry) {
          final idx = entry.key;
          final widget = entry.value;
          final isLast = idx == children.length - 1;

          if (isLast) return widget;
          return Column(
            children: [
              widget,
              Padding(
                padding: EdgeInsets.only(left: 64.w),
                child: Divider(
                  height: 1,
                  color: colors.divider,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required AppColorsExtension colors,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Row(
            children: [
              Icon(icon, size: 22.sp, color: colors.textSecondary),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 20.sp,
                color: colors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required AppColorsExtension colors,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Row(
        children: [
          Icon(icon, size: 22.sp, color: colors.textSecondary),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: colors.primary,
            activeTrackColor: colors.primary.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }

  void _showThemeBottomSheet(AppColorsExtension colors) {
    final l = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.appearance,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: colors.textPrimary,
              ),
            ),
            SizedBox(height: 16.h),
            ...[
              (ThemeMode.light, l.lightMode),
              (ThemeMode.dark, l.darkMode),
              (ThemeMode.system, l.systemDefault),
            ].map((t) {
              final selected = context.watch<ThemeCubit>().state == t.$1;
              return ListTile(
                selected: selected,
                selectedColor: colors.primary,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  t.$2,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: selected ? colors.primary : colors.textPrimary,
                  ),
                ),
                trailing: selected
                    ? Icon(
                        Icons.check_circle_rounded,
                        color: colors.primary,
                      )
                    : Icon(Icons.circle_outlined, color: colors.textTertiary),
                onTap: () {
                  context.read<ThemeCubit>().updateTheme(t.$1);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showLanguageBottomSheet(AppColorsExtension colors) {
    final l = AppLocalizations.of(context);
    final currentLocale = context.read<LocaleCubit>().state.languageCode;
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.language,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: colors.textPrimary,
              ),
            ),
            SizedBox(height: 16.h),
            ...[
              ('en', l.english),
              ('ne', l.nepali),
              ('de', l.german),
              ('fr', l.french),
              ('es', l.spanish),
            ].map((option) {
              final selected = currentLocale == option.$1;
              return ListTile(
                selected: selected,
                selectedColor: colors.primary,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  option.$2,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: selected ? colors.primary : colors.textPrimary,
                  ),
                ),
                trailing: selected
                    ? Icon(
                        Icons.check_circle_rounded,
                        color: colors.primary,
                      )
                    : Icon(Icons.circle_outlined, color: colors.textTertiary),
                onTap: () {
                  context.read<LocaleCubit>().setLocale(Locale(option.$1));
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  String _getThemeLabel(AppLocalizations l, ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return l.lightMode;
      case ThemeMode.dark:
        return l.darkMode;
      case ThemeMode.system:
        return l.systemDefault;
    }
  }

  String _getLanguageLabel(AppLocalizations l, String localeCode) {
    switch (localeCode) {
      case 'en':
        return l.english;
      case 'ne':
        return l.nepali;
      case 'de':
        return l.german;
      case 'fr':
        return l.french;
      case 'es':
        return l.spanish;
      default:
        return l.english;
    }
  }
}
