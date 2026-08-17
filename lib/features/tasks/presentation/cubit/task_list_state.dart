import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:collab_task/core/error/failures.dart';
import 'package:collab_task/features/tasks/domain/entities/task_entity.dart';

part 'task_list_state.freezed.dart';

@freezed
class TaskListState with _$TaskListState {
  const factory TaskListState.initial() = _Initial;
  const factory TaskListState.loading() = _Loading;
  const factory TaskListState.loaded(List<TaskEntity> tasks) = _Loaded;
  const factory TaskListState.error(Failure failure) = _Error;
}
