import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:collab_task/core/error/failures.dart';
import 'package:collab_task/features/workspaces/data/datasources/workspace_remote_datasource.dart';
import 'package:collab_task/features/workspaces/domain/entities/workspace_entity.dart';
import 'package:collab_task/features/workspaces/domain/repositories/workspace_repository.dart';

@LazySingleton(as: WorkspaceRepository)
class WorkspaceRepositoryImpl implements WorkspaceRepository {
  final WorkspaceRemoteDatasource remoteDatasource;

  WorkspaceRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, List<WorkspaceEntity>>> getMyWorkspaces() async {
    try {
      final models = await remoteDatasource.getMyWorkspaces();
      return Right(models.map((m) => m.toEntity()).toList());
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, WorkspaceEntity>> createWorkspace({
    required String name,
    String? description,
  }) async {
    try {
      final model = await remoteDatasource.createWorkspace(
        name: name,
        description: description,
      );
      return Right(model.toEntity());
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, void>> addMember({
    required String workspaceId,
    required String email,
  }) async {
    try {
      await remoteDatasource.addMemberByEmail(
        workspaceId: workspaceId,
        email: email,
      );
      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, void>> deleteWorkspace(String workspaceId) async {
    try {
      await remoteDatasource.deleteWorkspace(workspaceId);
      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getWorkspaceMembers(
    String workspaceId,
  ) async {
    try {
      final members = await remoteDatasource.getWorkspaceMembers(workspaceId);
      return Right(members);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
