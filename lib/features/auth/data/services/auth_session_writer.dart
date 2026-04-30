import 'package:injectable/injectable.dart';
import 'package:collab_task/core/helper/secure_storage_helper.dart';
import 'package:collab_task/features/auth/domain/entities/login_entity.dart';

/// Owns the post-login persistence and clear-session policy. Inject this into
/// `AuthCubit` instead of letting the cubit touch storage directly — keeps
/// the cubit testable without mocking `SecureStorageHelper` calls.
///
/// Add per-project side effects (FCM topic subscribe, analytics user-id, etc.)
/// here as you wire them. Example:
///
/// ```dart
/// AuthSessionWriter({
///   required this.secureStorage,
///   required this.fcm,            // add this field
/// });
///
/// Future<void> persistLogin(...) async {
///   await fcm.subscribeToTopics(user.id.toString());
///   secureStorage.saveUserCode(...);
///   ...
/// }
/// ```
@lazySingleton
class AuthSessionWriter {
  AuthSessionWriter({required this.secureStorage});

  final SecureStorageHelper secureStorage;

  Future<void> persistLogin({
    required LoginResponseEntity user,
    required String phoneNumber,
    required String accountInfo,
  }) async {
    secureStorage.saveUserCode(user.id.toString());
    secureStorage.saveUserName(user.nameEn);
    secureStorage.saveToken(user.token);
    secureStorage.saveAccountInfo(accountInfo);
    secureStorage.savePhoneNumber(phoneNumber);
  }

  void clearSession() {
    secureStorage.logOut();
  }
}
