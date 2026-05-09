import 'package:flutter/material.dart';
import 'package:collab_task/features/chat/presentation/widgets/chat_message_widget.dart';

class TaskDiscussionScreen extends StatelessWidget {
  final String taskId;

  const TaskDiscussionScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Discussion'),
        elevation: 0,
      ),
      body: ChatMessageWidget(taskId: taskId),
    );
  }
}
