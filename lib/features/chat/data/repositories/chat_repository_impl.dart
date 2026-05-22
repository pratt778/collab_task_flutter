import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:collab_task/core/error/failures.dart';
import 'package:collab_task/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:collab_task/features/chat/domain/entities/chat_message_entity.dart';
import 'package:collab_task/features/chat/domain/repositories/chat_repository.dart';

@LazySingleton(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDatasource remoteDatasource;

  ChatRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, List<ChatMessageEntity>>> getTaskMessages(
    String taskId,
  ) async {
    try {
      final result = await remoteDatasource.getTaskMessages(taskId);
      return Right(result.map((message) => message.toEntity()).toList());
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, ChatMessageEntity>> sendTaskMessage({
    required String taskId,
    required String text,
  }) async {
    try {
      final result = await remoteDatasource.sendTaskMessage(
        taskId: taskId,
        text: text,
      );
      return Right(result.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    }
  }
}
