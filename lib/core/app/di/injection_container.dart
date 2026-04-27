import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_clean_starter/core/config/constants/api_constant.dart';
import 'package:flutter_clean_starter/core/helper/secure_storage_helper.dart';
import 'package:flutter_clean_starter/core/network/api_helper.dart';
import 'package:flutter_clean_starter/core/network/auth_interceptor.dart';
import 'package:flutter_clean_starter/core/network/retry_interceptor.dart';
import 'package:flutter_clean_starter/core/services/fcm_notification_service.dart';
import 'package:flutter_clean_starter/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_clean_starter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_clean_starter/features/auth/data/services/auth_session_writer.dart';
import 'package:flutter_clean_starter/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_clean_starter/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_clean_starter/features/auth/domain/usecases/logout_usecase.dart';
import 'package:flutter_clean_starter/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter_clean_starter/features/demo/data/datasources/demo_datasource.dart';
import 'package:flutter_clean_starter/features/demo/data/repositories/demo_repo_impl.dart';
import 'package:flutter_clean_starter/features/demo/domain/repositories/demo_repository.dart';
import 'package:flutter_clean_starter/features/demo/domain/usecases/get_demos_usecase.dart';
import 'package:flutter_clean_starter/features/demo/presentation/cubit/demo_cubit.dart';
import 'package:flutter_clean_starter/features/locale/presentation/cubit/locale_cubit.dart';
import 'package:flutter_clean_starter/features/shared/cubits/network_cubits.dart';
import 'package:flutter_clean_starter/features/theme/presentation/cubit/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> setupInjection() async {
  await _registerExternal();
  _registerNetwork();
  _registerFeatures();
  _registerAuthInterceptor();
  _registerRetryInterceptor();
  await sl<ApiHelper>().init();
}

Future<void> _registerExternal() async {
  sl.registerLazySingleton<SecureStorageHelper>(SecureStorageHelper.new);
  sl.registerLazySingleton<FcmNotificationService>(FcmNotificationService.new);
  sl.registerLazySingleton<AuthSessionWriter>(
    () => AuthSessionWriter(secureStorage: sl(), fcm: sl()),
  );
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

void _registerNetwork() {
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 20),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(ApiLoggerInterceptor());

    return dio;
  });

  sl.registerLazySingleton<ApiHelper>(() => ApiHelper(dio: sl<Dio>()));
}

void _registerFeatures() {
  // Datasources
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(apiHelper: sl<ApiHelper>()),
  );
  sl.registerLazySingleton<DemoRemoteDatasource>(
    () => DemoRemoteDatasourceImpl(apiHelper: sl<ApiHelper>()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDatasource: sl()),
  );
  sl.registerLazySingleton<DemoRepository>(
    () => DemoRepositoryImpl(remoteDatasource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetDemosUseCase(sl()));

  // Cubits
  sl.registerLazySingleton(
    () => AuthCubit(
      loginUseCase: sl(),
      logoutUseCase: sl(),
      sessionWriter: sl(),
    ),
  );
  sl.registerFactory(() => DemoCubit(getDemosUseCase: sl()));
  sl.registerFactory(() => ThemeCubit(sl<SecureStorageHelper>()));
  sl.registerFactory(() => LocaleCubit(sl<SecureStorageHelper>()));
  sl.registerLazySingleton<NetworkCubit>(NetworkCubit.new);
}
