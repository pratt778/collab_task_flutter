import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:collab_task/core/network/websocket_service.dart';
import 'package:collab_task/features/tasks/domain/entities/task_entity.dart';
import 'package:collab_task/features/tasks/domain/usecases/get_tasks_usecase.dart';
import 'package:collab_task/features/tasks/domain/usecases/create_task_usecase.dart';
import 'package:collab_task/features/tasks/presentation/cubit/task_list_state.dart';

@injectable
class TaskListCubit extends Cubit<TaskListState> {
  final GetTasksUseCase getTasksUseCase;
  final CreateTaskUseCase createTaskUseCase;
  final WebSocketService webSocketService;
  StreamSubscription? _wsSubscription;

  TaskListCubit(
    this.getTasksUseCase,
    this.createTaskUseCase,
    this.webSocketService,
  ) : super(const TaskListState.initial());

  Future<void> getTasks() async {
    emit(const TaskListState.loading());
    final result = await getTasksUseCase();
    result.fold(
      (failure) => emit(TaskListState.error(failure)),
      (tasks) {
        emit(TaskListState.loaded(tasks));
        _subscribeToWebSocket();
      },
    );
  }

  Future<void> createTask(TaskEntity task) async {
    final result = await createTaskUseCase(task);
    result.fold(
      (failure) => emit(TaskListState.error(failure)),
      (_) => getTasks(), // Refresh list on success
    );
  }

  void _subscribeToWebSocket() {
    _wsSubscription?.cancel();
    _wsSubscription = webSocketService.dataStream.listen((data) {
      final type = data['type'] as String?;
      if (type == 'task_created' ||
          type == 'task_updated' ||
          type == 'task_deleted') {
        // For MVP, we can just re-fetch, but ideally we'd update local list
        getTasks();
      }
    });
  }

  @override
  Future<void> close() {
    _wsSubscription?.cancel();
    return super.close();
  }
}
