import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:collab_task/core/error/failures.dart';
import 'package:collab_task/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:collab_task/features/auth/domain/entities/login_entity.dart';
import 'package:collab_task/features/auth/domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.remoteDatasource});

  final AuthRemoteDatasource remoteDatasource;

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final model = await remoteDatasource.login(email: email, password: password);
      return Right(model.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final model = await remoteDatasource.register(email: email, password: password, name: name);
      return Right(model.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDatasource.logout();
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
      await remoteDatasource.resetPassword(email);
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, UserEntity>> verifyOtp({
    required String email,
    required String token,
  }) async {
    try {
      final model = await remoteDatasource.verifyOtp(
        email: email,
        token: token,
        type: sb.OtpType.recovery,
      );
      return Right(model.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, void>> updatePassword(String newPassword) async {
    try {
      await remoteDatasource.updatePassword(newPassword);
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getAllUsers() async {
    try {
      final models = await remoteDatasource.getAllUsers();
      return Right(models.map((e) => e.toEntity()).toList());
    } on Failure catch (failure) {
      return Left(failure);
    }
  }
}
