import 'package:flutter/foundation.dart';

class AppConfig {
  static bool get enableIpConfig => !kReleaseMode;
  static bool get isProduction => kReleaseMode;

  // Compatibility for old code that might still call init
  static void init({dynamic env}) {
    debugPrint('AppConfig initialized (flavors removed)');
  }
}
