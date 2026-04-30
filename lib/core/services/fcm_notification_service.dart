import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:collab_task/core/app/router/app_router.dart';

/// Top-level function required by FirebaseMessaging for background messages.
/// Must not be inside a class or an anonymous closure.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('Background message: ${message.messageId}');
}

/// Singleton service that handles all FCM push notification concerns:
/// - Requests notification permissions
/// - Registers background message handler
/// - Initializes local notifications (for foreground display)
/// - Listens to foreground messages
/// - Handles notification taps (foreground + background)
/// - Checks for initial message (app opened from terminated state)
class FcmNotificationService {
  static final FcmNotificationService _instance = FcmNotificationService._();
  factory FcmNotificationService() => _instance;
  FcmNotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const _androidChannel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'Used for important push notifications',
    importance: Importance.high,
  );

  /// Call once after Firebase.initializeApp()
  Future<void> init() async {
    // Register background handler (must be top-level function)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request permissions (required for iOS & Android 13+)
    await _requestPermission();

    await _initLocalNotifications();
    await _createAndroidChannel();
    _listenForegroundMessages();
    _listenNotificationTaps();
    await _handleInitialMessage();
  }

  /// Request notification permissions from the user
  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted notification permission');
    } else {
      debugPrint('User declined notification permission');
    }
  }

  /// Initialize flutter_local_notifications plugin
  Future<void> _initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _localNotifications.initialize(
      settings: const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
    );
  }

  /// Create the Android notification channel
  Future<void> _createAndroidChannel() async {
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel);
  }

  /// Show a local notification when a message arrives while app is in foreground
  void _listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Foreground message received: ${message.messageId}');
      debugPrint('message is : ${message.data}');
      _showLocalNotification(message);
    });
  }

  /// Handle when user taps a notification while app is in background (not terminated)
  void _listenNotificationTaps() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('Notification tap (background): ${message.messageId}');
      _handleNotificationTap(message);
    });
  }

  /// Handle the case where app was terminated and opened via notification tap
  Future<void> _handleInitialMessage() async {
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      log(
        'App opened from terminated via notification: ${initialMessage.messageId}',
      );
      _handleNotificationTap(initialMessage);
    }
  }

  /// Display a notification using flutter_local_notifications
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: message.data.toString(),
    );
  }

  /// Handle tap on a local notification (foreground notifications via flutter_local_notifications)
  void _onLocalNotificationTap(NotificationResponse details) {
    log('Local notification tapped: ${details.payload}');
    MainRoutes.router.goNamed(MainRoutes.demoName);
  }

  /// Handle navigation when user taps a FCM notification (background/terminated).
  /// Uses GoRouter directly (no BuildContext needed).
  ///
  /// Replace this with route logic specific to your app — e.g. switch on
  /// `message.data['type']` to land on the right screen for each notification kind.
  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('Notification data: ${message.data}');
    MainRoutes.router.goNamed(MainRoutes.demoName);
  }

  // ── Topic Subscription ──

  /// Subscribe to a list of topics after login based on user attributes
  /// (e.g., ward, area, role). Call from AuthCubit after successful login.
  Future<void> subscribeToTopics(String topic) async {
    await _messaging.subscribeToTopic(topic);
    log('Subscribed to topic: $topic');
  }

  /// Unsubscribe from all given topics. Call on logout.
  Future<void> unsubscribeFromTopics(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    log('Unsubscribed from topic: $topic');
  }
}
