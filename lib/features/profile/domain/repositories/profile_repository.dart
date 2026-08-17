import 'package:dartz/dartz.dart';
import 'package:collab_task/core/error/failures.dart';
import 'package:collab_task/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getMyProfile();
  Future<Either<Failure, ProfileEntity>> updateProfile({
    String? displayName,
    String? phoneNumber,
    String? avatarUrl,
  });
}
