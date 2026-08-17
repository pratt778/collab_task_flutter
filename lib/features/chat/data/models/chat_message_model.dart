import 'package:collab_task/features/chat/domain/entities/chat_message_entity.dart';

class ChatMessageModel {
  final String id;
  final String taskId;
  final String authorId;
  final String authorName;
  final String? authorAvatarUrl;
  final String text;
  final DateTime createdAt;

  const ChatMessageModel({
    required this.id,
    required this.taskId,
    required this.authorId,
    required this.authorName,
    this.authorAvatarUrl,
    required this.text,
    required this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    final author = json['author'];
    final authorMap = author is Map<String, dynamic>
        ? author
        : const <String, dynamic>{};
    final displayName = authorMap['display_name']?.toString().trim();

    return ChatMessageModel(
      id: json['id'] as String,
      taskId: json['task_id'] as String,
      authorId: json['user_id'] as String,
      authorName: displayName != null && displayName.isNotEmpty
          ? displayName
          : 'Member',
      authorAvatarUrl: authorMap['avatar_url']?.toString(),
      text: json['text'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {'task_id': taskId, 'user_id': authorId, 'text': text};
  }

  ChatMessageEntity toEntity() {
    return ChatMessageEntity(
      id: id,
      taskId: taskId,
      authorId: authorId,
      authorName: authorName,
      authorAvatarUrl: authorAvatarUrl,
      text: text,
      createdAt: createdAt,
    );
  }

  factory ChatMessageModel.fromEntity(ChatMessageEntity entity) {
    return ChatMessageModel(
      id: entity.id,
      taskId: entity.taskId,
      authorId: entity.authorId,
      authorName: entity.authorName,
      authorAvatarUrl: entity.authorAvatarUrl,
      text: entity.text,
      createdAt: entity.createdAt,
    );
  }
}
