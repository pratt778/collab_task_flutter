import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:collab_task/features/auth/data/services/auth_session_writer.dart';
import 'package:collab_task/features/auth/domain/entities/login_entity.dart';
import 'package:collab_task/features/auth/domain/usecases/login_usecase.dart';
import 'package:collab_task/features/auth/domain/usecases/logout_usecase.dart';
import 'package:collab_task/features/auth/domain/usecases/register_usecase.dart';
import 'package:collab_task/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:collab_task/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:collab_task/features/auth/domain/usecases/update_password_usecase.dart';
import 'package:collab_task/features/auth/presentation/cubit/auth_state.dart';

@lazySingleton
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.resetPasswordUseCase,
    required this.verifyOtpUseCase,
    required this.updatePasswordUseCase,
    required this.sessionWriter,
  }) : super(const AuthState.initial()) {
    checkLoginStatus();
  }

  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final UpdatePasswordUseCase updatePasswordUseCase;
  final AuthSessionWriter sessionWriter;

  bool checkLoginStatus() {
    final session = sb.Supabase.instance.client.auth.currentSession;
    if (session != null) {
      emit(AuthState.authenticated(UserEntity(
        id: session.user.id,
        email: session.user.email ?? '',
        displayName: session.user.userMetadata?['display_name'] as String?,
      )));
      return true;
    }
    emit(const AuthState.unauthenticated());
    return false;
  }

  Future<void> login({required String email, required String password}) async {
    emit(const AuthState.loading());
    final result = await loginUseCase.call(email: email, password: password);
    result.fold((failure) => emit(AuthState.error(failure)), (data) async {
      await sessionWriter.persistLogin(user: data);
      emit(AuthState.authenticated(data));
    });
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(const AuthState.loading());
    final result = await registerUseCase.call(
      email: email,
      password: password,
      name: name,
    );
    result.fold((failure) => emit(AuthState.error(failure)), (data) async {
      await sessionWriter.persistLogin(user: data);
      emit(AuthState.authenticated(data));
    });
  }

  Future<void> logout() async {
    emit(const AuthState.loading());
    final result = await logoutUseCase.call();
    result.fold((failure) => emit(AuthState.error(failure)), (_) {
      sessionWriter.clearSession();
      emit(const AuthState.unauthenticated());
    });
  }

  Future<void> resetPassword(String email) async {
    emit(const AuthState.loading());
    final result = await resetPasswordUseCase.call(email);
    result.fold(
      (failure) => emit(AuthState.error(failure)),
      (_) => emit(const AuthState.unauthenticated()), // Reset email sent
    );
  }

  Future<void> verifyOtp({required String email, required String token}) async {
    emit(const AuthState.loading());
    final result = await verifyOtpUseCase.call(email: email, token: token);
    result.fold((failure) => emit(AuthState.error(failure)), (data) async {
      await sessionWriter.persistLogin(user: data);
      emit(AuthState.authenticated(data));
    });
  }

  Future<void> updatePassword(String newPassword) async {
    emit(const AuthState.loading());
    final result = await updatePasswordUseCase.call(newPassword);
    result.fold(
      (failure) => emit(AuthState.error(failure)),
      (_) => emit(const AuthState.unauthenticated()), // Password updated, prompt login or keep auth
    );
  }

  void forceLogout() {
    sessionWriter.clearSession();
    emit(const AuthState.unauthenticated());
  }
}
