import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:collab_task/core/error/failures.dart';
import 'package:collab_task/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:collab_task/features/auth/domain/entities/login_entity.dart';
import 'package:collab_task/features/auth/domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.remoteDatasource});

  final AuthRemoteDatasource remoteDatasource;

  @override
  Future<Either<Failure, LoginResponseEntity>> login({
    required String phoneNumber,
    required String customerNo,
    required String organizationCode,
  }) async {
    try {
      final model = await remoteDatasource.login(phoneNumber: phoneNumber, customerNo: customerNo, organizationCode: organizationCode);
      final entity = model.toEntity();
      debugPrint('entity: $entity');
      return Right(entity);
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await remoteDatasource.logout();
      return const Right(unit);
    } on Failure catch (failure) {
      return Left(failure);
    }
  }
}
