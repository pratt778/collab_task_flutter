import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:collab_task/core/error/failures.dart';
import 'package:collab_task/features/workspaces/domain/entities/workspace_entity.dart';
import 'package:collab_task/features/workspaces/domain/usecases/get_my_workspaces_usecase.dart';
import 'package:collab_task/features/workspaces/domain/usecases/create_workspace_usecase.dart';

part 'workspace_cubit.freezed.dart';

@freezed
class WorkspaceState with _$WorkspaceState {
  const factory WorkspaceState.initial() = _Initial;
  const factory WorkspaceState.loading() = _Loading;
  const factory WorkspaceState.loaded({
    required List<WorkspaceEntity> workspaces,
    WorkspaceEntity? selectedWorkspace,
  }) = _Loaded;
  const factory WorkspaceState.error(Failure failure) = _Error;
}

@lazySingleton
class WorkspaceCubit extends Cubit<WorkspaceState> {
  final GetMyWorkspacesUseCase getMyWorkspacesUseCase;
  final CreateWorkspaceUseCase createWorkspaceUseCase;

  WorkspaceCubit({
    required this.getMyWorkspacesUseCase,
    required this.createWorkspaceUseCase,
  }) : super(const WorkspaceState.initial());

  Future<void> loadWorkspaces() async {
    debugPrint('⏳ WorkspaceCubit: Starting loadWorkspaces()...');
    emit(const WorkspaceState.loading());
    final result = await getMyWorkspacesUseCase.call();
    
    result.fold(
      (failure) {
        debugPrint('❌ WorkspaceCubit: loadWorkspaces failed: $failure');
        emit(WorkspaceState.error(failure));
      },
      (workspaces) async {
        debugPrint('✅ WorkspaceCubit: Found ${workspaces.length} workspaces');
        if (workspaces.isEmpty) {
          debugPrint('ℹ️ WorkspaceCubit: No workspaces found, auto-creating default...');
          await createDefaultWorkspace();
        } else {
          debugPrint('✅ WorkspaceCubit: Selecting first workspace: ${workspaces.first.name}');
          emit(WorkspaceState.loaded(
            workspaces: workspaces,
            selectedWorkspace: workspaces.first,
          ));
        }
      },
    );
  }

  Future<void> createWorkspace({required String name, String? description}) async {
    debugPrint('⏳ WorkspaceCubit: Creating custom workspace: $name');
    final result = await createWorkspaceUseCase.call(
      name: name,
      description: description,
    );

    result.fold(
      (failure) => emit(WorkspaceState.error(failure)),
      (newWorkspace) {
        state.maybeWhen(
          loaded: (workspaces, _) {
            final updatedList = List<WorkspaceEntity>.from(workspaces)..add(newWorkspace);
            emit(WorkspaceState.loaded(
              workspaces: updatedList,
              selectedWorkspace: newWorkspace,
            ));
          },
          orElse: () {
            emit(WorkspaceState.loaded(
              workspaces: [newWorkspace],
              selectedWorkspace: newWorkspace,
            ));
          },
        );
      },
    );
  }

  Future<void> createDefaultWorkspace() async {
    debugPrint('⏳ WorkspaceCubit: Starting createDefaultWorkspace()...');
    final result = await createWorkspaceUseCase.call(
      name: 'Personal Workspace',
      description: 'Your default workspace for tasks.',
    );

    result.fold(
      (failure) {
        debugPrint('❌ WorkspaceCubit: createDefaultWorkspace failed: $failure');
        emit(WorkspaceState.error(failure));
      },
      (newWorkspace) {
        debugPrint('✅ WorkspaceCubit: Default workspace created successfully: ${newWorkspace.id}');
        emit(WorkspaceState.loaded(
          workspaces: [newWorkspace],
          selectedWorkspace: newWorkspace,
        ));
      },
    );
  }

  void selectWorkspace(WorkspaceEntity workspace) {
    state.maybeWhen(
      loaded: (workspaces, _) {
        emit(WorkspaceState.loaded(
          workspaces: workspaces,
          selectedWorkspace: workspace,
        ));
      },
      orElse: () {},
    );
  }
}
