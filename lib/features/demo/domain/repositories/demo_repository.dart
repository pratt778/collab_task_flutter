import 'package:dartz/dartz.dart';
import 'package:flutter_clean_starter/core/error/failures.dart';
import 'package:flutter_clean_starter/features/demo/domain/entities/demo_entity.dart';

abstract class DemoRepository {
  Future<Either<Failure, List<DemoEntity>>> getDemos();
}
