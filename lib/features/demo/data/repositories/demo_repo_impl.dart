import 'package:dartz/dartz.dart';
import 'package:flutter_clean_starter/core/error/failures.dart';
import 'package:flutter_clean_starter/features/demo/data/datasources/demo_datasource.dart';
import 'package:flutter_clean_starter/features/demo/domain/entities/demo_entity.dart';
import 'package:flutter_clean_starter/features/demo/domain/repositories/demo_repository.dart';

class DemoRepositoryImpl implements DemoRepository {
  final DemoRemoteDatasource remoteDatasource;

  DemoRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, List<DemoEntity>>> getDemos() async {
    try {
      final models = await remoteDatasource.getDemos();
      return Right(models.map((m) => m.toEntity()).toList());
    } on Failure catch (failure) {
      return Left(failure);
    }
  }
}
