// features/auth/presentation/cubit/auth_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:collab_task/core/error/failures.dart';
import 'package:collab_task/features/auth/domain/entities/login_entity.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  /// App launched, no auth attempt yet
  const factory AuthState.initial() = _AuthInitial;

  /// Login/register in progress
  const factory AuthState.loading() = _AuthLoading;

  /// User successfully authenticated
  const factory AuthState.authenticated(UserEntity user) = _AuthAuthenticated;

  /// User logged out or session expired
  const factory AuthState.unauthenticated() = _AuthUnauthenticated;

  /// Auth operation failed. UI resolves via `localizedFailureMessage(context, failure)`.
  const factory AuthState.error(Failure failure) = _AuthError;
}
