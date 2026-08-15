import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:collab_task/core/error/exceptions.dart';
import 'package:collab_task/core/utils/safe_request_mapper.dart';
import 'package:collab_task/features/profile/data/models/profile_model.dart';

abstract class ProfileRemoteDatasource {
  Future<ProfileModel> getMyProfile();
  Future<ProfileModel> updateProfile({
    String? displayName,
    String? phoneNumber,
    String? avatarUrl,
  });
}

@LazySingleton(as: ProfileRemoteDatasource)
class ProfileRemoteDatasourceImpl implements ProfileRemoteDatasource {
  sb.SupabaseClient get _client => sb.Supabase.instance.client;

  @override
  Future<ProfileModel> getMyProfile() {
    return SafeRequest.call(() async {
      final user = _client.auth.currentUser;
      if (user == null) {
        throw const AuthException(message: 'No active user session found');
      }

      final response = await _client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (response != null) {
        return ProfileModel.fromJson(response);
      }

      // Fallback from auth session metadata if profile row isn't yet present
      return ProfileModel(
        id: user.id,
        email: user.email ?? '',
        displayName: user.userMetadata?['display_name'] as String?,
        avatarUrl: user.userMetadata?['avatar_url'] as String?,
        phoneNumber: user.phone,
        createdAt: DateTime.tryParse(user.createdAt),
        updatedAt: user.lastSignInAt != null
            ? DateTime.tryParse(user.lastSignInAt!)
            : null,
      );
    });
  }

  @override
  Future<ProfileModel> updateProfile({
    String? displayName,
    String? phoneNumber,
    String? avatarUrl,
  }) {
    return SafeRequest.call(() async {
      final user = _client.auth.currentUser;
      if (user == null) {
        throw const AuthException(message: 'No active user session found');
      }

      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };
      if (displayName != null) {
        updates['display_name'] = displayName;
      }
      if (phoneNumber != null) {
        updates['phone_number'] = phoneNumber;
      }
      if (avatarUrl != null) {
        updates['avatar_url'] = avatarUrl;
      }

      final response = await _client
          .from('profiles')
          .update(updates)
          .eq('id', user.id)
          .select()
          .single();

      if (displayName != null) {
        await _client.auth.updateUser(
          sb.UserAttributes(data: {'display_name': displayName}),
        );
      }

      return ProfileModel.fromJson(response);
    });
  }
}
