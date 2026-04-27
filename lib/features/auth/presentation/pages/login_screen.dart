import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_clean_starter/core/app/router/app_router.dart';
import 'package:flutter_clean_starter/core/config/constants/app_size_constant.dart';
import 'package:flutter_clean_starter/core/config/constants/color_constant.dart';
import 'package:flutter_clean_starter/core/config/theme/app_colors_extension.dart';
import 'package:flutter_clean_starter/core/config/constants/typography_constant.dart';
import 'package:flutter_clean_starter/core/error/failure_messages.dart';
import 'package:flutter_clean_starter/core/extension/snackbar_extension.dart';
import 'package:flutter_clean_starter/l10n/gen/app_localizations.dart';
import 'package:flutter_clean_starter/core/helper/secure_storage_helper.dart';
import 'package:flutter_clean_starter/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter_clean_starter/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_clean_starter/features/auth/presentation/widgets/app_primary_button.dart';
import 'package:flutter_clean_starter/features/auth/presentation/widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _customerOrgIdController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _customerOrgIdController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _customerOrgIdController.text = SecureStorageHelper().getAccountInfo();
    _phoneController.text = SecureStorageHelper().getPhoneNumber();
  }

  void _onLoginPressed() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthCubit>().login(
      phoneNumber: _phoneController.text.trim(),
      customerNo: customerOrganizationCode(
        _customerOrgIdController.text.trim(),
      )['customerNo']!,
      organizationCode: customerOrganizationCode(
        _customerOrgIdController.text.trim(),
      )['organizationCode']!,
    );
  }

  Map<String, String> customerOrganizationCode(String fullid) {
    if (fullid.contains('@')) {
      final List<String> parts = fullid.split('@');

      // parts[0] is everything before @
      // parts[1] is everything after @
      final String customerNo = parts[0];
      final String organizationCode = parts[1];

      // Now use them in your request
      debugPrint('Customer ID: $customerNo');
      debugPrint('Org Code: $organizationCode');
      return {'customerNo': customerNo, 'organizationCode': organizationCode};
    } else {
      // Handle error if the user forgets the @ symbol
      debugPrint('Invalid format. Use customerId@orgCode');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          state.whenOrNull(
            error: (failure) {
              context.showSnackbar(
                localizedFailureMessage(context, failure),
                isError: true,
              );
            },
            authenticated: (user) {
              context.showSnackbar(
                AppLocalizations.of(context).loginSuccessful,
              );
              context.goNamed(MainRoutes.demoName);
            },
          );
        },
        builder: (context, state) {
          final bool isLoading = state.maybeWhen(
            loading: () => true,
            orElse: () => false,
          );

          return Stack(
            children: [
              Container(
                height: double.infinity * 0.57,
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
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Branding placeholder — swap in your own logo asset.
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
                          // Hello text
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

                          // Welcome back text
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
                    // White card with form — extends to bottom
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
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Center(
                                child: Text(
                                  AppLocalizations.of(
                                    context,
                                  ).enterToYourAccount,
                                  style: AppTypography.h3,
                                ),
                              ),
                              SizedBox(height: 32.h),

                              // User Name field
                              AppTextField(
                                label: AppLocalizations.of(context).customerId,
                                hintText: AppLocalizations.of(
                                  context,
                                ).customerIdHint,
                                controller: _customerOrgIdController,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return AppLocalizations.of(
                                      context,
                                    ).pleaseEnterCustomerId;
                                  }
                                  if (!value.contains('@')) {
                                    return AppLocalizations.of(
                                      context,
                                    ).pleaseEnterValidCustomerId;
                                  }
                                  final parts = value.split('@');
                                  if (parts.length != 2) {
                                    return AppLocalizations.of(
                                      context,
                                    ).pleaseEnterValidCustomerId;
                                  }
                                  if (parts[0].isEmpty || parts[1].isEmpty) {
                                    return AppLocalizations.of(
                                      context,
                                    ).pleaseEnterValidCustomerId;
                                  }

                                  return null;
                                },
                              ),
                              16.verticalSpace,

                              // Phone Number field
                              AppTextField(
                                label: AppLocalizations.of(context).phoneNumber,
                                hintText: AppLocalizations.of(
                                  context,
                                ).phoneNumberHint,
                                keyboardType: TextInputType.phone,
                                controller: _phoneController,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return AppLocalizations.of(
                                      context,
                                    ).pleaseEnterPhoneNumber;
                                  }
                                  if (value.length != 10) {
                                    return AppLocalizations.of(
                                      context,
                                    ).pleaseEnterValidPhoneNumber;
                                  }
                                  if (!value.startsWith('9')) {
                                    return AppLocalizations.of(
                                      context,
                                    ).pleaseEnterValidPhoneNumber;
                                  }
                                  return null;
                                },
                              ),
                              24.verticalSpace,

                              // Login button
                              AppPrimaryButton(
                                text: AppLocalizations.of(context).logIn,
                                icon: Icons.arrow_forward,
                                isLoading: isLoading,
                                onPressed: _onLoginPressed,
                              ),
                              85.verticalSpace,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
