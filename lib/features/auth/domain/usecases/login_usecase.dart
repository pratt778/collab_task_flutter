import 'package:dartz/dartz.dart';
import 'package:flutter_clean_starter/core/error/failures.dart';
import 'package:flutter_clean_starter/features/auth/domain/entities/login_entity.dart';

import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, LoginResponseEntity>> call({
    required String phoneNumber,
    required String customerNo,
    required String organizationCode,
  }) {
    return repository.login(
      phoneNumber: phoneNumber,
      customerNo: customerNo,
      organizationCode: organizationCode,
    );
  }
}