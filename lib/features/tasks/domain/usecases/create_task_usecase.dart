import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:collab_task/core/error/failures.dart';
import 'package:collab_task/features/tasks/domain/entities/task_entity.dart';
import 'package:collab_task/features/tasks/domain/repositories/task_repository.dart';

@lazySingleton
class CreateTaskUseCase {
  final TaskRepository repository;

  CreateTaskUseCase(this.repository);

  Future<Either<Failure, TaskEntity>> call(TaskEntity task) {
    return repository.createTask(task);
  }
}
