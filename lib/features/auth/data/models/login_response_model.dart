import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:collab_task/features/auth/domain/entities/login_entity.dart';

class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final String? avatarUrl;

  const UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.avatarUrl,
  });

  factory UserModel.fromSupabase(User user) {
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      displayName: user.userMetadata?['display_name'] as String?,
      avatarUrl: user.userMetadata?['avatar_url'] as String?,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String? ?? '',
      displayName: json['display_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      displayName: displayName,
      avatarUrl: avatarUrl,
    );
  }
}
