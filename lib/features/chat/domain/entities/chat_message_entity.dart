import 'package:equatable/equatable.dart';

class ChatMessageEntity extends Equatable {
  final String id;
  final String taskId;
  final String authorId;
  final String authorName;
  final String? authorAvatarUrl;
  final String text;
  final DateTime createdAt;

  const ChatMessageEntity({
    required this.id,
    required this.taskId,
    required this.authorId,
    required this.authorName,
    this.authorAvatarUrl,
    required this.text,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    taskId,
    authorId,
    authorName,
    authorAvatarUrl,
    text,
    createdAt,
  ];

  ChatMessageEntity copyWith({
    String? id,
    String? taskId,
    String? authorId,
    String? authorName,
    String? authorAvatarUrl,
    String? text,
    DateTime? createdAt,
  }) {
    return ChatMessageEntity(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
