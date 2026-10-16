import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:collab_task/features/tasks/domain/entities/task_entity.dart';
import 'package:collab_task/features/tasks/domain/usecases/get_tasks_usecase.dart';
import 'package:collab_task/features/tasks/domain/usecases/create_task_usecase.dart';
import 'package:collab_task/features/tasks/domain/usecases/delete_task_usecase.dart';
import 'package:collab_task/features/tasks/domain/usecases/update_task_usecase.dart';
import 'package:collab_task/features/tasks/presentation/cubit/task_list_state.dart';

@injectable
class TaskListCubit extends Cubit<TaskListState> {
  final GetTasksUseCase getTasksUseCase;
  final CreateTaskUseCase createTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  RealtimeChannel? _channel;
  String? _activeWorkspaceId;
  String? _loadingWorkspaceId;

  TaskListCubit(
    this.getTasksUseCase,
    this.createTaskUseCase,
    this.updateTaskUseCase,
    this.deleteTaskUseCase,
  ) : super(const TaskListState.initial());

  Future<void> getTasks(String workspaceId) async {
    await _fetchTasks(workspaceId, showLoading: true);
  }

  Future<void> refreshTasks(String workspaceId) async {
    await _fetchTasks(workspaceId, showLoading: false);
  }

  Future<void> _fetchTasks(
    String workspaceId, {
    required bool showLoading,
  }) async {
    if (_loadingWorkspaceId == workspaceId) return;

    _loadingWorkspaceId = workspaceId;
    if (showLoading) {
      emit(const TaskListState.loading());
    }

    final result = await getTasksUseCase(workspaceId);
    _loadingWorkspaceId = null;

    result.fold((failure) => emit(TaskListState.error(failure)), (tasks) {
      emit(TaskListState.loaded(tasks));
      if (_activeWorkspaceId != workspaceId) {
        _subscribeToChanges(workspaceId);
      }
    });
  }

  Future<void> createTask(TaskEntity task) async {
    final result = await createTaskUseCase(task);
    result.fold((failure) {
      return false;
    }, (newTask){
      _upsertTask(newTask);
      return true;
    });
  }

  Future<void> updateTask(TaskEntity task) async {
    final result = await updateTaskUseCase(task);
    result.fold((failure) {
      emit(TaskListState.error(failure));
    }, _upsertTask);
  }

  Future<void> deleteTask(String id) async {
    final previousTasks = state.maybeWhen(
      loaded: (tasks) => tasks,
      orElse: () => null,
    );
    removeTask(id);

    final result = await deleteTaskUseCase(id);
    result.fold((failure) {
      if (previousTasks != null) {
        emit(TaskListState.loaded(previousTasks));
      }
      emit(TaskListState.error(failure));
    }, (_) {});
  }

  void _upsertTask(TaskEntity task) {
    state.maybeWhen(
      loaded: (tasks) {
        final index = tasks.indexWhere((item) => item.id == task.id);
        if (index == -1) {
          emit(TaskListState.loaded([task, ...tasks]));
          return;
        }

        final updatedTasks = [...tasks];
        updatedTasks[index] = task;
        emit(TaskListState.loaded(updatedTasks));
      },
      orElse: () {},
    );
  }

  void removeTask(String id) {
    state.maybeWhen(
      loaded: (tasks) {
        emit(
          TaskListState.loaded(tasks.where((task) => task.id != id).toList()),
        );
      },
      orElse: () {},
    );
  }

  void _subscribeToChanges(String workspaceId) {
    _channel?.unsubscribe();
    _activeWorkspaceId = workspaceId;

    _channel = Supabase.instance.client
        .channel('public:tasks:workspace=$workspaceId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'tasks',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'workspace_id',
            value: workspaceId,
          ),
          callback: (payload) {
            refreshTasks(workspaceId);
          },
        )
        .subscribe();
  }

  @override
  Future<void> close() {
    _channel?.unsubscribe();
    return super.close();
  }
}
