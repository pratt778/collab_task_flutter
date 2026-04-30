import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:collab_task/core/error/failures.dart';
import 'package:collab_task/features/tasks/domain/repositories/task_repository.dart';

@lazySingleton
class DeleteTaskUseCase {
  final TaskRepository repository;

  DeleteTaskUseCase(this.repository);

  Future<Either<Failure, bool>> call(String id) {
    return repository.deleteTask(id);
  }
}
