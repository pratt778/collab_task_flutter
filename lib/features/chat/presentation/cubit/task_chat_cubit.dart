import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:collab_task/features/chat/domain/entities/chat_message_entity.dart';
import 'package:collab_task/features/chat/domain/usecases/get_task_messages_usecase.dart';
import 'package:collab_task/features/chat/domain/usecases/send_task_message_usecase.dart';
import 'package:collab_task/features/chat/presentation/cubit/task_chat_state.dart';

@injectable
class TaskChatCubit extends Cubit<TaskChatState> {
  final GetTaskMessagesUseCase getTaskMessagesUseCase;
  final SendTaskMessageUseCase sendTaskMessageUseCase;
  RealtimeChannel? _channel;
  String? _activeTaskId;
  String? _subscribedTaskId;
  String? _loadingTaskId;

  TaskChatCubit(this.getTaskMessagesUseCase, this.sendTaskMessageUseCase)
    : super(const TaskChatState.initial());

  Future<void> loadTaskMessages(String taskId) async {
    await _fetchMessages(taskId, showLoading: true);
  }

  Future<void> refreshTaskMessages(String taskId) async {
    await _fetchMessages(taskId, showLoading: false);
  }


  // loads the past or previous messages. 
  Future<void> _fetchMessages(
    String taskId, {
    required bool showLoading,
  }) async {
    if (_loadingTaskId == taskId) return;

    _loadingTaskId = taskId;
    _activeTaskId = taskId;

    if (showLoading) {
      emit(const TaskChatState.loading());
    }

    final result = await getTaskMessagesUseCase(taskId);
    _loadingTaskId = null;

    if (isClosed) return;

    result.fold((failure) => emit(TaskChatState.error(failure, const [])), (
      messages,
    ) {
      emit(TaskChatState.loaded(messages));
      if (_subscribedTaskId != taskId) {
        _subscribeToChanges(taskId);
      }
    });
  }

  Future<void> sendMessage(String text) async {
    final taskId = _activeTaskId;
    if (taskId == null) return;

    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final currentMessages = state.maybeWhen(
      loaded: (messages) => messages,
      submitting: (messages) => messages,
      error: (_, messages) => messages,
      orElse: () => <ChatMessageEntity>[],
    );

    emit(TaskChatState.submitting(currentMessages));
    final result = await sendTaskMessageUseCase(taskId: taskId, text: trimmed);
    if (isClosed) return;
    result.fold(
      (failure) => emit(TaskChatState.error(failure, currentMessages)),
      (message) {
        emit(TaskChatState.loaded([...currentMessages, message]));
      },
    );
  }
  // the future subscribe, it will recieve the message in real time. when another sends sends the msg. 
  void _subscribeToChanges(String taskId) {
    _channel?.unsubscribe();
    _subscribedTaskId = taskId;
    _channel = Supabase.instance.client
        .channel('public:messages:task=$taskId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'task_id',
            value: taskId,
          ),
          callback: (_) {
            if (isClosed) return;
            refreshTaskMessages(taskId);
          },
        )
        .subscribe();
  }

  @override
  Future<void> close() {
    _channel?.unsubscribe();
    return super.close();
  }
}
