import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:collab_task/core/error/failures.dart';
import 'package:collab_task/features/chat/domain/entities/chat_message_entity.dart';
import 'package:collab_task/features/chat/domain/repositories/chat_repository.dart';

@lazySingleton
class SendTaskMessageUseCase {
  final ChatRepository repository;

  SendTaskMessageUseCase(this.repository);

  Future<Either<Failure, ChatMessageEntity>> call({
    required String taskId,
    required String text,
  }) {
    return repository.sendTaskMessage(taskId: taskId, text: text);
  }
}
