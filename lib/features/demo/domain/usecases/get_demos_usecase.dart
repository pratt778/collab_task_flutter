import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:collab_task/core/error/failures.dart';
import 'package:collab_task/features/demo/domain/entities/demo_entity.dart';
import 'package:collab_task/features/demo/domain/repositories/demo_repository.dart';

@lazySingleton
class GetDemosUseCase {
  final DemoRepository repository;

  GetDemosUseCase(this.repository);

  Future<Either<Failure, List<DemoEntity>>> call() => repository.getDemos();
}
