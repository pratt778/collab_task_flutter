import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:collab_task/core/app/router/app_router.dart';
import 'package:collab_task/core/config/constants/color_constant.dart';
import 'package:collab_task/features/tasks/domain/entities/task_entity.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: AppColors.softShadow,
          border: Border.all(color: AppColors.borderSubtle, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Labels
            if (task.labels.isNotEmpty) ...[
              Wrap(
                spacing: 6.w,
                runSpacing: 6.h,
                children: task.labels.map((label) => _buildLabel(label)).toList(),
              ),
              SizedBox(height: 12.h),
            ],

            // Title
            Text(
              task.title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
                color: AppColors.textDark,
                height: 1.3,
              ),
            ),
            
            if (task.description.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Text(
                task.description,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
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
                        backgroundColor: AppColors.surfaceSubtle,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progress == 1.0 ? AppColors.successGreen : AppColors.primaryBlue,
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
                      color: AppColors.textSecondary,
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
                      color: AppColors.textTertiary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '$completedCount/$totalCount',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (task.dueDate != null) ...[
                      SizedBox(width: 12.w),
                      Icon(
                        Icons.access_time_rounded,
                        size: 16.sp,
                        color: _isOverdue(task.dueDate!) ? AppColors.errorRed : AppColors.textTertiary,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        _formatDate(task.dueDate!),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: _isOverdue(task.dueDate!) ? AppColors.errorRed : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
                
                // Assignees
                if (task.assignees.isNotEmpty)
                  _buildAssignees(task.assignees),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    Color labelColor;
    Color bgColor;

    switch (label.toLowerCase()) {
      case 'urgent':
      case 'high':
        labelColor = AppColors.errorRed;
        bgColor = AppColors.surfaceRose;
        break;
      case 'design':
        labelColor = AppColors.primaryViolet;
        bgColor = AppColors.surfaceIndigo;
        break;
      case 'backend':
        labelColor = AppColors.primaryTeal;
        bgColor = AppColors.surfaceEmerald;
        break;
      case 'frontend':
        labelColor = AppColors.infoBlue;
        bgColor = AppColors.surfaceBlue;
        break;
      default:
        labelColor = AppColors.textSecondary;
        bgColor = AppColors.surfaceSubtle;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 10.sp,
          color: labelColor,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildAssignees(List<String> assignees) {
    return SizedBox(
      height: 24.h,
      child: Stack(
        children: List.generate(
          assignees.length > 3 ? 3 : assignees.length,
          (index) => Positioned(
            right: index * 14.0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: CircleAvatar(
                radius: 11.r,
                backgroundColor: _getAvatarColor(index),
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

  Color _getAvatarColor(int index) {
    final colors = [
      AppColors.primaryBlue,
      AppColors.primaryViolet,
      AppColors.primaryTeal,
      AppColors.warningAmber,
    ];
    return colors[index % colors.length];
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
