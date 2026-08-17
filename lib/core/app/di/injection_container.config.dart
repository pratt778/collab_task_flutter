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
import 'package:collab_task/features/chat/data/datasources/chat_remote_datasource.dart'
    as _i824;
import 'package:collab_task/features/chat/data/repositories/chat_repository_impl.dart'
    as _i357;
import 'package:collab_task/features/chat/domain/repositories/chat_repository.dart'
    as _i7;
import 'package:collab_task/features/chat/domain/usecases/get_task_messages_usecase.dart'
    as _i40;
import 'package:collab_task/features/chat/domain/usecases/send_task_message_usecase.dart'
    as _i867;
import 'package:collab_task/features/chat/presentation/cubit/task_chat_cubit.dart'
    as _i719;
import 'package:collab_task/features/locale/presentation/cubit/locale_cubit.dart'
    as _i881;
import 'package:collab_task/features/profile/data/datasources/profile_remote_datasource.dart'
    as _i794;
import 'package:collab_task/features/profile/data/repositories/profile_repository_impl.dart'
    as _i213;
import 'package:collab_task/features/profile/domain/repositories/profile_repository.dart'
    as _i413;
import 'package:collab_task/features/profile/domain/usecases/get_profile_usecase.dart'
    as _i691;
import 'package:collab_task/features/profile/domain/usecases/update_profile_usecase.dart'
    as _i980;
import 'package:collab_task/features/profile/presentation/cubit/profile_cubit.dart'
    as _i863;
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
import 'package:collab_task/features/workspaces/data/datasources/workspace_remote_datasource.dart'
    as _i625;
import 'package:collab_task/features/workspaces/data/repositories/workspace_repository_impl.dart'
    as _i786;
import 'package:collab_task/features/workspaces/domain/repositories/workspace_repository.dart'
    as _i400;
import 'package:collab_task/features/workspaces/domain/usecases/add_workspace_member_usecase.dart'
    as _i15;
import 'package:collab_task/features/workspaces/domain/usecases/create_workspace_usecase.dart'
    as _i382;
import 'package:collab_task/features/workspaces/domain/usecases/get_my_workspaces_usecase.dart'
    as _i45;
import 'package:collab_task/features/workspaces/presentation/cubit/workspace_cubit.dart'
    as _i349;
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
    gh.lazySingleton<_i423.TaskDatasource>(() => _i423.TaskDatasourceImpl());
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
    gh.lazySingleton<_i123.TaskRepository>(
      () => _i4.TaskRepositoryImpl(gh<_i423.TaskDatasource>()),
    );
    gh.lazySingleton<_i867.AuthRemoteDatasource>(
      () => _i867.AuthRemoteDatasourceImpl(),
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
    gh.lazySingleton<_i29.ApiHelper>(
      () => registerModule.apiHelper(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i824.ChatRemoteDatasource>(
      () => _i824.ChatRemoteDatasourceImpl(),
    );
    gh.lazySingleton<_i625.WorkspaceRemoteDatasource>(
      () => _i625.WorkspaceRemoteDatasourceImpl(),
    );
    gh.lazySingleton<_i794.ProfileRemoteDatasource>(
      () => _i794.ProfileRemoteDatasourceImpl(),
    );
    gh.factory<_i223.TaskDetailCubit>(
      () => _i223.TaskDetailCubit(
        gh<_i121.GetTaskDetailUseCase>(),
        gh<_i522.UpdateTaskUseCase>(),
        gh<_i532.DeleteTaskUseCase>(),
      ),
    );
    gh.lazySingleton<_i835.AuthRepository>(
      () => _i227.AuthRepositoryImpl(
        remoteDatasource: gh<_i867.AuthRemoteDatasource>(),
      ),
    );
    gh.factory<_i885.TaskListCubit>(
      () => _i885.TaskListCubit(
        gh<_i130.GetTasksUseCase>(),
        gh<_i647.CreateTaskUseCase>(),
        gh<_i522.UpdateTaskUseCase>(),
        gh<_i532.DeleteTaskUseCase>(),
      ),
    );
    gh.lazySingleton<_i7.ChatRepository>(
      () => _i357.ChatRepositoryImpl(
        remoteDatasource: gh<_i824.ChatRemoteDatasource>(),
      ),
    );
    gh.lazySingleton<_i40.GetTaskMessagesUseCase>(
      () => _i40.GetTaskMessagesUseCase(gh<_i7.ChatRepository>()),
    );
    gh.lazySingleton<_i867.SendTaskMessageUseCase>(
      () => _i867.SendTaskMessageUseCase(gh<_i7.ChatRepository>()),
    );
    gh.lazySingleton<_i413.ProfileRepository>(
      () => _i213.ProfileRepositoryImpl(
        remoteDatasource: gh<_i794.ProfileRemoteDatasource>(),
      ),
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
    gh.lazySingleton<_i400.WorkspaceRepository>(
      () => _i786.WorkspaceRepositoryImpl(
        remoteDatasource: gh<_i625.WorkspaceRemoteDatasource>(),
      ),
    );
    gh.lazySingleton<_i691.GetProfileUseCase>(
      () => _i691.GetProfileUseCase(gh<_i413.ProfileRepository>()),
    );
    gh.lazySingleton<_i980.UpdateProfileUseCase>(
      () => _i980.UpdateProfileUseCase(gh<_i413.ProfileRepository>()),
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
    gh.factory<_i719.TaskChatCubit>(
      () => _i719.TaskChatCubit(
        gh<_i40.GetTaskMessagesUseCase>(),
        gh<_i867.SendTaskMessageUseCase>(),
      ),
    );
    gh.lazySingleton<_i15.AddWorkspaceMemberUseCase>(
      () => _i15.AddWorkspaceMemberUseCase(gh<_i400.WorkspaceRepository>()),
    );
    gh.lazySingleton<_i382.CreateWorkspaceUseCase>(
      () => _i382.CreateWorkspaceUseCase(gh<_i400.WorkspaceRepository>()),
    );
    gh.lazySingleton<_i45.GetMyWorkspacesUseCase>(
      () => _i45.GetMyWorkspacesUseCase(gh<_i400.WorkspaceRepository>()),
    );
    gh.lazySingleton<_i349.WorkspaceCubit>(
      () => _i349.WorkspaceCubit(
        getMyWorkspacesUseCase: gh<_i45.GetMyWorkspacesUseCase>(),
        createWorkspaceUseCase: gh<_i382.CreateWorkspaceUseCase>(),
        addWorkspaceMemberUseCase: gh<_i15.AddWorkspaceMemberUseCase>(),
        workspaceRepository: gh<_i400.WorkspaceRepository>(),
        authRepository: gh<_i835.AuthRepository>(),
        secureStorage: gh<_i445.SecureStorageHelper>(),
      ),
    );
    gh.factory<_i863.ProfileCubit>(
      () => _i863.ProfileCubit(
        gh<_i691.GetProfileUseCase>(),
        gh<_i980.UpdateProfileUseCase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i759.RegisterModule {}
