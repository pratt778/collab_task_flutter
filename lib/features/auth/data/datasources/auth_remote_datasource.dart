import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:collab_task/core/error/exceptions.dart';
import 'package:collab_task/core/utils/safe_request_mapper.dart';
import 'package:collab_task/features/auth/data/models/login_response_model.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  });
  Future<void> logout();
  Future<void> resetPassword(String email);
  Future<UserModel> verifyOtp({
    required String email,
    required String token,
    required sb.OtpType type,
  });
  Future<void> updatePassword(String newPassword);
  Future<List<UserModel>> getAllUsers();
}

@LazySingleton(as: AuthRemoteDatasource)
class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  sb.SupabaseClient get _client => sb.Supabase.instance.client;

  @override
  Future<List<UserModel>> getAllUsers() {
    return SafeRequest.call(() async {
      final response = await _client.from('profiles').select();
      return (response as List).map((e) => UserModel.fromJson(e)).toList();
    });
  }

  @override
  Future<UserModel> login({required String email, required String password}) {
    return SafeRequest.call(() async {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw const AuthException(message: 'Login failed: User is null');
      }
      return UserModel.fromSupabase(response.user!);
    });
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  }) {
    return SafeRequest.call(() async {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'display_name': name},
      );
      if (response.user == null) {
        throw const AuthException(message: 'Registration failed: User is null');
      }
      return UserModel.fromSupabase(response.user!);
    });
  }

  @override
  Future<void> logout() {
    return SafeRequest.call(() async {
      await _client.auth.signOut();
    });
  }

  @override
  Future<void> resetPassword(String email) {
    return SafeRequest.call(() async {
      await _client.auth.resetPasswordForEmail(email);
    });
  }

  @override
  Future<UserModel> verifyOtp({
    required String email,
    required String token,
    required sb.OtpType type,
  }) {
    return SafeRequest.call(() async {
      final response = await _client.auth.verifyOTP(
        email: email,
        token: token,
        type: type,
      );
      if (response.user == null) {
        throw const AuthException(message: 'Verification failed: User is null');
      }
      return UserModel.fromSupabase(response.user!);
    });
  }

  @override
  Future<void> updatePassword(String newPassword) {
    return SafeRequest.call(() async {
      await _client.auth.updateUser(
        sb.UserAttributes(password: newPassword),
      );
    });
  }
}
