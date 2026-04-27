import 'package:dartz/dartz.dart';
import 'package:flutter_clean_starter/core/error/failures.dart';
import 'package:flutter_clean_starter/features/demo/domain/entities/demo_entity.dart';
import 'package:flutter_clean_starter/features/demo/domain/repositories/demo_repository.dart';

class GetDemosUseCase {
  final DemoRepository repository;

  GetDemosUseCase(this.repository);

  Future<Either<Failure, List<DemoEntity>>> call() => repository.getDemos();
}
