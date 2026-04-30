import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:collab_task/core/app/router/app_router.dart';
import 'package:collab_task/features/tasks/domain/entities/task_entity.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          MainRoutes.taskDetailName,
          pathParameters: {'id': task.id},
        );
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 12.r),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (task.labels.isNotEmpty)
                Wrap(
                  spacing: 4.r,
                  children: task.labels.map((label) {
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 6.r, vertical: 2.r),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              SizedBox(height: 8.h),
              Text(
                task.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.check_box_outlined,
                          size: 14.r, color: Colors.grey),
                      SizedBox(width: 4.w),
                      Text(
                        '${task.checklist.where((i) => i.completed).length}/${task.checklist.length}',
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                  if (task.assignees.isNotEmpty)
                    CircleAvatar(
                      radius: 12.r,
                      backgroundColor: Colors.teal,
                      child: Text(
                        task.assignees.first[0].toUpperCase(),
                        style: TextStyle(fontSize: 10.sp, color: Colors.white),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
