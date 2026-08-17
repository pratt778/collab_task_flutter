import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:collab_task/core/app/app.dart';
import 'package:collab_task/core/app/bloc_observer.dart';
import 'package:collab_task/core/app/di/injection_container.dart';
import 'package:collab_task/core/app/di/multi_bloc_provider.dart';
import 'package:collab_task/core/config/constants/api_constant.dart';
import 'package:collab_task/core/config/constants/app_constant.dart';
import 'package:collab_task/core/helper/secure_storage_helper.dart';

// Uncomment when you wire Firebase + FCM
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:collab_task/core/services/fcm_notification_service.dart';
// import 'package:collab_task/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load();

  // AppConfig is now simplified
  AppConfig.init();

  debugPrint('🚀 Running CollabTask');

  // Cap the in-memory image cache.
  PaintingBinding.instance.imageCache.maximumSize = 100;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 50 * 1024 * 1024;

  // Lock the device orientation to portrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Bloc.observer = AppBlocObserver();

  // Initialize dependencies
  await initializeApp();

  runApp(const MultipleBlocProviders(child: MyApp()));
}

Future<void> initializeApp() async {
  await SecureStorageHelper().init();

  // Initialize Supabase if keys are provided
  if (ApiConstants.supabaseUrl.isNotEmpty &&
      ApiConstants.supabaseAnonKey.isNotEmpty) {
    await Supabase.initialize(
      url: ApiConstants.supabaseUrl,
      anonKey: ApiConstants.supabaseAnonKey,
    );
  } else {
    debugPrint(
      'superbase anon key: ${ApiConstants.supabaseAnonKey} and superbase url is ${ApiConstants.supabaseUrl} ',
    );
    debugPrint(
      '⚠️ WARNING: Supabase keys are missing in .env. Auth will not work.',
    );
  }

  if (AppConfig.enableIpConfig) {
    ApiConstants.baseUrl = ApiConstants.buildBaseUrl(
      SecureStorageHelper().getBaseIp(),
    );
  }

  ChuckerFlutter.showOnRelease =
      !AppConfig.isProduction && SecureStorageHelper().getChuckerEnabled();

  setupInjection();
}
