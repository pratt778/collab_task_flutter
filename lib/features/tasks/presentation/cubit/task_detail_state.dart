import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:collab_task/core/error/failures.dart';
import 'package:collab_task/features/tasks/domain/entities/task_entity.dart';

part 'task_detail_state.freezed.dart';

@freezed
class TaskDetailState with _$TaskDetailState {
  const factory TaskDetailState.initial() = _Initial;
  const factory TaskDetailState.loading() = _Loading;
  const factory TaskDetailState.loaded(TaskEntity task) = _Loaded;
  const factory TaskDetailState.error(Failure failure) = _Error;
  const factory TaskDetailState.submitting(TaskEntity task) = _Submitting;
  const factory TaskDetailState.success(TaskEntity task) = _Success;
}
