import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:collab_task/core/app/router/app_router.dart';
import 'package:collab_task/core/config/constants/color_constant.dart';
import 'package:collab_task/features/tasks/domain/entities/task_entity.dart';

import 'package:collab_task/core/config/theme/app_colors_extension.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback? onMove;

  const TaskCard({super.key, required this.task, this.onMove});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final completedCount = task.checklist.where((i) => i.completed).length;
    final totalCount = task.checklist.length;
    final progress = totalCount > 0 ? completedCount / totalCount : 0.0;

    return GestureDetector(
      onTap: () {
        context.pushNamed(
          MainRoutes.taskDetailName,
          pathParameters: {'id': task.id},
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: colors.border, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Labels
            if (task.labels.isNotEmpty) ...[
              Wrap(
                spacing: 6.w,
                runSpacing: 6.h,
                children: task.labels.map((l) => _buildLabel(l, colors)).toList(),
              ),
              SizedBox(height: 12.h),
            ],

            // Title
            Text(
              task.title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
                color: colors.textPrimary,
                height: 1.3,
              ),
            ),

            if (task.description.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Text(
                task.description,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: colors.textSecondary,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            SizedBox(height: 16.h),

            // Progress Bar
            if (totalCount > 0) ...[
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6.h,
                        backgroundColor: colors.surfaceMuted,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progress == 1.0 ? AppColors.successGreen : colors.primary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
            ],

            // Footer: Checklist & Assignees
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: 16.sp,
                      color: colors.textTertiary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '$completedCount/$totalCount',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.textSecondary,
                      ),
                    ),
                    if (task.dueDate != null) ...[
                      SizedBox(width: 12.w),
                      Icon(
                        Icons.access_time_rounded,
                        size: 16.sp,
                        color: _isOverdue(task.dueDate!) ? AppColors.errorRed : colors.textTertiary,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        _formatDate(task.dueDate!),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: _isOverdue(task.dueDate!) ? AppColors.errorRed : colors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),

                // Assignees & Move Button
                Row(
                  children: [
                    if (task.assignees.isNotEmpty) _buildAssignees(task.assignees, colors),
                    if (task.assignees.isNotEmpty) SizedBox(width: 8.w),
                    Container(
                      decoration: BoxDecoration(
                        color: colors.surfaceAlt,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.drive_file_move_rounded, size: 18.sp, color: colors.textSecondary),
                        onPressed: onMove,
                        padding: EdgeInsets.all(8.r),
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label, AppColorsExtension colors) {
    // Keep raw brand colors or map to semantic theme tokens
    // ... logic remains ...
    final isDark = colors.scaffold.computeLuminance() < 0.5;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isDark ? colors.surfaceAlt : colors.surfaceMuted,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 10.sp,
          color: colors.textPrimary,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildAssignees(List<String> assignees, AppColorsExtension colors) {
    final showCount = assignees.length > 3 ? 3 : assignees.length;
    final width = (showCount > 1) ? (showCount - 1) * 14.w + 24.w : 24.w;

    return SizedBox(
      height: 24.h,
      width: width,
      child: Stack(
        children: List.generate(
          showCount,
          (index) => Positioned(
            right: index * 14.w,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: colors.surface, width: 2),
              ),
              child: CircleAvatar(
                radius: 11.r,
                backgroundColor: colors.primary,
                child: Text(
                  assignees[index][0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    }
    return '${date.day} ${_getMonth(date.month)}';
  }

  bool _isOverdue(DateTime date) {
    return date.isBefore(DateTime.now()) &&
        !(date.year == DateTime.now().year &&
            date.month == DateTime.now().month &&
            date.day == DateTime.now().day);
  }

  String _getMonth(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}
