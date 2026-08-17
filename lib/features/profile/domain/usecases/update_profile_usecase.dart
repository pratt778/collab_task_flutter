import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:collab_task/core/error/failures.dart';
import 'package:collab_task/features/profile/domain/entities/profile_entity.dart';
import 'package:collab_task/features/profile/domain/repositories/profile_repository.dart';

@lazySingleton
class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, ProfileEntity>> call({
    String? displayName,
    String? phoneNumber,
    String? avatarUrl,
  }) {
    return repository.updateProfile(
      displayName: displayName,
      phoneNumber: phoneNumber,
      avatarUrl: avatarUrl,
    );
  }
}
