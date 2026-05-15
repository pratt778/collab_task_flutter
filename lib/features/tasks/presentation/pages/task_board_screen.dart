import 'package:collab_task/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:collab_task/features/shared/widget/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:collab_task/core/app/router/app_router.dart';
import 'package:collab_task/core/config/constants/color_constant.dart';
import 'package:collab_task/features/tasks/domain/entities/task_entity.dart';
import 'package:collab_task/features/tasks/domain/entities/checklist_item_entity.dart';
import 'package:collab_task/features/tasks/presentation/widgets/task_card.dart';
import 'package:collab_task/features/tasks/presentation/widgets/create_task_modal.dart';

class TaskBoardScreen extends StatefulWidget {
  const TaskBoardScreen({super.key});

  @override
  State<TaskBoardScreen> createState() => _TaskBoardScreenState();
}

class _TaskBoardScreenState extends State<TaskBoardScreen> {
  static final List<TaskEntity> _mockTasks = [
    TaskEntity(
      id: 'task_1',
      title: 'Design login flow',
      description: 'Finalize wireframes and color scheme for the login screen.',
      status: TaskStatus.todo,
      assignees: const ['user_a'],
      dueDate: DateTime(2024, 5, 10),
      createdAt: DateTime(2024, 5),
      updatedAt: DateTime(2024, 5),
      labels: const ['design', 'urgent'],
      checklist: const [
        ChecklistItemEntity(
          id: 'check_1_1',
          title: 'Wireframes',
          completed: true,
        ),
        ChecklistItemEntity(
          id: 'check_1_2',
          title: 'Color palette',
          completed: false,
        ),
      ],
    ),
    TaskEntity(
      id: 'task_2',
      title: 'Set up database schema',
      description: 'Define tables and relationships for the project database.',
      status: TaskStatus.todo,
      assignees: const ['user_b'],
      dueDate: DateTime(2024, 5, 12),
      createdAt: DateTime(2024, 5, 2),
      updatedAt: DateTime(2024, 5, 2),
      labels: const ['backend', 'database'],
      checklist: const [
        ChecklistItemEntity(
          id: 'check_2_1',
          title: 'User table',
          completed: true,
        ),
        ChecklistItemEntity(
          id: 'check_2_2',
          title: 'Tasks table',
          completed: true,
        ),
        ChecklistItemEntity(
          id: 'check_2_3',
          title: 'Checklist items',
          completed: false,
        ),
      ],
    ),
    TaskEntity(
      id: 'task_3',
      title: 'Implement API endpoints',
      description: 'Develop REST APIs for task management.',
      status: TaskStatus.inProgress,
      assignees: const ['user_a', 'user_c'],
      dueDate: DateTime(2024, 5, 15),
      createdAt: DateTime(2024, 5, 3),
      updatedAt: DateTime(2024, 5, 5),
      labels: const ['backend', 'api'],
      checklist: const [
        ChecklistItemEntity(
          id: 'check_3_1',
          title: 'Create task endpoint',
          completed: true,
        ),
        ChecklistItemEntity(
          id: 'check_3_2',
          title: 'Update task endpoint',
          completed: true,
        ),
        ChecklistItemEntity(
          id: 'check_3_3',
          title: 'Get task list endpoint',
          completed: false,
        ),
      ],
    ),
    TaskEntity(
      id: 'task_4',
      title: 'Basic UI layout',
      description: 'Set up the basic screen layouts for the app.',
      status: TaskStatus.done,
      assignees: const ['user_b'],
      dueDate: DateTime(2024, 4, 28),
      createdAt: DateTime(2024, 4, 25),
      updatedAt: DateTime(2024, 4, 28),
      labels: const ['frontend', 'ui'],
      checklist: const [
        ChecklistItemEntity(
          id: 'check_4_1',
          title: 'Splash screen',
          completed: true,
        ),
        ChecklistItemEntity(
          id: 'check_4_2',
          title: 'Login screen layout',
          completed: true,
        ),
        ChecklistItemEntity(
          id: 'check_4_3',
          title: 'Task board layout',
          completed: true,
        ),
      ],
    ),
  ];

  List<TaskEntity> _currentTasks = [];

  @override
  void initState() {
    super.initState();
    _currentTasks = List.from(_mockTasks);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('CollabTask Board'),
          actions: [
            IconButton(
              onPressed: () => context.pushNamed(MainRoutes.notificationName),
              icon: const Icon(Icons.notifications_outlined),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _currentTasks = List.from(_mockTasks);
                });
              },
              icon: const Icon(Icons.refresh),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: AppColors.primaryBlue,
            labelColor: AppColors.primaryBlue,
            unselectedLabelColor: AppColors.textTertiary,
            tabs: [
              Tab(text: 'To Do'),
              Tab(text: 'In Progress'),
              Tab(text: 'Done'),
            ],
          ),
        ),
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(24.w, 64.h, 24.w, 32.h),
                width: double.infinity,
                decoration: const BoxDecoration(color: AppColors.surfaceSubtle),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 28.r,
                      backgroundColor: AppColors.primaryBlue,
                      child: Text(
                        'JD',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'John Doe',
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'john.doe@example.com',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  children: [
                    _buildDrawerItem(
                      Icons.dashboard_outlined,
                      'Task Board',
                      () => Navigator.pop(context),
                    ),
                    _buildDrawerItem(
                      Icons.notifications_outlined,
                      'Notifications',
                      () {
                        Navigator.pop(context);
                        context.pushNamed(MainRoutes.notificationName);
                      },
                    ),
                    _buildDrawerItem(Icons.settings_outlined, 'Settings', () {
                      Navigator.pop(context);
                      context.pushNamed(MainRoutes.settingsName);
                    }),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.borderSubtle),
              ListTile(
                leading: const Icon(Icons.logout, color: AppColors.errorRed),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    color: AppColors.errorRed,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () => showLogoutDialog(
                  context,
                  onConfirm: () {
                    context.read<AuthCubit>().logout();
                  },
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            _buildTaskList(TaskStatus.todo),
            _buildTaskList(TaskStatus.inProgress),
            _buildTaskList(TaskStatus.done),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => CreateTaskModal(
                onCreated: (newTask) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Simulated creation: ${newTask.title}'),
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildTaskList(TaskStatus status) {
    final tasks = _currentTasks.where((t) => t.status == status).toList();
    if (tasks.isEmpty) {
      return Center(
        child: Text(
          'No tasks here',
          style: TextStyle(color: AppColors.textTertiary, fontSize: 16.sp),
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 20.r),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskCard(task: task, onMove: () => _showMoveBottomSheet(task));
      },
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textDark, size: 22.sp),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
      ),
      onTap: onTap,
    );
  }

  void _showMoveBottomSheet(TaskEntity task) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(20.r),
            child: Text(
              'Move task to...',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800),
            ),
          ),
          ...TaskStatus.values.map(
            (status) => ListTile(
              leading: Icon(
                _getStatusIcon(status),
                color: _getStatusColor(status),
              ),
              title: Text(_getStatusName(status)),
              enabled: task.status != status,
              onTap: () {
                setState(() {
                  final taskIndex = _currentTasks.indexWhere(
                    (t) => t.id == task.id,
                  );
                  if (taskIndex != -1) {
                    _currentTasks[taskIndex] = task.copyWith(
                      status: status,
                      updatedAt: DateTime.now(),
                    );
                  }
                });
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  IconData _getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return Icons.radio_button_unchecked;
      case TaskStatus.inProgress:
        return Icons.radio_button_checked;
      case TaskStatus.done:
        return Icons.check_circle;
    }
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return AppColors.primaryIndigo;
      case TaskStatus.inProgress:
        return AppColors.warningAmber;
      case TaskStatus.done:
        return AppColors.successGreen;
    }
  }

  String _getStatusName(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return 'To Do';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.done:
        return 'Done';
    }
  }
}
