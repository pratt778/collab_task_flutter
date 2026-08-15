import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:collab_task/core/app/di/injection_container.dart';
import 'package:collab_task/core/config/constants/color_constant.dart';
import 'package:collab_task/core/config/theme/app_colors_extension.dart';
import 'package:collab_task/core/error/failure_messages.dart';
import 'package:collab_task/core/helper/date_time_helper.dart';
import 'package:collab_task/features/profile/domain/entities/profile_entity.dart';
import 'package:collab_task/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:collab_task/features/profile/presentation/cubit/profile_state.dart';
import 'package:collab_task/l10n/gen/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileCubit>()..loadProfile(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: colors.scaffold,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colors.textPrimary,
        title: Text(
          l.profile,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20.sp,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, size: 22.sp),
            tooltip: 'Refresh',
            onPressed: () => context.read<ProfileCubit>().loadProfile(),
          ),
        ],
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          state.maybeWhen(
            error: (failure, _) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(localizedFailureMessage(context, failure)),
                  backgroundColor: AppColors.errorRed,
                ),
              );
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            updating: (profile) => _buildProfileBody(
              context,
              profile,
              colors,
              isUpdating: true,
            ),
            loaded: (profile) => _buildProfileBody(
              context,
              profile,
              colors,
              isUpdating: false,
            ),
            error: (failure, cachedProfile) {
              if (cachedProfile != null) {
                return _buildProfileBody(
                  context,
                  cachedProfile,
                  colors,
                  isUpdating: false,
                );
              }
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 48.sp,
                        color: AppColors.errorRed,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        localizedFailureMessage(context, failure),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: colors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton.icon(
                        onPressed: () =>
                            context.read<ProfileCubit>().loadProfile(),
                        icon: const Icon(Icons.refresh_rounded),
                        label: Text(l.retry),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProfileBody(
    BuildContext context,
    ProfileEntity profile,
    AppColorsExtension colors, {
    required bool isUpdating,
  }) {
    final displayName = profile.displayName?.trim().isNotEmpty == true
        ? profile.displayName!
        : (profile.email.isNotEmpty ? profile.email.split('@').first : 'User');

    final initials = displayName.isNotEmpty
        ? displayName
            .split(' ')
            .where((part) => part.isNotEmpty)
            .take(2)
            .map((part) => part[0].toUpperCase())
            .join()
        : 'U';

    return RefreshIndicator(
      onRefresh: () => context.read<ProfileCubit>().loadProfile(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        children: [
          if (isUpdating)
            LinearProgressIndicator(
              backgroundColor: colors.surfaceAlt,
              valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
            ),
          // --- Header Profile Avatar & Info Card ---
          Container(
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: colors.border, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: colors.shadow,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Avatar
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 90.r,
                      height: 90.r,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colors.primary.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        initials,
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        width: 14.r,
                        height: 14.r,
                        decoration: const BoxDecoration(
                          color: AppColors.successGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Name
                Text(
                  displayName,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),

                // Email
                Text(
                  profile.email,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.textSecondary,
                  ),
                ),
                SizedBox(height: 12.h),

                // Verified Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.successGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: AppColors.successGreen.withValues(alpha: 0.3),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_rounded,
                        size: 14.sp,
                        color: AppColors.successGreen,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Active Account',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.successGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 24.h),

          // --- Section 1: Personal Details ---
          _buildSectionHeader('PERSONAL INFORMATION', colors),
          _buildGroupedContainer(
            [
              _buildInfoTile(
                icon: Icons.person_outline_rounded,
                title: 'Display Name',
                value: profile.displayName ?? 'Not set',
                colors: colors,
                onTap: () => _showEditProfileDialog(context, profile, colors),
              ),
              _buildInfoTile(
                icon: Icons.email_outlined,
                title: 'Email Address',
                value: profile.email,
                colors: colors,
                trailing: Icon(
                  Icons.lock_outline_rounded,
                  size: 18.sp,
                  color: colors.textTertiary,
                ),
              ),
              _buildInfoTile(
                icon: Icons.phone_outlined,
                title: 'Phone Number',
                value: profile.phoneNumber?.isNotEmpty == true
                    ? profile.phoneNumber!
                    : 'Not set',
                colors: colors,
                onTap: () => _showEditProfileDialog(context, profile, colors),
              ),
            ],
            colors,
          ),

          SizedBox(height: 24.h),

          // --- Section 2: Account Metadata ---
          _buildSectionHeader('ACCOUNT DETAILS', colors),
          _buildGroupedContainer(
            [
              _buildInfoTile(
                icon: Icons.fingerprint_rounded,
                title: 'User ID',
                value: profile.id,
                colors: colors,
                subtitleMaxLines: 1,
                trailing: IconButton(
                  icon: Icon(
                    Icons.copy_rounded,
                    size: 18.sp,
                    color: colors.primary,
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: profile.id));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('User ID copied to clipboard'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
              if (profile.createdAt != null)
                _buildInfoTile(
                  icon: Icons.calendar_today_outlined,
                  title: 'Member Since',
                  value: formatToFullDate(profile.createdAt!.toIso8601String()),
                  colors: colors,
                ),
              if (profile.updatedAt != null)
                _buildInfoTile(
                  icon: Icons.access_time_rounded,
                  title: 'Last Updated',
                  value: formatToFullDate(profile.updatedAt!.toIso8601String()),
                  colors: colors,
                ),
            ],
            colors,
          ),

          SizedBox(height: 32.h),

          // --- Edit Profile Button ---
          ElevatedButton.icon(
            onPressed: () => _showEditProfileDialog(context, profile, colors),
            icon: const Icon(Icons.edit_rounded, color: Colors.white),
            label: Text(
              'Edit Profile',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              elevation: 0,
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

  Widget _buildGroupedContainer(
    List<Widget> children,
    AppColorsExtension colors,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20.r),
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
                padding: EdgeInsets.only(left: 56.w),
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

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    required AppColorsExtension colors,
    int subtitleMaxLines = 2,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  color: colors.surfaceAlt,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  size: 20.sp,
                  color: colors.primary,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.textTertiary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      value,
                      maxLines: subtitleMaxLines,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null)
                trailing
              else if (onTap != null)
                Icon(
                  Icons.edit_outlined,
                  size: 18.sp,
                  color: colors.textTertiary,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditProfileDialog(
    BuildContext context,
    ProfileEntity profile,
    AppColorsExtension colors,
  ) {
    final nameController = TextEditingController(text: profile.displayName);
    final phoneController = TextEditingController(text: profile.phoneNumber);
    final formKey = GlobalKey<FormState>();
    final cubit = context.read<ProfileCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (dialogContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 24.h,
            bottom: MediaQuery.of(dialogContext).viewInsets.bottom + 24.h,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(dialogContext),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(
                  'Display Name',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.textSecondary,
                  ),
                ),
                SizedBox(height: 6.h),
                TextFormField(
                  controller: nameController,
                  style: TextStyle(color: colors.textPrimary, fontSize: 14.sp),
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                    filled: true,
                    fillColor: colors.surfaceAlt,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Display name cannot be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                Text(
                  'Phone Number',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.textSecondary,
                  ),
                ),
                SizedBox(height: 6.h),
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: colors.textPrimary, fontSize: 14.sp),
                  decoration: InputDecoration(
                    hintText: 'e.g. +1 555-0199',
                    prefixIcon: const Icon(Icons.phone_outlined),
                    filled: true,
                    fillColor: colors.surfaceAlt,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      final nav = Navigator.of(dialogContext);
                      final success = await cubit.updateProfile(
                        displayName: nameController.text.trim(),
                        phoneNumber: phoneController.text.trim(),
                      );
                      if (success) {
                        nav.pop();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Profile updated successfully'),
                              backgroundColor: AppColors.successGreen,
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    child: Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
