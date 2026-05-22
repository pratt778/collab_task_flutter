import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:collab_task/core/error/failures.dart';
import '../repositories/workspace_repository.dart';

@lazySingleton
class AddWorkspaceMemberUseCase {
  final WorkspaceRepository repository;

  AddWorkspaceMemberUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String workspaceId,
    required String email,
  }) {
    return repository.addMember(workspaceId: workspaceId, email: email);
  }
}
