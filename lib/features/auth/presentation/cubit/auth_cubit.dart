import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:collab_task/core/helper/secure_storage_helper.dart';
import 'package:collab_task/features/auth/data/services/auth_session_writer.dart';
import 'package:collab_task/features/auth/domain/usecases/login_usecase.dart';
import 'package:collab_task/features/auth/domain/usecases/logout_usecase.dart';
import 'package:collab_task/features/auth/presentation/cubit/auth_state.dart';

@lazySingleton
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.sessionWriter,
  }) : super(const AuthState.initial()) {
    checkLoginStatus();
  }

  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final AuthSessionWriter sessionWriter;

  bool checkLoginStatus() {
    final isLoggedIn = SecureStorageHelper().isUserLoggedIn();
    return isLoggedIn;
  }

  Future<void> login({
    required String phoneNumber,
    required String customerNo,
    required String organizationCode,
  }) async {
    emit(const AuthState.loading());

    final result = await loginUseCase.call(
      phoneNumber: phoneNumber,
      customerNo: customerNo,
      organizationCode: organizationCode,
    );

    await result.fold(
      (failure) async => emit(AuthState.error(failure)),
      (data) async {
        debugPrint('User entity: ${data.id}');
        await sessionWriter.persistLogin(
          user: data,
          phoneNumber: phoneNumber,
          accountInfo: '$customerNo@$organizationCode',
        );
        emit(AuthState.authenticated(data));
      },
    );
  }

  Future<void> logout() async {
    emit(const AuthState.loading());
    final result = await logoutUseCase.call();
    result.fold((failure) => emit(AuthState.error(failure)), (_) {
      sessionWriter.clearSession();
      emit(const AuthState.unauthenticated());
    });
  }

  void forceLogout() {
    sessionWriter.clearSession();
    emit(const AuthState.unauthenticated());
  }
}
