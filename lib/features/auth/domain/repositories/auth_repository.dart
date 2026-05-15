import 'package:dartz/dartz.dart';
import 'package:collab_task/core/error/failures.dart';
import 'package:collab_task/features/auth/domain/entities/login_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, void>> resetPassword(String email);

  Future<Either<Failure, UserEntity>> verifyOtp({
    required String email,
    required String token,
  });

  Future<Either<Failure, void>> updatePassword(String newPassword);
}
