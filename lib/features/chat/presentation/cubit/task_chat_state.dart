import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:collab_task/core/error/failures.dart';
import 'package:collab_task/features/chat/domain/entities/chat_message_entity.dart';

part 'task_chat_state.freezed.dart';

@freezed
class TaskChatState with _$TaskChatState {
  const factory TaskChatState.initial() = _Initial;
  const factory TaskChatState.loading() = _Loading;
  const factory TaskChatState.loaded(List<ChatMessageEntity> messages) =
      _Loaded;
  const factory TaskChatState.submitting(List<ChatMessageEntity> messages) =
      _Submitting;
  const factory TaskChatState.error(
    Failure failure,
    List<ChatMessageEntity> messages,
  ) = _Error;
}
