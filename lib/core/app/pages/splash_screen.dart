import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:collab_task/core/app/router/app_router.dart';
import 'package:collab_task/core/config/constants/app_constant.dart';
import 'package:collab_task/core/config/constants/color_constant.dart';
import 'package:collab_task/core/config/constants/typography_constant.dart';
import 'package:collab_task/core/helper/secure_storage_helper.dart';
import 'package:collab_task/l10n/gen/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    if (AppConfig.enableIpConfig) {
      context.goNamed(MainRoutes.ipConfigName);
      return;
    }

    final isLoggedIn = SecureStorageHelper().isUserLoggedIn();
    context.goNamed(isLoggedIn ? MainRoutes.taskBoardName : MainRoutes.authName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(20.r),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryBlue,
              ),
              child: Icon(
                Icons.flutter_dash,
                size: 80.r,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              AppLocalizations.of(context).appName,
              style: AppTypography.h1.copyWith(color: AppColors.primaryBlue),
            ),
            const SizedBox(height: 24),
            CircularProgressIndicator(
              color: AppColors.primaryBlue,
              strokeWidth: 4.r,
            ),
          ],
        ),
      ),
    );
  }
}
