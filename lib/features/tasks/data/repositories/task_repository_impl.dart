import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:collab_task/core/error/failures.dart';
import 'package:collab_task/features/tasks/data/datasources/task_datasource.dart';
import 'package:collab_task/features/tasks/data/models/task_model.dart';
import 'package:collab_task/features/tasks/domain/entities/task_entity.dart';
import 'package:collab_task/features/tasks/domain/repositories/task_repository.dart';

@LazySingleton(as: TaskRepository)
class TaskRepositoryImpl implements TaskRepository {
  final TaskDatasource datasource;

  TaskRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasks(String workspaceId) async {
    try {
      final result = await datasource.getTasks(workspaceId);
      return Right(result.map((m) => m.toEntity()).toList());
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> getTaskDetail(String id) async {
    try {
      final result = await datasource.getTaskDetail(id);
      return Right(result.toEntity());
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> createTask(TaskEntity task) async {
    try {
      final model = TaskModel.fromEntity(task);
      final result = await datasource.createTask(model);
      return Right(result.toEntity());
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> updateTask(TaskEntity task) async {
    try {
      final model = TaskModel.fromEntity(task);
      final result = await datasource.updateTask(model);
      return Right(result.toEntity());
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTask(String id) async {
    try {
      final result = await datasource.deleteTask(id);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
