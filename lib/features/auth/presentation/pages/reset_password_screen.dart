import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:collab_task/core/app/router/app_router.dart';
import 'package:collab_task/core/config/constants/color_constant.dart';
import 'package:collab_task/core/config/theme/app_colors_extension.dart';
import 'package:collab_task/core/config/constants/typography_constant.dart';
import 'package:collab_task/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:collab_task/features/auth/presentation/cubit/auth_state.dart';
import 'package:collab_task/features/auth/presentation/widgets/app_primary_button.dart';
import 'package:collab_task/features/auth/presentation/widgets/app_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onResetPasswordPressed() {
    if (_newPasswordController.text.isEmpty) return;
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }
    context.read<AuthCubit>().updatePassword(_newPasswordController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          unauthenticated: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password updated successfully! Please login.')),
            );
            context.goNamed(MainRoutes.authName);
          },
          error: (failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(failure.toString())),
            );
          },
          orElse: () {},
        );
      },
      child: Scaffold(
        backgroundColor: colors.scaffold,
        body: Stack(
          children: [
            const SizedBox.expand(),
            // Hero
            Container(
              height: 300.h,
              width: double.infinity,
              decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 48.h),
                      Text(
                        'New Password',
                        style: AppTypography.h1.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                      ),
                      Text(
                        'Set a secure password for your account',
                        style: TextStyle(color: Colors.white70, fontSize: 16.sp, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Form card
            Positioned.fill(
              top: 220.h,
              child: Container(
                padding: EdgeInsets.fromLTRB(24.w, 40.h, 24.w, 24.h),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(36.r)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, -10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      label: 'New Password',
                      hintText: 'Enter new password',
                      obscureText: true,
                      controller: _newPasswordController,
                    ),
                    16.verticalSpace,
                    AppTextField(
                      label: 'Confirm Password',
                      hintText: 'Repeat new password',
                      obscureText: true,
                      controller: _confirmPasswordController,
                    ),
                    40.verticalSpace,
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return AppPrimaryButton(
                          text: 'Reset Password',
                          onPressed: state.maybeWhen(
                            loading: () => null,
                            orElse: () => _onResetPasswordPressed,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
