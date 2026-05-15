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

class OtpInputScreen extends StatefulWidget {
  final String email;
  const OtpInputScreen({super.key, required this.email});

  @override
  State<OtpInputScreen> createState() => _OtpInputScreenState();
}

class _OtpInputScreenState extends State<OtpInputScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  @override
  void dispose() {
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onVerifyOtpPressed() {
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length < 6) return;
    context.read<AuthCubit>().verifyOtp(email: widget.email, token: otp);
  }

  void _onResendOtpPressed() {
    context.read<AuthCubit>().resetPassword(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          authenticated: (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('OTP Verified! Please set your new password.')),
            );
            context.goNamed(MainRoutes.resetPasswordName);
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
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(Icons.arrow_back_ios_new_rounded, size: 18.sp, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        'Verify OTP',
                        style: AppTypography.h1.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                      ),
                      Text(
                        'Sent to ${widget.email}',
                        style: TextStyle(color: Colors.white70, fontSize: 14.sp, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                padding: EdgeInsets.fromLTRB(20.w, 40.h, 20.w, 24.h),
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
                    SizedBox(height: 32.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (index) {
                        return SizedBox(
                          width: 45.w,
                          height: 55.h,
                          child: TextField(
                            controller: _otpControllers[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800, color: colors.textPrimary),
                            decoration: InputDecoration(
                              counterText: '',
                              filled: true,
                              fillColor: AppColors.surfaceSubtle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 5) {
                                FocusScope.of(context).nextFocus();
                              } else if (value.isEmpty && index > 0) {
                                FocusScope.of(context).previousFocus();
                              }
                            },
                          ),
                        );
                      }),
                    ),
                    40.verticalSpace,
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return AppPrimaryButton(
                          text: 'Verify OTP',
                          onPressed: state.maybeWhen(
                            loading: () => null,
                            orElse: () => _onVerifyOtpPressed,
                          ),
                        );
                      },
                    ),
                    32.verticalSpace,
                    Center(
                      child: TextButton(
                        onPressed: _onResendOtpPressed,
                        child: const Text(
                          'Resend Code',
                          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primaryBlue),
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
