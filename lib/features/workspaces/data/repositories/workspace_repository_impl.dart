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
}
