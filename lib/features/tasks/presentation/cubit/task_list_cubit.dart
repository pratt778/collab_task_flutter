import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:collab_task/features/tasks/domain/entities/task_entity.dart';
import 'package:collab_task/features/tasks/domain/usecases/get_tasks_usecase.dart';
import 'package:collab_task/features/tasks/domain/usecases/create_task_usecase.dart';
import 'package:collab_task/features/tasks/domain/usecases/update_task_usecase.dart';
import 'package:collab_task/features/tasks/presentation/cubit/task_list_state.dart';

@injectable
class TaskListCubit extends Cubit<TaskListState> {
  final GetTasksUseCase getTasksUseCase;
  final CreateTaskUseCase createTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  RealtimeChannel? _channel;

  TaskListCubit(
    this.getTasksUseCase,
    this.createTaskUseCase,
    this.updateTaskUseCase,
  ) : super(const TaskListState.initial());

  Future<void> getTasks(String workspaceId) async {
    emit(const TaskListState.loading());
    final result = await getTasksUseCase(workspaceId);
    result.fold(
      (failure) => emit(TaskListState.error(failure)),
      (tasks) {
        emit(TaskListState.loaded(tasks));
        _subscribeToChanges(workspaceId);
      },
    );
  }

  Future<void> createTask(TaskEntity task) async {
    final result = await createTaskUseCase(task);
    result.fold(
      (failure) => emit(TaskListState.error(failure)),
      (_) {
        // The real-time listener will catch this
      },
    );
  }

  Future<void> updateTask(TaskEntity task) async {
    final result = await updateTaskUseCase(task);
    result.fold(
      (failure) => emit(TaskListState.error(failure)),
      (_) {
        // The real-time listener will catch this
      },
    );
  }

  void _subscribeToChanges(String workspaceId) {
    _channel?.unsubscribe();
    
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
            getTasks(workspaceId);
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
