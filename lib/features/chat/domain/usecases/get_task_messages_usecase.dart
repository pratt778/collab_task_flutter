import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:collab_task/core/error/failures.dart';
import 'package:collab_task/features/chat/domain/entities/chat_message_entity.dart';
import 'package:collab_task/features/chat/domain/repositories/chat_repository.dart';

@lazySingleton
class GetTaskMessagesUseCase {
  final ChatRepository repository;

  GetTaskMessagesUseCase(this.repository);

  Future<Either<Failure, List<ChatMessageEntity>>> call(String taskId) {
    return repository.getTaskMessages(taskId);
  }
}
