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

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSendOtpPressed() {
    if (_emailController.text.isEmpty) return;
    context.read<AuthCubit>().resetPassword(_emailController.text.trim());
  }

  void _onBackToLoginPressed() {
    context.goNamed(MainRoutes.authName);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          error: (failure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(failure.toString())));
          },
          unauthenticated: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Reset OTP sent to your email!')),
            );
            context.pushNamed(
              MainRoutes.otpInputName,
              extra: _emailController.text.trim(),
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
            // Hero Gradient Background
            Container(
              height: 300.h,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 30.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        'Reset Password',
                        style: AppTypography.h1.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'We\'ll send a code to your email',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
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
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(36.r),
                  ),
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
                      label: 'Email Address',
                      hintText: 'Enter your email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    40.verticalSpace,
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return AppPrimaryButton(
                          text: 'Send OTP',
                          onPressed: state.maybeWhen(
                            loading: () => null,
                            orElse: () => _onSendOtpPressed,
                          ),
                        );
                      },
                    ),
                    32.verticalSpace,
                    Center(
                      child: TextButton(
                        onPressed: _onBackToLoginPressed,
                        child: const Text(
                          'Back to Login',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
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
