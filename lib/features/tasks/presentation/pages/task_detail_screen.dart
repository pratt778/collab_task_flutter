import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:collab_task/core/app/router/app_router.dart';
import 'package:collab_task/core/config/constants/color_constant.dart';

class TaskDetailScreen extends StatefulWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final _checklistController = TextEditingController();

  @override
  void dispose() {
    _checklistController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {},
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: _buildDetail(),
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
              pathParameters: {'id': widget.taskId},
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

  Widget _buildDetail() {
    // Mock task data for UI preview
    final checklist = [
      {'id': '1', 'title': 'Design modern mockups', 'completed': true},
      {'id': '2', 'title': 'Team UI review session', 'completed': true},
      {'id': '3', 'title': 'Implement aesthetic components', 'completed': false},
      {'id': '4', 'title': 'Responsive testing', 'completed': false},
    ];

    final completedCount = checklist.where((e) => e['completed'] as bool).length;
    final totalCount = checklist.length;
    final progress = completedCount / totalCount;

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
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        'IN PROGRESS',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    Icon(Icons.edit_note_rounded, color: Colors.white70, size: 24.sp),
                  ],
                ),
                SizedBox(height: 20.h),
                Text(
                  'Build modern dashboard screen',
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Create a responsive dashboard with real-time updates and aesthetic charts.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white.withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                ),
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
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
            ),
          ),
          
          SizedBox(height: 24.h),

          // Checklist Items
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: AppColors.softShadow,
            ),
            child: Column(
              children: [
                ...checklist.asMap().entries.map<Widget>((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isLast = index == checklist.length - 1;

                  return _buildChecklistItem(
                    title: item['title'] as String,
                    completed: item['completed'] as bool,
                    onToggle: () => debugPrint('Toggle: ${item['id']}'),
                    onDelete: () => debugPrint('Delete: ${item['id']}'),
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
                  color: completed ? AppColors.successGreen : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: completed ? AppColors.successGreen : AppColors.borderMedium,
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
                    color: completed ? AppColors.textTertiary : AppColors.textDark,
                    decoration: completed ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline_rounded, size: 20.sp, color: AppColors.textTertiary),
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
          Icon(Icons.add_circle_outline_rounded, color: AppColors.primaryBlue, size: 24.sp),
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
            ),
          ),
          IconButton(
            icon: Icon(Icons.send_rounded, color: AppColors.primaryBlue, size: 20.sp),
            onPressed: () {
              if (_checklistController.text.isNotEmpty) {
                _checklistController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}

