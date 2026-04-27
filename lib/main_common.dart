import 'dart:developer';

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_starter/core/app/app.dart';
import 'package:flutter_clean_starter/core/app/bloc_observer.dart';
import 'package:flutter_clean_starter/core/app/di/injection_container.dart';
import 'package:flutter_clean_starter/core/app/di/multi_bloc_provider.dart';
import 'package:flutter_clean_starter/core/config/constants/api_constant.dart';
import 'package:flutter_clean_starter/core/config/constants/app_constant.dart';
import 'package:flutter_clean_starter/core/helper/secure_storage_helper.dart';
import 'package:flutter_clean_starter/core/services/fcm_notification_service.dart';
import 'package:flutter_clean_starter/firebase_options.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();
var navigatorKey = GlobalKey<NavigatorState>();
void mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('🚀 Running in: ${AppConfig.environment.name}');

  // Cap the in-memory image cache. Flutter defaults to 1000 entries / 100 MB,
  // which is excessive for a utility app. Tighter caps reduce memory pressure
  // on low-end devices without hurting UX (disk cache is untouched).
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
  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Get FCM token
  final fcmToken = await FirebaseMessaging.instance.getToken();

  // Initialize Shared Preferences
  await SecureStorageHelper().init();
  if (fcmToken != null) {
    SecureStorageHelper().saveDeviceToken(fcmToken);
  }

  if (AppConfig.enableIpConfig) {
    ApiConstants.baseUrl = ApiConstants.buildBaseUrl(
      SecureStorageHelper().getBaseIp(),
    );
  }

  ChuckerFlutter.showOnRelease =
      !AppConfig.isProduction && SecureStorageHelper().getChuckerEnabled();

  // Initialize FCM notification service (foreground display + tap handling)
  await FcmNotificationService().init();

  setupInjection();

  log('Device token: ${SecureStorageHelper().getDeviceToken()}');

  debugPrint('Device token: ${SecureStorageHelper().getDeviceToken()}');

  SecureStorageHelper().debugDump();
}
