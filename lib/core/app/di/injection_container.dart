import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:collab_task/core/app/di/injection_container.config.dart';
import 'package:collab_task/core/network/api_helper.dart';
import 'package:collab_task/core/network/auth_interceptor.dart';
import 'package:collab_task/core/network/retry_interceptor.dart';
import 'package:collab_task/features/auth/presentation/cubit/auth_cubit.dart';

final sl = GetIt.instance;

/// Wired by `injectable_generator`. Registers every class annotated with
/// `@injectable` / `@lazySingleton` plus everything provided by `@module`s
/// (see `register_module.dart`). Re-run `dart run build_runner build` after
/// adding or changing annotations.
@InjectableInit()
Future<void> configureDependencies() async => sl.init();

/// App-level DI bootstrap. Call once from `main_common.dart` before `runApp`.
///
/// Two pieces beyond `configureDependencies` live here because they need
/// post-registration runtime work that injectable can't express:
///
///   1. **Interceptors** — `AuthInterceptor` needs an `AuthCubit` reference
///      that's only available after `configureDependencies` has registered
///      everything. `RetryInterceptor` is added last so it sees every other
///      interceptor's outcome.
///   2. **`ApiHelper.init()`** — async runtime setup (chucker wiring) that
///      `@module` providers can't await.
Future<void> setupInjection() async {
  await configureDependencies();
  _registerAuthInterceptor();
  _registerRetryInterceptor();
  await sl<ApiHelper>().init();
}

void _registerAuthInterceptor() {
  sl<Dio>().interceptors.add(
    AuthInterceptor(
      onUnauthorized: () {
        debugPrint('inside onUnauthorized');
        sl<AuthCubit>().forceLogout();
        debugPrint('logout done onUnauthorized');
      },
    ),
  );
}

void _registerRetryInterceptor() {
  sl<Dio>().interceptors.add(RetryInterceptor(sl<Dio>()));
}
