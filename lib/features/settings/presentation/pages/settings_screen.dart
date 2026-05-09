import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:collab_task/core/config/constants/color_constant.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _pushNotifications = true;
  String _selectedTheme = 'system';
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
          // Account Section
          _buildSectionHeader('ACCOUNT'),
          _buildGroupedContainer([
            _buildSettingsTile(
              icon: Icons.person_rounded,
              iconBg: AppColors.surfaceBlue,
              iconColor: AppColors.primaryBlue,
              title: 'Profile',
              subtitle: 'Update your personal info',
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: Icons.lock_rounded,
              iconBg: AppColors.surfaceRose,
              iconColor: AppColors.errorRed,
              title: 'Security',
              subtitle: 'Password and biometric',
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: Icons.notifications_rounded,
              iconBg: AppColors.surfaceAmber,
              iconColor: AppColors.warningAmber,
              title: 'Notifications',
              subtitle: 'Preferences and alerts',
              onTap: () {},
            ),
          ]),

          SizedBox(height: 32.h),

          // Preferences Section
          _buildSectionHeader('PREFERENCES'),
          _buildGroupedContainer([
            _buildSettingsTile(
              icon: Icons.palette_rounded,
              iconBg: AppColors.surfaceIndigo,
              iconColor: AppColors.primaryViolet,
              title: 'Theme',
              subtitle: _getThemeLabel(_selectedTheme),
              onTap: _showThemeBottomSheet,
            ),
            _buildSettingsTile(
              icon: Icons.translate_rounded,
              iconBg: AppColors.surfaceEmerald,
              iconColor: AppColors.primaryTeal,
              title: 'Language',
              subtitle: _getLanguageLabel(_selectedLanguage),
              onTap: _showLanguageBottomSheet,
            ),
          ]),

          SizedBox(height: 32.h),

          // App Settings
          _buildSectionHeader('APP SETTINGS'),
          _buildGroupedContainer([
            _buildSwitchTile(
              icon: Icons.cloud_done_rounded,
              iconBg: AppColors.surfaceBlue,
              iconColor: AppColors.primaryBlue,
              title: 'Auto-sync',
              subtitle: 'Keep data updated in real-time',
              value: _notificationsEnabled,
              onChanged: (v) => setState(() => _notificationsEnabled = v),
            ),
            _buildSwitchTile(
              icon: Icons.vibration_rounded,
              iconBg: AppColors.surfaceSubtle,
              iconColor: AppColors.textSecondary,
              title: 'Haptic Feedback',
              subtitle: 'Soft vibrations on interactions',
              value: _pushNotifications,
              onChanged: (v) => setState(() => _pushNotifications = v),
            ),
          ]),

          SizedBox(height: 48.h),

          // Logout Button
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              boxShadow: AppColors.softShadow,
            ),
            child: ElevatedButton.icon(
              onPressed: _showLogoutDialog,
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
    required Color iconBg,
    required Color iconColor,
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
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(icon, size: 22.sp, color: iconColor),
              ),
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
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(icon, size: 22.sp, color: iconColor),
          ),
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
            activeColor: AppColors.primaryBlue,
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
            ...[('light', 'Light Mode'), ('dark', 'Dark Mode'), ('system', 'System Default')].map((t) => 
              RadioListTile<String>(
                value: t.$1,
                groupValue: _selectedTheme,
                onChanged: (v) {
                  setState(() => _selectedTheme = v!);
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

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        title: Text('Logout', style: TextStyle(fontWeight: FontWeight.w800)),
        content: Text('Are you sure you want to exit?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorRed, foregroundColor: Colors.white),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  String _getThemeLabel(String t) => t == 'light' ? 'Light Mode' : t == 'dark' ? 'Dark Mode' : 'System Default';
  String _getLanguageLabel(String l) => l == 'english' ? 'English' : 'Nepali (नेपाली)';
}
