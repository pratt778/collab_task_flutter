import 'package:collab_task/core/extension/snackbar_extension.dart';
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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSignUpPressed() {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      context.showSnackbar('Passwords do not match', isError: true);
      return;
    }

    context.read<AuthCubit>().register(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      name: _nameController.text.trim(),
    );
  }

  void _onLoginPressed() => context.goNamed(MainRoutes.authName);

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        state.whenOrNull(
          authenticated: (_) {
            context.showSnackbar('Account Created!!');
            context.goNamed(MainRoutes.taskBoardName);
          },
          error: (err) {
            context.showSnackbar(err.message, isError: true);
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text(failure.toString())),
            // );
          },
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
                        'Create Account',
                        style: AppTypography.h1.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'Join the team today',
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

            // Register Form
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextField(
                        label: 'Full Name',
                        hintText: 'Enter your name',
                        controller: _nameController,
                      ),
                      16.verticalSpace,
                      AppTextField(
                        label: 'Email Address',
                        hintText: 'name@example.com',
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                      ),
                      16.verticalSpace,
                      AppTextField(
                        label: 'Password',
                        hintText: 'Minimum 8 characters',
                        obscureText: true,
                        controller: _passwordController,
                      ),
                      16.verticalSpace,
                      AppTextField(
                        label: 'Confirm Password',
                        hintText: 'Repeat your password',
                        obscureText: true,
                        controller: _confirmPasswordController,
                      ),
                      40.verticalSpace,
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return AppPrimaryButton(
                            text: 'Sign Up',
                            onPressed: state.maybeWhen(
                              loading: () => null,
                              orElse: () => _onSignUpPressed,
                            ),
                          );
                        },
                      ),
                      32.verticalSpace,
                      Center(
                        child: GestureDetector(
                          onTap: _onLoginPressed,
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: colors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                              children: const [
                                TextSpan(text: 'Already have an account? '),
                                TextSpan(
                                  text: 'Login',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
