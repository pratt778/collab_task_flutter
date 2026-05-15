import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collab_task/core/config/constants/color_constant.dart';
import 'package:collab_task/features/theme/presentation/cubit/theme_cubit.dart';
import 'package:collab_task/features/shared/widget/logout_dialog.dart';
import 'package:collab_task/features/auth/presentation/cubit/auth_cubit.dart';

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
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textDark,
        title: Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20.sp),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        children: [
          _buildSectionHeader('ACCOUNT'),
          _buildGroupedContainer([
            _buildSettingsTile(
              icon: Icons.person_rounded,
              title: 'Profile',
              subtitle: 'Update your personal info',
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: Icons.lock_rounded,
              title: 'Security',
              subtitle: 'Password and biometric',
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: Icons.notifications_rounded,
              title: 'Notifications',
              subtitle: 'Preferences and alerts',
              onTap: () {},
            ),
          ]),

          SizedBox(height: 32.h),

          _buildSectionHeader('PREFERENCES'),
          _buildGroupedContainer([
            _buildSettingsTile(
              icon: Icons.palette_rounded,
              title: 'Theme',
              subtitle: _getThemeLabel(context.watch<ThemeCubit>().state),
              onTap: _showThemeBottomSheet,
            ),
            _buildSettingsTile(
              icon: Icons.translate_rounded,
              title: 'Language',
              subtitle: _getLanguageLabel(_selectedLanguage),
              onTap: _showLanguageBottomSheet,
            ),
          ]),

          SizedBox(height: 32.h),

          _buildSectionHeader('APP SETTINGS'),
          _buildGroupedContainer([
            _buildSwitchTile(
              icon: Icons.cloud_done_rounded,
              title: 'Auto-sync',
              subtitle: 'Keep data updated in real-time',
              value: _notificationsEnabled,
              onChanged: (v) => setState(() => _notificationsEnabled = v),
            ),
            _buildSwitchTile(
              icon: Icons.vibration_rounded,
              title: 'Haptic Feedback',
              subtitle: 'Soft vibrations on interactions',
              value: _pushNotifications,
              onChanged: (v) => setState(() => _pushNotifications = v),
            ),
          ]),

          SizedBox(height: 48.h),

          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              boxShadow: [],
            ),
            child: ElevatedButton.icon(
              onPressed: () => showLogoutDialog(
                context,
                onConfirm: () => context.read<AuthCubit>().logout(),
              ),
              icon: const Icon(Icons.logout_rounded, color: Colors.white),
              label: Text('Logout Account', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorRed,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
              ),
            ),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, bottom: 12.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w900,
          color: AppColors.textTertiary,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildGroupedContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: AppColors.softShadow,
        border: Border.all(color: AppColors.borderSubtle, width: 0.5),
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
                child: Divider(height: 1, color: AppColors.borderSubtle.withValues(alpha: 0.5)),
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
              Icon(icon, size: 22.sp, color: AppColors.textSecondary),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: AppColors.textDark),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, size: 20.sp, color: AppColors.textTertiary),
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
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Row(
        children: [
          Icon(icon, size: 22.sp, color: AppColors.textSecondary),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: AppColors.textDark),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primaryBlue,
            activeTrackColor: AppColors.primaryBlue.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }


  void _showThemeBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))),
      builder: (context) => Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Appearance', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800)),
            SizedBox(height: 16.h),
            ...[
              (ThemeMode.light, 'Light Mode'), 
              (ThemeMode.dark, 'Dark Mode'), 
              (ThemeMode.system, 'System Default')
            ].map((t) => 
              RadioListTile<ThemeMode>(
                value: t.$1,
                groupValue: context.watch<ThemeCubit>().state,
                onChanged: (v) {
                  context.read<ThemeCubit>().updateTheme(v!);
                  Navigator.pop(context);
                },
                title: Text(t.$2, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600)),
                activeColor: AppColors.primaryBlue,
              )
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))),
      builder: (context) => Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Language', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800)),
            SizedBox(height: 16.h),
            ...[('english', 'English'), ('nepali', 'Nepali (नेपाली)')].map((l) => 
              RadioListTile<String>(
                value: l.$1,
                groupValue: _selectedLanguage,
                onChanged: (v) {
                  setState(() => _selectedLanguage = v!);
                  Navigator.pop(context);
                },
                title: Text(l.$2, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600)),
                activeColor: AppColors.primaryBlue,
              )
            ),
          ],
        ),
      ),
    );
  }

  String _getThemeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light: return 'Light Mode';
      case ThemeMode.dark: return 'Dark Mode';
      case ThemeMode.system: return 'System Default';
    }
  }
  String _getLanguageLabel(String l) => l == 'english' ? 'English' : 'Nepali (नेपाली)';
}
