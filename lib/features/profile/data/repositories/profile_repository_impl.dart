import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:collab_task/core/error/failures.dart';
import 'package:collab_task/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:collab_task/features/profile/domain/entities/profile_entity.dart';
import 'package:collab_task/features/profile/domain/repositories/profile_repository.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource remoteDatasource;

  ProfileRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, ProfileEntity>> getMyProfile() async {
    try {
      final result = await remoteDatasource.getMyProfile();
      return Right(result.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile({
    String? displayName,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    try {
      final result = await remoteDatasource.updateProfile(
        displayName: displayName,
        phoneNumber: phoneNumber,
        avatarUrl: avatarUrl,
      );
      return Right(result.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    }
  }
}
