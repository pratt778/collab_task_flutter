import 'package:dartz/dartz.dart';
import 'package:collab_task/core/error/failures.dart';
import 'package:collab_task/features/workspaces/domain/entities/workspace_entity.dart';

abstract class WorkspaceRepository {
  Future<Either<Failure, List<WorkspaceEntity>>> getMyWorkspaces();
  Future<Either<Failure, WorkspaceEntity>> createWorkspace({
    required String name,
    String? description,
  });
  Future<Either<Failure, void>> addMember({
    required String workspaceId,
    required String email,
  });
  Future<Either<Failure, void>> deleteWorkspace(String workspaceId);
  Future<Either<Failure, List<Map<String, dynamic>>>> getWorkspaceMembers(String workspaceId);
}
