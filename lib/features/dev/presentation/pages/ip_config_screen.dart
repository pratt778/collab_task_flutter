import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:collab_task/core/app/di/injection_container.dart';
import 'package:collab_task/core/app/router/app_router.dart';
import 'package:collab_task/core/config/constants/api_constant.dart';
import 'package:collab_task/core/config/constants/app_size_constant.dart';
import 'package:collab_task/core/config/constants/color_constant.dart';
import 'package:collab_task/core/config/constants/typography_constant.dart';
import 'package:collab_task/core/config/theme/app_colors_extension.dart';
import 'package:collab_task/core/helper/secure_storage_helper.dart';
import 'package:collab_task/features/auth/presentation/widgets/app_primary_button.dart';
import 'package:collab_task/features/shared/widget/custom_appbar.dart';

enum _IpPreset { dev, local, custom }

class IpConfigScreen extends StatefulWidget {
  const IpConfigScreen({super.key});

  @override
  State<IpConfigScreen> createState() => _IpConfigScreenState();
}

class _IpConfigScreenState extends State<IpConfigScreen> {
  late final String _currentHost;
  late _IpPreset _selected;
  final _customController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentHost = SecureStorageHelper().getBaseIp();
    _selected = switch (_currentHost) {
      ApiConstants.devIp => _IpPreset.dev,
      ApiConstants.localIp => _IpPreset.local,
      _ => _IpPreset.custom,
    };
    if (_selected == _IpPreset.custom) {
      _customController.text = _currentHost;
    }
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  String? get _resolvedHost {
    switch (_selected) {
      case _IpPreset.dev:
        return ApiConstants.devIp;
      case _IpPreset.local:
        return ApiConstants.localIp;
      case _IpPreset.custom:
        final raw = _customController.text.trim();
        if (!raw.startsWith('http://') && !raw.startsWith('https://')) {
          return null;
        }
        return raw.isEmpty ? null : raw;
    }
  }

  void _onNext() {
    final host = _resolvedHost;
    if (host == null) return;

    SecureStorageHelper().saveBaseIp(host);
    ApiConstants.baseUrl = ApiConstants.buildBaseUrl(host);
    sl<Dio>().options.baseUrl = ApiConstants.baseUrl;

    final isLoggedIn = SecureStorageHelper().isUserLoggedIn();
    context.goNamed(isLoggedIn ? MainRoutes.taskBoardName : MainRoutes.authName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.surface,
      appBar: const CustomAppBar(
        title: 'Developer Config',
        showBackButton: false,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 40.h),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Select API environment',
                        style: AppTypography.h3.copyWith(
                          color: context.appColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      8.verticalSpace,
                      Text(
                        'Current: $_currentHost',
                        style: AppTypography.bodyMedium.copyWith(
                          color: context.appColors.textSecondary,
                        ),
                      ),
                      20.verticalSpace,
                      _PresetTile(
                        label: 'Dev',
                        subtitle: ApiConstants.devIp,
                        selected: _selected == _IpPreset.dev,
                        onTap: () => setState(() => _selected = _IpPreset.dev),
                      ),
                      12.verticalSpace,
                      _PresetTile(
                        label: 'Local',
                        subtitle: ApiConstants.localIp,
                        selected: _selected == _IpPreset.local,
                        onTap: () => setState(() => _selected = _IpPreset.local),
                      ),
                      12.verticalSpace,
                      _PresetTile(
                        label: 'Custom',
                        subtitle: 'Enter your own host',
                        selected: _selected == _IpPreset.custom,
                        onTap: () => setState(() => _selected = _IpPreset.custom),
                      ),
                      if (_selected == _IpPreset.custom) ...[
                        12.verticalSpace,
                        TextField(
                          controller: _customController,
                          keyboardType: TextInputType.url,
                          autocorrect: false,
                          onChanged: (_) => setState(() {}),
                          style: AppTypography.bodyMedium.copyWith(
                            color: context.appColors.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: 'http://192.168.1.50:8080',
                            hintStyle: AppTypography.bodyMedium.copyWith(
                              color: context.appColors.textTertiary,
                            ),
                            filled: true,
                            fillColor: context.appColors.surfaceAlt,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppSizes.radiusM),
                              borderSide: BorderSide(
                                color: context.appColors.dividerLight,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppSizes.radiusM),
                              borderSide: BorderSide(
                                color: context.appColors.dividerLight,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppSizes.radiusM),
                              borderSide: const BorderSide(
                                color: AppColors.primaryBlue,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 14.h,
                            ),
                          ),
                        ),
                      ],
                      const Spacer(),
                      SizedBox(height: 24.h),
                      AppPrimaryButton(
                        text: 'Next',
                        onPressed: _resolvedHost == null ? null : _onNext,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PresetTile extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _PresetTile({
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppSizes.radiusM),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: context.appColors.surfaceAlt,
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          border: Border.all(
            color: selected
                ? AppColors.primaryBlue
                : context.appColors.dividerLight,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: selected
                  ? AppColors.primaryBlue
                  : context.appColors.textTertiary,
              size: 22.r,
            ),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTypography.bodyLarge.copyWith(
                      color: context.appColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  2.verticalSpace,
                  Text(
                    subtitle,
                    style: AppTypography.caption.copyWith(
                      color: context.appColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
