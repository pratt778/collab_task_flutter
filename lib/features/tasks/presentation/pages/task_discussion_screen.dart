import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collab_task/features/chat/presentation/widgets/chat_message_widget.dart';
import 'package:collab_task/core/app/di/injection_container.dart';
import 'package:collab_task/features/chat/presentation/cubit/task_chat_cubit.dart';

class TaskDiscussionScreen extends StatelessWidget {
  final String taskId;

  const TaskDiscussionScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskChatCubit>(
      create: (_) => sl<TaskChatCubit>()..loadTaskMessages(taskId),
      child: Scaffold(
        appBar: AppBar(title: const Text('Task Discussion'), elevation: 0),
        body: ChatMessageWidget(taskId: taskId),
      ),
    );
  }
}
