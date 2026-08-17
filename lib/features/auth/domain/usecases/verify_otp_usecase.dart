import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:collab_task/core/error/failures.dart';
import 'package:collab_task/features/auth/domain/entities/login_entity.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String token,
  }) {
    return repository.verifyOtp(
      email: email,
      token: token,
    );
  }
}
