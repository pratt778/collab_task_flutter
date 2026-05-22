import 'package:dartz/dartz.dart';
import 'package:collab_task/core/error/failures.dart';
import 'package:collab_task/features/chat/domain/entities/chat_message_entity.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ChatMessageEntity>>> getTaskMessages(
    String taskId,
  );

  Future<Either<Failure, ChatMessageEntity>> sendTaskMessage({
    required String taskId,
    required String text,
  });
}
