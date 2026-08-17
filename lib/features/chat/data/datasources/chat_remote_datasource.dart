import 'package:injectable/injectable.dart';
import 'package:collab_task/core/utils/safe_request_mapper.dart';
import 'package:collab_task/features/chat/data/models/chat_message_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

abstract class ChatRemoteDatasource {
  Future<List<ChatMessageModel>> getTaskMessages(String taskId);

  Future<ChatMessageModel> sendTaskMessage({
    required String taskId,
    required String text,
  });
}

@LazySingleton(as: ChatRemoteDatasource)
class ChatRemoteDatasourceImpl implements ChatRemoteDatasource {
  sb.SupabaseClient get _client => sb.Supabase.instance.client;

  @override
  Future<List<ChatMessageModel>> getTaskMessages(String taskId) {
    return SafeRequest.call(() async {
      final response = await _client
          .from('messages')
          .select(
            'id, task_id, user_id, text, created_at, author:profiles!messages_user_id_fkey(display_name, avatar_url)',
          )
          .eq('task_id', taskId)
          .order('created_at', ascending: true);

      return (response as List)
          .map(
            (json) => ChatMessageModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    });
  }

  @override
  Future<ChatMessageModel> sendTaskMessage({
    required String taskId,
    required String text,
  }) {
    return SafeRequest.call(() async {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw const sb.AuthException('You must be logged in to send messages');
      }

      final response = await _client
          .from('messages')
          .insert({'task_id': taskId, 'user_id': userId, 'text': text})
          .select(
            'id, task_id, user_id, text, created_at, author:profiles!messages_user_id_fkey(display_name, avatar_url)',
          )
          .single();

      return ChatMessageModel.fromJson(response);
    });
  }
}
