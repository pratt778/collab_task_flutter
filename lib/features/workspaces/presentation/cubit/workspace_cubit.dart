// import 'package:flutter/foundation.dart';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:collab_task/core/error/failures.dart';
import 'package:collab_task/features/workspaces/domain/entities/workspace_entity.dart';
import 'package:collab_task/core/helper/secure_storage_helper.dart';
import 'package:collab_task/features/workspaces/domain/usecases/get_my_workspaces_usecase.dart';
import 'package:collab_task/features/workspaces/domain/usecases/create_workspace_usecase.dart';
import 'package:collab_task/features/workspaces/domain/usecases/add_workspace_member_usecase.dart';
import 'package:collab_task/features/workspaces/domain/repositories/workspace_repository.dart';
import 'package:collab_task/features/auth/domain/entities/login_entity.dart';
import 'package:collab_task/features/auth/domain/repositories/auth_repository.dart';

part 'workspace_cubit.freezed.dart';

@freezed
class WorkspaceState with _$WorkspaceState {
  const factory WorkspaceState.initial() = _Initial;
  const factory WorkspaceState.loading() = _Loading;
  const factory WorkspaceState.loaded({
    required List<WorkspaceEntity> workspaces,
    WorkspaceEntity? selectedWorkspace,
    @Default([]) List<UserEntity> allUsers,
    @Default([]) List<Map<String, dynamic>> currentMembers,
  }) = _Loaded;
  const factory WorkspaceState.error(Failure failure) = _Error;
}

@lazySingleton
class WorkspaceCubit extends Cubit<WorkspaceState> {
  final GetMyWorkspacesUseCase getMyWorkspacesUseCase;
  final CreateWorkspaceUseCase createWorkspaceUseCase;
  final AddWorkspaceMemberUseCase addWorkspaceMemberUseCase;
  final WorkspaceRepository workspaceRepository;
  final AuthRepository authRepository;
  final SecureStorageHelper secureStorage;

  WorkspaceCubit({
    required this.getMyWorkspacesUseCase,
    required this.createWorkspaceUseCase,
    required this.addWorkspaceMemberUseCase,
    required this.workspaceRepository,
    required this.authRepository,
    required this.secureStorage,
  }) : super(const WorkspaceState.initial());

  Future<void> loadWorkspaces() async {
    // debugPrint('⏳ WorkspaceCubit: Starting loadWorkspaces()...');
    final currentSelectedId = state.maybeWhen(
      loaded: (_, selected, _, _) => selected?.id,
      orElse: () => null,
    );
    emit(const WorkspaceState.loading());
    final result = await getMyWorkspacesUseCase.call();

    result.fold(
      (failure) {
        // debugPrint('❌ WorkspaceCubit: loadWorkspaces failed: $failure');
        emit(WorkspaceState.error(failure));
      },
      (workspaces) async {
        log('✅ WorkspaceCubit: Found ${workspaces.length} workspaces');

        // Fetch all users for discovery
        final usersResult = await authRepository.getAllUsers();
        final allUsers = usersResult.fold(
          (failure) {
            log('❌ WorkspaceCubit: Failed to fetch users: $failure');
            return <UserEntity>[];
          },
          (users) {
            log(
              '👥 WorkspaceCubit: Fetched ${users.length} total users for discovery',
            );
            return users;
          },
        );

        if (workspaces.isEmpty) {
          log(
            'ℹ️ WorkspaceCubit: No workspaces found, auto-creating default...',
          );
          await createDefaultWorkspace();
        } else {
          // If we were already in a workspace, try to stay in it
          final workspaceToSelect = workspaces.firstWhere(
            (w) => w.id == currentSelectedId,
            orElse: () => workspaces.first,
          );

          log(
            '✅ WorkspaceCubit: Selecting workspace: ${workspaceToSelect.name}',
          );

          // Fetch members for the selected workspace
          final membersResult = await workspaceRepository.getWorkspaceMembers(
            workspaceToSelect.id,
          );
          final members = membersResult.fold(
            (_) => <Map<String, dynamic>>[],
            (m) => m,
          );
          log(
            '👥 WorkspaceCubit: Workspace ${workspaceToSelect.name} has ${members.length} members',
          );

          emit(
            WorkspaceState.loaded(
              workspaces: workspaces,
              selectedWorkspace: workspaceToSelect,
              allUsers: allUsers,
              currentMembers: members,
            ),
          );
        }
      },
    );
  }

  Future<void> createWorkspace({
    required String name,
    String? description,
  }) async {
    // debugPrint('⏳ WorkspaceCubit: Creating custom workspace: $name');
    final result = await createWorkspaceUseCase.call(
      name: name,
      description: description,
    );

    result.fold((failure) => emit(WorkspaceState.error(failure)), (
      newWorkspace,
    ) async {
      final membersResult = await workspaceRepository.getWorkspaceMembers(
        newWorkspace.id,
      );
      final members = membersResult.fold(
        (_) => <Map<String, dynamic>>[],
        (m) => m,
      );

      state.maybeWhen(
        loaded: (workspaces, _, allUsers, _) {
          final updatedList = List<WorkspaceEntity>.from(workspaces)
            ..add(newWorkspace);
          emit(
            WorkspaceState.loaded(
              workspaces: updatedList,
              selectedWorkspace: newWorkspace,
              allUsers: allUsers,
              currentMembers: members,
            ),
          );
        },
        orElse: () {
          emit(
            WorkspaceState.loaded(
              workspaces: [newWorkspace],
              selectedWorkspace: newWorkspace,
              allUsers: [],
              currentMembers: members,
            ),
          );
        },
      );
    });
  }

  Future<void> createDefaultWorkspace() async {
    // debugPrint('⏳ WorkspaceCubit: Starting createDefaultWorkspace()...');
    final result = await createWorkspaceUseCase.call(
      name: 'Personal Workspace',
      description: 'Your default workspace for tasks.',
    );

    result.fold(
      (failure) {
        // debugPrint('❌ WorkspaceCubit: createDefaultWorkspace failed: $failure');
        emit(WorkspaceState.error(failure));
      },
      (newWorkspace) async {
        final membersResult = await workspaceRepository.getWorkspaceMembers(
          newWorkspace.id,
        );
        final members = membersResult.fold(
          (_) => <Map<String, dynamic>>[],
          (m) => m,
        );

        emit(
          WorkspaceState.loaded(
            workspaces: [newWorkspace],
            selectedWorkspace: newWorkspace,
            allUsers: [],
            currentMembers: members,
          ),
        );
      },
    );
  }

  Future<void> addMember(String email) async {
    final activeWorkspace = state.maybeWhen(
      loaded: (_, selected, _, _) => selected,
      orElse: () => null,
    );

    if (activeWorkspace == null) return;

    final result = await addWorkspaceMemberUseCase.call(
      workspaceId: activeWorkspace.id,
      email: email,
    );

    result.fold(
      (failure) {
        // debugPrint('❌ WorkspaceCubit: addMember failed: $failure');
      },
      (_) {
        // debugPrint('✅ WorkspaceCubit: Member added successfully, reloading...');
        loadWorkspaces();
      },
    );
  }

  Future<void> deleteWorkspace(String workspaceId) async {
    log('⏳ WorkspaceCubit: Deleting workspace: $workspaceId');

    // Clear selection if we are deleting the currently selected workspace
    final currentSelected = state.maybeWhen(
      loaded: (_, selected, _, _) => selected,
      orElse: () => null,
    );

    final result = await workspaceRepository.deleteWorkspace(workspaceId);

    result.fold(
      (failure) {
        log('❌ WorkspaceCubit: Delete failed: $failure');
        emit(WorkspaceState.error(failure));
      },
      (_) {
        log('✅ WorkspaceCubit: Delete successful');
        if (currentSelected?.id == workspaceId) {
          // If we deleted the selected one, we'll force a reload
          // which will trigger the new logic to pick the first available one
          loadWorkspaces();
        } else {
          loadWorkspaces();
        }
      },
    );
  }

  Future<void> selectWorkspace(WorkspaceEntity workspace) async {
    log(
      '⏳ WorkspaceCubit: Selecting workspace and refreshing members: ${workspace.name}',
    );

    // 1. Persist selection
    secureStorage.saveActiveWorkspaceId(workspace.id);

    // 2. FORCE fetch members from server (no local cache)
    final membersResult = await workspaceRepository.getWorkspaceMembers(
      workspace.id,
    );
    final members = membersResult.fold(
      (_) => <Map<String, dynamic>>[],
      (m) => m,
    );
    log(
      '👥 WorkspaceCubit: Fresh member count for ${workspace.name}: ${members.length}',
    );

    state.maybeWhen(
      loaded: (workspaces, _, allUsers, _) {
        emit(
          WorkspaceState.loaded(
            workspaces: workspaces,
            selectedWorkspace: workspace,
            allUsers: allUsers,
            currentMembers: members, // Now contains the fresh count
          ),
        );
      },
      orElse: () {},
    );
  }
}
