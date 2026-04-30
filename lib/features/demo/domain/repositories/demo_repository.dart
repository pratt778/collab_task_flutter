import 'package:dartz/dartz.dart';
import 'package:collab_task/core/error/failures.dart';
import 'package:collab_task/features/demo/domain/entities/demo_entity.dart';

abstract class DemoRepository {
  Future<Either<Failure, List<DemoEntity>>> getDemos();
}
