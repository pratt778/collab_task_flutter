import 'package:dartz/dartz.dart';
import 'package:collab_task/core/error/failures.dart';
import 'package:collab_task/features/auth/domain/entities/login_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginResponseEntity>> login({
    required String phoneNumber,
    required String customerNo,
    required String organizationCode,
  });

  Future<Either<Failure, void>> logout();
}
