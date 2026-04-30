import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:collab_task/core/error/failures.dart';
import 'package:collab_task/features/demo/data/datasources/demo_datasource.dart';
import 'package:collab_task/features/demo/domain/entities/demo_entity.dart';
import 'package:collab_task/features/demo/domain/repositories/demo_repository.dart';

@LazySingleton(as: DemoRepository)
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
