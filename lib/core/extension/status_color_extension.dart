import 'dart:ui';

import 'package:flutter_clean_starter/core/config/constants/color_constant.dart';

extension StatusColor on String {
  Color get statusColor {
    switch (toUpperCase()) {
      case 'OPEN':
        return AppColors.warningGold;
      case 'APPROVED':
        return AppColors.primaryTeal2;
      case 'REJECTED':
        return AppColors.errorRed;
      case 'WORK_IN_PROGRESS' || 'WORK IN PROGRESS':
        return AppColors.warningDeep;
      case 'COMPLETED':
        return AppColors.successGreen;
      default:
        return AppColors.errorRed; // Default for 'ALL' or unknown
    }
  }
}
