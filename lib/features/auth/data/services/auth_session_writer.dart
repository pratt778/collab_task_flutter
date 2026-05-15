import 'package:injectable/injectable.dart';
import 'package:collab_task/core/helper/secure_storage_helper.dart';
import 'package:collab_task/features/auth/domain/entities/login_entity.dart';

@lazySingleton
class AuthSessionWriter {
  AuthSessionWriter({required this.secureStorage});

  final SecureStorageHelper secureStorage;

  Future<void> persistLogin({
    required UserEntity user,
  }) async {
    secureStorage.saveUserCode(user.id);
    if (user.displayName != null) {
      secureStorage.saveUserName(user.displayName!);
    }
    // Supabase handles the token internally via supabase_flutter, 
    // but we can save it if needed for external API calls.
    // secureStorage.saveToken(token);
  }

  void clearSession() {
    secureStorage.logOut();
  }
}
