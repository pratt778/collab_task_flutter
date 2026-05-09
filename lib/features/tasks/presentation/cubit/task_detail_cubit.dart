import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:collab_task/features/tasks/domain/entities/task_entity.dart';
import 'package:collab_task/features/tasks/domain/entities/checklist_item_entity.dart';
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

  Future<void> updateTitle(String title) async {
    state.maybeWhen(
      loaded: (task) => updateTask(task.copyWith(title: title)),
      success: (task) => updateTask(task.copyWith(title: title)),
      orElse: () {},
    );
  }

  Future<void> updateDescription(String description) async {
    state.maybeWhen(
      loaded: (task) => updateTask(task.copyWith(description: description)),
      success: (task) => updateTask(task.copyWith(description: description)),
      orElse: () {},
    );
  }

  Future<void> toggleChecklistItem(String taskId, String itemId) async {
    state.maybeWhen(
      loaded: (task) => _performToggle(task, itemId),
      success: (task) => _performToggle(task, itemId),
      orElse: () {},
    );
  }

  Future<void> _performToggle(TaskEntity task, String itemId) async {
    final updatedChecklist = task.checklist.map((item) {
      if (item.id == itemId) {
        return item.copyWith(completed: !item.completed);
      }
      return item;
    }).toList();

    final updatedTask = task.copyWith(checklist: updatedChecklist);
    await updateTask(updatedTask);
  }

  Future<void> addChecklistItem(String title) async {
    state.maybeWhen(
      loaded: (task) => _performAddChecklist(task, title),
      success: (task) => _performAddChecklist(task, title),
      orElse: () {},
    );
  }

  Future<void> _performAddChecklist(TaskEntity task, String title) async {
    final newItem = ChecklistItemEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      completed: false,
    );
    final updatedTask = task.copyWith(
      checklist: [...task.checklist, newItem],
    );
    await updateTask(updatedTask);
  }

  Future<void> deleteChecklistItem(String itemId) async {
    state.maybeWhen(
      loaded: (task) => _performDeleteChecklist(task, itemId),
      success: (task) => _performDeleteChecklist(task, itemId),
      orElse: () {},
    );
  }

  Future<void> _performDeleteChecklist(TaskEntity task, String itemId) async {
    final updatedTask = task.copyWith(
      checklist: task.checklist.where((item) => item.id != itemId).toList(),
    );
    await updateTask(updatedTask);
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
