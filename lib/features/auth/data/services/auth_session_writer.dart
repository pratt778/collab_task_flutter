import 'package:flutter_clean_starter/core/helper/secure_storage_helper.dart';
import 'package:flutter_clean_starter/core/services/fcm_notification_service.dart';
import 'package:flutter_clean_starter/features/auth/domain/entities/login_entity.dart';

class AuthSessionWriter {
  AuthSessionWriter({required this.secureStorage, required this.fcm});

  final SecureStorageHelper secureStorage;
  final FcmNotificationService fcm;

  Future<void> persistLogin({
    required LoginResponseEntity user,
    required String phoneNumber,
    required String accountInfo,
  }) async {
    fcm.subscribeToTopics(user.id.toString());
    secureStorage.saveUserCode(user.id.toString());
    secureStorage.saveUserName(user.nameEn);
    secureStorage.saveToken(user.token);
    secureStorage.saveAccountInfo(accountInfo);
    secureStorage.savePhoneNumber(phoneNumber);
  }

  void clearSession() {
    secureStorage.logOut();
    fcm.unsubscribeFromTopics('1');
  }
}
