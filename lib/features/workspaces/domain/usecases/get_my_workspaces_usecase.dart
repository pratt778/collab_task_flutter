import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:collab_task/core/error/failures.dart';
import 'package:collab_task/features/workspaces/domain/entities/workspace_entity.dart';
import 'package:collab_task/features/workspaces/domain/repositories/workspace_repository.dart';

@lazySingleton
class GetMyWorkspacesUseCase {
  final WorkspaceRepository repository;

  GetMyWorkspacesUseCase(this.repository);

  Future<Either<Failure, List<WorkspaceEntity>>> call() {
    return repository.getMyWorkspaces();
  }
}
