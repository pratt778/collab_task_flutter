import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_clean_starter/core/config/constants/color_constant.dart';
import 'package:flutter_clean_starter/core/config/constants/typography_constant.dart';
import 'package:flutter_clean_starter/l10n/gen/app_localizations.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool hideTitle;
  final Widget? trailing;
  final Widget? centerChild;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.hideTitle = false,
    this.trailing,
    this.centerChild,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 127.h,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(
        color: AppColors.primaryTeal, // Teal background from screenshot
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20.r), // Large curved corners
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          bottom: 17.h,
          top: 17.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back Button
            if (showBackButton)
              IconButton(
                tooltip: AppLocalizations.of(context).a11yBack,
                icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.r),
                onPressed: () => context.pop(),
              ),
            48.horizontalSpace, // Title
            if (!hideTitle)
              Expanded(
                child:
                    centerChild ??
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: AppTypography.h3.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
              ),
            trailing ?? 48.horizontalSpace,
            // Search Icon with Circle Background
            //
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(127.h); // Adjust height based on design
}
