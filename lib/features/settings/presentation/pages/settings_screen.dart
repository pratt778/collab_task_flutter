import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collab_task/core/config/constants/color_constant.dart';
import 'package:collab_task/features/locale/presentation/cubit/locale_cubit.dart';
import 'package:collab_task/features/theme/presentation/cubit/theme_cubit.dart';
import 'package:collab_task/features/shared/widget/logout_dialog.dart';
import 'package:collab_task/features/auth/presentation/cubit/auth_cubit.dart';

import 'package:collab_task/core/config/theme/app_colors_extension.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _pushNotifications = true;
  String _selectedLanguage = 'english';

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.scaffold,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colors.textPrimary,
        title: Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20.sp),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        children: [
          _buildSectionHeader('ACCOUNT', colors),
          _buildGroupedContainer([
            _buildSettingsTile(
              icon: Icons.person_rounded,
              title: 'Profile',
              subtitle: 'Update your personal info',
              colors: colors,
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: Icons.lock_rounded,
              title: 'Security',
              subtitle: 'Password and biometric',
              colors: colors,
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: Icons.notifications_rounded,
              title: 'Notifications',
              subtitle: 'Preferences and alerts',
              colors: colors,
              onTap: () {},
            ),
          ], colors),

          SizedBox(height: 32.h),

          _buildSectionHeader('PREFERENCES', colors),
          _buildGroupedContainer([
            _buildSettingsTile(
              icon: Icons.palette_rounded,
              title: 'Theme',
              subtitle: _getThemeLabel(context.watch<ThemeCubit>().state),
              colors: colors,
              onTap: () => _showThemeBottomSheet(colors),
            ),
            _buildSettingsTile(
              icon: Icons.translate_rounded,
              title: 'Language',
              subtitle: _getLanguageLabel(_selectedLanguage),
              colors: colors,
              onTap: () => _showLanguageBottomSheet(colors),
            ),
          ], colors),

          SizedBox(height: 32.h),

          _buildSectionHeader('APP SETTINGS', colors),
          _buildGroupedContainer([
            _buildSwitchTile(
              icon: Icons.cloud_done_rounded,
              title: 'Auto-sync',
              subtitle: 'Keep data updated in real-time',
              value: _notificationsEnabled,
              colors: colors,
              onChanged: (v) => setState(() => _notificationsEnabled = v),
            ),
            _buildSwitchTile(
              icon: Icons.vibration_rounded,
              title: 'Haptic Feedback',
              subtitle: 'Soft vibrations on interactions',
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
                'Logout Account',
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
              'Appearance',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: colors.textPrimary,
              ),
            ),
            SizedBox(height: 16.h),
            ...[
              (ThemeMode.light, 'Light Mode'),
              (ThemeMode.dark, 'Dark Mode'),
              (ThemeMode.system, 'System Default'),
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
              'Language',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: colors.textPrimary,
              ),
            ),
            SizedBox(height: 16.h),
            ...[
              ('en', 'English'),
              ('ne', 'Nepali (नेपाली)'),
              ('de', 'German (Deutsch)'),
              ('fr', 'French (Français)'),
              ('es', 'Spanish (Español)')
            ].map((l) {
              final selected = context.watch<LocaleCubit>().state.languageCode == l.$1;
              return ListTile(
                selected: selected,
                selectedColor: colors.primary,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  l.$2,
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
                  context.read<LocaleCubit>().setLocale(Locale(l.$1));
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  String _getThemeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light Mode';
      case ThemeMode.dark:
        return 'Dark Mode';
      case ThemeMode.system:
        return 'System Default';
    }
  }

  String _getLanguageLabel(String l) {
    switch (l) {
      case 'en': return 'English';
      case 'ne': return 'Nepali (नेपाली)';
      case 'de': return 'German (Deutsch)';
      case 'fr': return 'French (Français)';
      case 'es': return 'Spanish (Español)';
      default: return 'English';
    }
  }
}
