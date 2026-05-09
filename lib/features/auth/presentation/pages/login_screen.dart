import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:collab_task/core/app/router/app_router.dart';
import 'package:collab_task/core/config/constants/app_size_constant.dart';
import 'package:collab_task/core/config/constants/color_constant.dart';
import 'package:collab_task/core/config/theme/app_colors_extension.dart';
import 'package:collab_task/core/config/constants/typography_constant.dart';
import 'package:collab_task/l10n/gen/app_localizations.dart';
import 'package:collab_task/features/auth/presentation/widgets/app_primary_button.dart';
import 'package:collab_task/features/auth/presentation/widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _customerOrgIdController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _customerOrgIdController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _customerOrgIdController.text = 'customer@organization';
    _phoneController.text = '9876543210';
  }

  void _onLoginPressed() {
    context.goNamed(MainRoutes.taskBoardName);
  }

  void _onForgotPasswordPressed() {
    context.goNamed(MainRoutes.forgotPasswordName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 1.sw * 0.57,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primaryTeal,
                  AppColors.secondaryTeal,
                  AppColors.primaryTeal,
                ],
              ),
            ),
          ),
          SafeArea(
            child: CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 80.h, bottom: 16.h),
                          child: Icon(
                            Icons.flutter_dash,
                            size: 96.r,
                            color: AppColors.surfaceWhite,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Text(
                          AppLocalizations.of(context).hello,
                          style: AppTypography.h1.copyWith(
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Text(
                          AppLocalizations.of(context).welcomeBack,
                          style: AppTypography.h1.copyWith(
                            color: AppColors.surfaceWhite,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      24.verticalSpace,
                    ],
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 27.h,
                    ),
                    decoration: BoxDecoration(
                      color: context.appColors.surface,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppSizes.radiusXL),
                        topRight: Radius.circular(AppSizes.radiusXL),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            AppLocalizations.of(context).enterToYourAccount,
                            style: AppTypography.h3,
                          ),
                        ),
                        SizedBox(height: 32.h),
                        AppTextField(
                          label: AppLocalizations.of(context).customerId,
                          hintText: AppLocalizations.of(context).customerIdHint,
                          controller: _customerOrgIdController,
                        ),
                        16.verticalSpace,
                        AppTextField(
                          label: AppLocalizations.of(context).phoneNumber,
                          hintText: AppLocalizations.of(context).phoneNumberHint,
                          keyboardType: TextInputType.phone,
                          controller: _phoneController,
                        ),
                        8.verticalSpace,
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                            ),
                            const Text('Remember Me'),
                            const Spacer(),
                            TextButton(
                              onPressed: _onForgotPasswordPressed,
                              child: const Text('Forgot Password?'),
                            ),
                          ],
                        ),
                        24.verticalSpace,
                        AppPrimaryButton(
                          text: AppLocalizations.of(context).logIn,
                          icon: Icons.arrow_forward,
                          onPressed: _onLoginPressed,
                        ),
                        85.verticalSpace,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
