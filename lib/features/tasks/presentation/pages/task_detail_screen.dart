import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:collab_task/core/app/router/app_router.dart';
import 'package:collab_task/core/config/theme/app_colors_extension.dart';
import 'package:collab_task/core/error/failure_messages.dart';
import 'package:collab_task/features/tasks/domain/entities/task_entity.dart';
import 'package:collab_task/features/tasks/presentation/cubit/task_detail_cubit.dart';
import 'package:collab_task/features/tasks/presentation/cubit/task_detail_state.dart';
import 'package:collab_task/features/tasks/presentation/cubit/task_list_cubit.dart';

class TaskDetailScreen extends StatefulWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final _checklistController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<TaskDetailCubit>().getTaskDetail(widget.taskId);
  }

  @override
  void dispose() {
    _checklistController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return BlocConsumer<TaskDetailCubit, TaskDetailState>(
      listener: (context, state) {
        state.whenOrNull(
          deleted: () {
            context.read<TaskListCubit>().removeTask(widget.taskId);
            context.pop();
          },
        );
      },
      builder: (context, state) {
        return state.maybeWhen(
          loading: () => Scaffold(
            backgroundColor: colors.scaffold,
            body: Center(child: CircularProgressIndicator(color: colors.primary)),
          ),
          error: (failure) => _buildErrorScaffold(
            context,
            colors: colors,
            message: localizedFailureMessage(context, failure),
          ),
          loaded: (task) => _buildScaffold(context, task, colors),
          success: (task) => _buildScaffold(context, task, colors),
          submitting: (task) =>
              _buildScaffold(context, task, colors, isSubmitting: true),
          orElse: () => Scaffold(
            backgroundColor: colors.scaffold,
            body: Center(
              child: Text('Initializing...', style: TextStyle(color: colors.textPrimary)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorScaffold(BuildContext context,
      {required AppColorsExtension colors, required String message}) {
    return Scaffold(
      backgroundColor: colors.scaffold,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: colors.textPrimary,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded, color: Colors.red, size: 40.r),
              SizedBox(height: 12.h),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colors.textSecondary,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16.h),
              FilledButton.icon(
                onPressed: () =>
                    context.read<TaskDetailCubit>().getTaskDetail(widget.taskId),
                style: FilledButton.styleFrom(backgroundColor: colors.primary),
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                label: const Text('Retry', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScaffold(
    BuildContext context,
    TaskEntity task,
    AppColorsExtension colors, {
    bool isSubmitting = false,
  }) {
    return Scaffold(
      backgroundColor: colors.scaffold,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colors.textPrimary,
        title: Text(
          'Task Details',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20.sp),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
            onPressed: isSubmitting
                ? null
                : () => _confirmDelete(context, task, colors),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: _buildDetail(task, colors),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: colors.primary,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: FloatingActionButton(
          onPressed: () {
            context.pushNamed(
              MainRoutes.taskDiscussionName,
              pathParameters: {'id': task.id},
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          highlightElevation: 0,
          child: Text('💬', style: TextStyle(fontSize: 24.sp)),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    TaskEntity task,
    AppColorsExtension colors,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: colors.surface,
        title: Text('Delete task?', style: TextStyle(color: colors.textPrimary)),
        content: Text('This will permanently delete "${task.title}".',
            style: TextStyle(color: colors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('Cancel', style: TextStyle(color: colors.textSecondary)),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;
    await context.read<TaskDetailCubit>().deleteTask(task.id);
  }

  Widget _buildDetail(TaskEntity task, AppColorsExtension colors) {
    final completedCount = task.checklist.where((e) => e.completed).length;
    final totalCount = task.checklist.length;
    final progress = totalCount > 0 ? completedCount / totalCount : 0.0;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        task.status.name.toUpperCase(),
                        style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 1),
                      ),
                    ),
                    Icon(Icons.edit_note_rounded,
                        color: Colors.white70, size: 24.sp),
                  ],
                ),
                SizedBox(height: 20.h),
                Text(
                  task.title,
                  style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.2),
                ),
                if (task.description.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  Text(
                    task.description,
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white.withValues(alpha: 0.8),
                        height: 1.5),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: 32.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtasks',
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                      color: colors.textPrimary)),
              Text('$completedCount/$totalCount',
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.primary)),
            ],
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10.h,
              backgroundColor: colors.surfaceMuted,
              valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
            ),
          ),
          SizedBox(height: 24.h),
          if (task.checklist.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(color: colors.border)),
              child: Column(
                children: [
                  ...task.checklist.asMap().entries.map<Widget>((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final isLast = index == task.checklist.length - 1;
                    return _buildChecklistItem(
                        title: item.title,
                        completed: item.completed,
                        onToggle: () => context
                            .read<TaskDetailCubit>()
                            .toggleChecklistItem(task.id, item.id),
                        onDelete: () => context
                            .read<TaskDetailCubit>()
                            .deleteChecklistItem(item.id),
                        isLast: isLast,
                        colors: colors);
                  }),
                ],
              ),
            ),
          SizedBox(height: 24.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: colors.border)),
            child: Row(
              children: [
                Icon(Icons.add_circle_outline_rounded,
                    color: colors.primary, size: 24.sp),
                SizedBox(width: 12.w),
                Expanded(
                  child: TextField(
                    controller: _checklistController,
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary),
                    decoration: InputDecoration(
                        hintText: 'Add a new subtask...',
                        hintStyle: TextStyle(color: colors.textTertiary),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 16.h)),
                    onSubmitted: (val) {
                      if (val.isNotEmpty) {
                        context
                            .read<TaskDetailCubit>()
                            .addChecklistItem(val.trim());
                        _checklistController.clear();
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send_rounded,
                      color: colors.primary, size: 20.sp),
                  onPressed: () {
                    if (_checklistController.text.isNotEmpty) {
                      context
                          .read<TaskDetailCubit>()
                          .addChecklistItem(_checklistController.text.trim());
                      _checklistController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }

  Widget _buildChecklistItem({
    required String title,
    required bool completed,
    required VoidCallback onToggle,
    required VoidCallback onDelete,
    required bool isLast,
    required AppColorsExtension colors,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onToggle,
        borderRadius: isLast
            ? BorderRadius.vertical(bottom: Radius.circular(24.r))
            : BorderRadius.zero,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 24.r,
                height: 24.r,
                decoration: BoxDecoration(
                  color: completed ? Colors.green : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: completed ? Colors.green : colors.border,
                    width: 2,
                  ),
                ),
                child: completed
                    ? Icon(Icons.check, size: 16.sp, color: Colors.white)
                    : null,
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color:
                        completed ? colors.textTertiary : colors.textPrimary,
                    decoration: completed ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline_rounded,
                    size: 20.sp, color: colors.textTertiary),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
