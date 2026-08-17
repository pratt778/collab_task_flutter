import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:collab_task/core/config/constants/color_constant.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'type': 'mention',
      'avatar': '👩‍💻',
      'user': 'Alice Johnson',
      'action': 'mentioned you in',
      'target': 'Build dashboard screen',
      'message': 'Check the latest design mockups',
      'timestamp': '5m ago',
      'read': false,
    },
    {
      'id': '2',
      'type': 'assigned',
      'avatar': '👨‍🔧',
      'user': 'Bob Smith',
      'action': 'assigned you to',
      'target': 'API Integration Task',
      'message': 'Est. time: 3 hours',
      'timestamp': '1h ago',
      'read': false,
    },
    {
      'id': '3',
      'type': 'status',
      'avatar': '👩‍🎨',
      'user': 'Carol Design',
      'action': 'changed status of',
      'target': 'UI Design Review',
      'message': 'New status: Done',
      'timestamp': '3h ago',
      'read': true,
    },
    {
      'id': '4',
      'type': 'comment',
      'avatar': '🧑‍💼',
      'user': 'David Project',
      'action': 'commented on',
      'target': 'Project Kickoff',
      'message': 'Team meeting rescheduled to Friday 2PM',
      'timestamp': '1d ago',
      'read': true,
    },
    {
      'id': '5',
      'type': 'deadline',
      'avatar': '⏰',
      'user': 'System',
      'action': 'reminder',
      'target': 'Performance Optimization',
      'message': 'Due in 2 days',
      'timestamp': '2d ago',
      'read': true,
    },
  ];

  int get unreadCount =>
      _notifications.where((n) => !(n['read'] as bool)).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textDark,
        title: Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20.sp),
        ),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: Text(
                'Mark all as read',
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
              ),
            ),
          SizedBox(width: 8.w),
        ],
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(32.r),
              decoration: const BoxDecoration(
                color: AppColors.surfaceSubtle,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                size: 64.sp,
                color: AppColors.textTertiary,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'No notifications',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'You\'re all caught up for now!',
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        return _buildNotificationTile(notification);
      },
    );
  }

  Widget _buildNotificationTile(Map<String, dynamic> notification) {
    final isUnread = !(notification['read'] as bool);
    final type = notification['type'] as String;

    return Material(
      color: isUnread ? AppColors.primaryBlue.withValues(alpha: 0.03) : Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            notification['read'] = true;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.borderSubtle, width: 0.5)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon container - Monochromatic
              Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  color: AppColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Center(
                  child: Icon(_getTypeIcon(type), size: 22.sp, color: AppColors.textSecondary),
                ),
              ),
              SizedBox(width: 16.w),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: notification['user'] as String,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark,
                            ),
                          ),
                          TextSpan(
                            text: ' ${notification['action'] as String} ',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          TextSpan(
                            text: notification['target'] as String,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      notification['message'] as String,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        if (isUnread)
                          Container(
                            width: 6.w,
                            height: 6.h,
                            margin: EdgeInsets.only(right: 8.w),
                            decoration: const BoxDecoration(color: AppColors.primaryBlue, shape: BoxShape.circle),
                          ),
                        Text(
                          notification['timestamp'] as String,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'mention': return Icons.alternate_email_rounded;
      case 'assigned': return Icons.person_add_alt_1_rounded;
      case 'status': return Icons.check_circle_outline_rounded;
      case 'comment': return Icons.chat_bubble_outline_rounded;
      case 'deadline': return Icons.access_time_rounded;
      default: return Icons.notifications_none_rounded;
    }
  }

  void _markAllAsRead() {
    setState(() {
      for (final notification in _notifications) {
        notification['read'] = true;
      }
    });
  }
}
