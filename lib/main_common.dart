import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collab_task/core/app/app.dart';
import 'package:collab_task/core/app/bloc_observer.dart';
import 'package:collab_task/core/app/di/injection_container.dart';
import 'package:collab_task/core/app/di/multi_bloc_provider.dart';
import 'package:collab_task/core/config/constants/api_constant.dart';
import 'package:collab_task/core/config/constants/app_constant.dart';
import 'package:collab_task/core/helper/secure_storage_helper.dart';
// Uncomment when you wire Firebase + FCM (see initializeApp).
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:collab_task/core/services/fcm_notification_service.dart';
// import 'package:collab_task/firebase_options.dart';

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
  await SecureStorageHelper().init();

  if (AppConfig.enableIpConfig) {
    ApiConstants.baseUrl = ApiConstants.buildBaseUrl(
      SecureStorageHelper().getBaseIp(),
    );
  }


  ChuckerFlutter.showOnRelease =
      !AppConfig.isProduction && SecureStorageHelper().getChuckerEnabled();

  // ── Firebase + FCM (disabled in the starter) ──────────────────────────
  // To enable push notifications:
  //   1. Run `flutterfire configure` (regenerates lib/firebase_options.dart,
  //      android/app/google-services.json, ios/Runner/GoogleService-Info.plist).
  //   2. Uncomment the Firebase imports at the top of this file.
  //   3. Uncomment the block below.
  //   4. The FCM service is already wired in the DI container — no further
  //      changes needed there.
  //
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // final fcmToken = await FirebaseMessaging.instance.getToken();
  // if (fcmToken != null) {
  //   SecureStorageHelper().saveDeviceToken(fcmToken);
  // }
  // await FcmNotificationService().init();

  setupInjection();
}
