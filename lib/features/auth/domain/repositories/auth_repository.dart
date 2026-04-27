import 'package:dartz/dartz.dart';
import 'package:flutter_clean_starter/core/error/failures.dart';
import 'package:flutter_clean_starter/features/auth/domain/entities/login_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginResponseEntity>> login({
    required String phoneNumber,
    required String customerNo,
    required String organizationCode,
  });

  Future<Either<Failure, void>> logout();
}
