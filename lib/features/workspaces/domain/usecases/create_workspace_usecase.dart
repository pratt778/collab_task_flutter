import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:collab_task/core/error/failures.dart';
import 'package:collab_task/features/workspaces/domain/entities/workspace_entity.dart';
import 'package:collab_task/features/workspaces/domain/repositories/workspace_repository.dart';

@lazySingleton
class CreateWorkspaceUseCase {
  final WorkspaceRepository repository;

  CreateWorkspaceUseCase(this.repository);

  Future<Either<Failure, WorkspaceEntity>> call({
    required String name,
    String? description,
  }) {
    return repository.createWorkspace(name: name, description: description);
  }
}
