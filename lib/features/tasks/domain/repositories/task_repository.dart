import 'package:dartz/dartz.dart';
import 'package:collab_task/core/error/failures.dart';
import 'package:collab_task/features/tasks/domain/entities/task_entity.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<TaskEntity>>> getTasks(String workspaceId);
  Future<Either<Failure, TaskEntity>> getTaskDetail(String id);
  Future<Either<Failure, TaskEntity>> createTask(TaskEntity task);
  Future<Either<Failure, TaskEntity>> updateTask(TaskEntity task);
  Future<Either<Failure, bool>> deleteTask(String id);
}
