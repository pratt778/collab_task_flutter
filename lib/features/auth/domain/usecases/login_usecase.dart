import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:collab_task/core/error/failures.dart';
import 'package:collab_task/features/auth/domain/entities/login_entity.dart';

import '../repositories/auth_repository.dart';

@lazySingleton
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