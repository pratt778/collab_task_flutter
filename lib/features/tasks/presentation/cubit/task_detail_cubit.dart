import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:collab_task/features/tasks/domain/entities/task_entity.dart';
import 'package:collab_task/features/tasks/domain/usecases/get_task_detail_usecase.dart';
import 'package:collab_task/features/tasks/domain/usecases/update_task_usecase.dart';
import 'package:collab_task/features/tasks/domain/usecases/delete_task_usecase.dart';
import 'package:collab_task/features/tasks/presentation/cubit/task_detail_state.dart';

@injectable
class TaskDetailCubit extends Cubit<TaskDetailState> {
  final GetTaskDetailUseCase getTaskDetailUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;

  TaskDetailCubit(
    this.getTaskDetailUseCase,
    this.updateTaskUseCase,
    this.deleteTaskUseCase,
  ) : super(const TaskDetailState.initial());

  Future<void> getTaskDetail(String id) async {
    emit(const TaskDetailState.loading());
    final result = await getTaskDetailUseCase(id);
    result.fold(
      (failure) => emit(TaskDetailState.error(failure)),
      (task) => emit(TaskDetailState.loaded(task)),
    );
  }

  Future<void> updateTask(TaskEntity task) async {
    // Optimistic update
    emit(TaskDetailState.submitting(task));

    final result = await updateTaskUseCase(task);
    result.fold(
      (failure) => emit(TaskDetailState.error(failure)),
      (updatedTask) => emit(TaskDetailState.success(updatedTask)),
    );
  }

  Future<void> deleteTask(String id) async {
    emit(const TaskDetailState.loading());
    final result = await deleteTaskUseCase(id);
    result.fold(
      (failure) => emit(TaskDetailState.error(failure)),
      (_) => emit(const TaskDetailState.initial()), // Or a deleted state
    );
  }
}
