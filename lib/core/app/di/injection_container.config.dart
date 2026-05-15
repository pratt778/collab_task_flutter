// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:collab_task/core/app/di/register_module.dart' as _i759;
import 'package:collab_task/core/helper/secure_storage_helper.dart' as _i445;
import 'package:collab_task/core/network/api_helper.dart' as _i29;
import 'package:collab_task/core/network/websocket_service.dart' as _i196;
import 'package:collab_task/features/auth/data/datasources/auth_remote_datasource.dart'
    as _i867;
import 'package:collab_task/features/auth/data/repositories/auth_repository_impl.dart'
    as _i227;
import 'package:collab_task/features/auth/data/services/auth_session_writer.dart'
    as _i1007;
import 'package:collab_task/features/auth/domain/repositories/auth_repository.dart'
    as _i835;
import 'package:collab_task/features/auth/domain/usecases/login_usecase.dart'
    as _i55;
import 'package:collab_task/features/auth/domain/usecases/logout_usecase.dart'
    as _i330;
import 'package:collab_task/features/auth/domain/usecases/register_usecase.dart'
    as _i231;
import 'package:collab_task/features/auth/domain/usecases/reset_password_usecase.dart'
    as _i202;
import 'package:collab_task/features/auth/domain/usecases/update_password_usecase.dart'
    as _i825;
import 'package:collab_task/features/auth/domain/usecases/verify_otp_usecase.dart'
    as _i93;
import 'package:collab_task/features/auth/presentation/cubit/auth_cubit.dart'
    as _i981;
import 'package:collab_task/features/locale/presentation/cubit/locale_cubit.dart'
    as _i881;
import 'package:collab_task/features/shared/cubits/network_cubits.dart'
    as _i889;
import 'package:collab_task/features/tasks/data/datasources/task_datasource.dart'
    as _i423;
import 'package:collab_task/features/tasks/data/repositories/task_repository_impl.dart'
    as _i4;
import 'package:collab_task/features/tasks/domain/repositories/task_repository.dart'
    as _i123;
import 'package:collab_task/features/tasks/domain/usecases/create_task_usecase.dart'
    as _i647;
import 'package:collab_task/features/tasks/domain/usecases/delete_task_usecase.dart'
    as _i532;
import 'package:collab_task/features/tasks/domain/usecases/get_task_detail_usecase.dart'
    as _i121;
import 'package:collab_task/features/tasks/domain/usecases/get_tasks_usecase.dart'
    as _i130;
import 'package:collab_task/features/tasks/domain/usecases/update_task_usecase.dart'
    as _i522;
import 'package:collab_task/features/tasks/presentation/cubit/task_detail_cubit.dart'
    as _i223;
import 'package:collab_task/features/tasks/presentation/cubit/task_list_cubit.dart'
    as _i885;
import 'package:collab_task/features/theme/presentation/cubit/theme_cubit.dart'
    as _i544;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio());
    gh.lazySingleton<_i196.WebSocketService>(
      () => registerModule.webSocketService(),
    );
    gh.lazySingleton<_i445.SecureStorageHelper>(
      () => _i445.SecureStorageHelper(),
    );
    gh.lazySingleton<_i889.NetworkCubit>(() => _i889.NetworkCubit());
    gh.factory<_i881.LocaleCubit>(
      () => _i881.LocaleCubit(gh<_i445.SecureStorageHelper>()),
    );
    gh.factory<_i544.ThemeCubit>(
      () => _i544.ThemeCubit(gh<_i445.SecureStorageHelper>()),
    );
    gh.lazySingleton<_i1007.AuthSessionWriter>(
      () => _i1007.AuthSessionWriter(
        secureStorage: gh<_i445.SecureStorageHelper>(),
      ),
    );
    gh.lazySingleton<_i867.AuthRemoteDatasource>(
      () => _i867.AuthRemoteDatasourceImpl(),
    );
    gh.lazySingleton<_i29.ApiHelper>(
      () => registerModule.apiHelper(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i423.TaskDatasource>(
      () => _i423.TaskDatasourceImpl(gh<_i29.ApiHelper>()),
    );
    gh.lazySingleton<_i835.AuthRepository>(
      () => _i227.AuthRepositoryImpl(
        remoteDatasource: gh<_i867.AuthRemoteDatasource>(),
      ),
    );
    gh.lazySingleton<_i123.TaskRepository>(
      () => _i4.TaskRepositoryImpl(gh<_i423.TaskDatasource>()),
    );
    gh.lazySingleton<_i55.LoginUseCase>(
      () => _i55.LoginUseCase(gh<_i835.AuthRepository>()),
    );
    gh.lazySingleton<_i330.LogoutUseCase>(
      () => _i330.LogoutUseCase(gh<_i835.AuthRepository>()),
    );
    gh.lazySingleton<_i231.RegisterUseCase>(
      () => _i231.RegisterUseCase(gh<_i835.AuthRepository>()),
    );
    gh.lazySingleton<_i202.ResetPasswordUseCase>(
      () => _i202.ResetPasswordUseCase(gh<_i835.AuthRepository>()),
    );
    gh.lazySingleton<_i825.UpdatePasswordUseCase>(
      () => _i825.UpdatePasswordUseCase(gh<_i835.AuthRepository>()),
    );
    gh.lazySingleton<_i93.VerifyOtpUseCase>(
      () => _i93.VerifyOtpUseCase(gh<_i835.AuthRepository>()),
    );
    gh.lazySingleton<_i647.CreateTaskUseCase>(
      () => _i647.CreateTaskUseCase(gh<_i123.TaskRepository>()),
    );
    gh.lazySingleton<_i532.DeleteTaskUseCase>(
      () => _i532.DeleteTaskUseCase(gh<_i123.TaskRepository>()),
    );
    gh.lazySingleton<_i121.GetTaskDetailUseCase>(
      () => _i121.GetTaskDetailUseCase(gh<_i123.TaskRepository>()),
    );
    gh.lazySingleton<_i130.GetTasksUseCase>(
      () => _i130.GetTasksUseCase(gh<_i123.TaskRepository>()),
    );
    gh.lazySingleton<_i522.UpdateTaskUseCase>(
      () => _i522.UpdateTaskUseCase(gh<_i123.TaskRepository>()),
    );
    gh.factory<_i223.TaskDetailCubit>(
      () => _i223.TaskDetailCubit(
        gh<_i121.GetTaskDetailUseCase>(),
        gh<_i522.UpdateTaskUseCase>(),
        gh<_i532.DeleteTaskUseCase>(),
      ),
    );
    gh.lazySingleton<_i981.AuthCubit>(
      () => _i981.AuthCubit(
        loginUseCase: gh<_i55.LoginUseCase>(),
        registerUseCase: gh<_i231.RegisterUseCase>(),
        logoutUseCase: gh<_i330.LogoutUseCase>(),
        resetPasswordUseCase: gh<_i202.ResetPasswordUseCase>(),
        verifyOtpUseCase: gh<_i93.VerifyOtpUseCase>(),
        updatePasswordUseCase: gh<_i825.UpdatePasswordUseCase>(),
        sessionWriter: gh<_i1007.AuthSessionWriter>(),
      ),
    );
    gh.factory<_i885.TaskListCubit>(
      () => _i885.TaskListCubit(
        gh<_i130.GetTasksUseCase>(),
        gh<_i647.CreateTaskUseCase>(),
        gh<_i196.WebSocketService>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i759.RegisterModule {}
