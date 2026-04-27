import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_clean_starter/core/config/constants/app_size_constant.dart';
import 'package:flutter_clean_starter/core/config/constants/color_constant.dart';
import 'package:flutter_clean_starter/core/config/constants/typography_constant.dart';
import 'package:flutter_clean_starter/core/config/theme/app_colors_extension.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool isRequired;

  const AppTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label row
        Row(
          children: [
            Text(
              '$label ',
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: context.appColors.textPrimary,
              ),
            ),
            if (isRequired)
              Text(
                '*',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.errorRed,
                ),
              ),
          ],
        ),
        4.verticalSpace,
        // Text field
        SizedBox(
          // height: 39.h,
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,

            decoration: InputDecoration(
              isDense: true,
              constraints: BoxConstraints(
                maxHeight: 70.h, // Allow enough room for BOTH field and error
                minHeight: 39.h, // Your desired design height
              ),
              hintText: hintText,
              hintStyle: AppTypography.bodyMedium,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 10.h,
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
                borderSide: BorderSide(color: context.appColors.divider),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
                borderSide: BorderSide(color: context.appColors.divider),
              ),
              suffixIcon: suffixIcon,
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }
}
