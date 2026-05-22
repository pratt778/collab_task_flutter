import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:collab_task/core/app/router/app_router.dart';
import 'package:collab_task/core/config/constants/color_constant.dart';
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
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (failure) => _buildErrorScaffold(
            context,
            message: localizedFailureMessage(context, failure),
          ),
          loaded: (task) => _buildScaffold(context, task),
          success: (task) => _buildScaffold(context, task),
          submitting: (task) =>
              _buildScaffold(context, task, isSubmitting: true),
          orElse: () =>
              const Scaffold(body: Center(child: Text('Initializing...'))),
        );
      },
    );
  }

  Widget _buildErrorScaffold(BuildContext context, {required String message}) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textDark,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: AppColors.errorRed,
                size: 40.r,
              ),
              SizedBox(height: 12.h),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16.h),
              FilledButton.icon(
                onPressed: () => context.read<TaskDetailCubit>().getTaskDetail(
                  widget.taskId,
                ),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScaffold(
    BuildContext context,
    TaskEntity task, {
    bool isSubmitting = false,
  }) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textDark,
        title: Text(
          'Task Details',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20.sp),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: AppColors.errorRed,
            ),
            onPressed: isSubmitting
                ? null
                : () => _confirmDelete(context, task),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: _buildDetail(task),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: AppColors.mediumShadow,
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

  Future<void> _confirmDelete(BuildContext context, TaskEntity task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete task?'),
        content: Text('This will permanently delete "${task.title}".'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.errorRed),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;
    await context.read<TaskDetailCubit>().deleteTask(task.id);
  }

  Widget _buildDetail(TaskEntity task) {
    final completedCount = task.checklist.where((e) => e.completed).length;
    final totalCount = task.checklist.length;
    final progress = totalCount > 0 ? completedCount / totalCount : 0.0;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          // Hero Header Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(30.r),
              boxShadow: AppColors.mediumShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
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
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.edit_note_rounded,
                      color: Colors.white70,
                      size: 24.sp,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                if (task.description.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  Text(
                    task.description,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white.withValues(alpha: 0.8),
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: 32.h),

          // Checklist Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionHeader('Subtasks'),
              Text(
                '$completedCount/$totalCount',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10.h,
              backgroundColor: AppColors.surfaceSubtle,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryBlue,
              ),
            ),
          ),

          SizedBox(height: 24.h),

          // Checklist Items
          if (task.checklist.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: AppColors.softShadow,
              ),
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
                    );
                  }),
                ],
              ),
            ),

          SizedBox(height: 24.h),

          // Add New Item
          _buildAddChecklistItem(),
          SizedBox(height: 100.h), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _buildChecklistItem({
    required String title,
    required bool completed,
    required VoidCallback onToggle,
    required VoidCallback onDelete,
    required bool isLast,
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
                  color: completed
                      ? AppColors.successGreen
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: completed
                        ? AppColors.successGreen
                        : AppColors.borderMedium,
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
                    color: completed
                        ? AppColors.textTertiary
                        : AppColors.textDark,
                    decoration: completed ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline_rounded,
                  size: 20.sp,
                  color: AppColors.textTertiary,
                ),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddChecklistItem() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: AppColors.softShadow,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: [
          Icon(
            Icons.add_circle_outline_rounded,
            color: AppColors.primaryBlue,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: TextField(
              controller: _checklistController,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: 'Add a new subtask...',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 16.h),
              ),
              onSubmitted: (val) {
                if (val.isNotEmpty) {
                  context.read<TaskDetailCubit>().addChecklistItem(val.trim());
                  _checklistController.clear();
                }
              },
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send_rounded,
              color: AppColors.primaryBlue,
              size: 20.sp,
            ),
            onPressed: () {
              if (_checklistController.text.isNotEmpty) {
                context.read<TaskDetailCubit>().addChecklistItem(
                  _checklistController.text.trim(),
                );
                _checklistController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
