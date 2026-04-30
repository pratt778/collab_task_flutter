import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collab_task/core/app/di/injection_container.dart';
import 'package:collab_task/features/tasks/presentation/cubit/task_detail_cubit.dart';
import 'package:collab_task/features/tasks/presentation/cubit/task_detail_state.dart';

class TaskDetailScreen extends StatefulWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late final TaskDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<TaskDetailCubit>();
    _cubit.getTaskDetail(widget.taskId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Task Detail'),
        ),
        body: BlocBuilder<TaskDetailCubit, TaskDetailState>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const Center(child: CircularProgressIndicator()),
              loaded: _buildDetail,
              error: (failure) => Center(child: Text(failure.toString())),
              submitting: (task) => _buildDetail(task, isSubmitting: true),
              success: _buildDetail,
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetail(dynamic task, {bool isSubmitting = false}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isSubmitting) const LinearProgressIndicator(),
          Text(
            task.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(task.description),
          const SizedBox(height: 24),
          const Text(
            'Checklist',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: task.checklist.length,
              itemBuilder: (context, index) {
                final item = task.checklist[index];
                return CheckboxListTile(
                  title: Text(item.title),
                  value: item.completed,
                  onChanged: (val) {
                    // TODO: Implement toggle
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
