import 'package:flutter/material.dart';
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
        ChecklistItemEntity(id: 'check_1_1', title: 'Wireframes', completed: true),
        ChecklistItemEntity(id: 'check_1_2', title: 'Color palette', completed: false),
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
        ChecklistItemEntity(id: 'check_2_1', title: 'User table', completed: true),
        ChecklistItemEntity(id: 'check_2_2', title: 'Tasks table', completed: true),
        ChecklistItemEntity(id: 'check_2_3', title: 'Checklist items', completed: false),
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
        ChecklistItemEntity(id: 'check_3_1', title: 'Create task endpoint', completed: true),
        ChecklistItemEntity(id: 'check_3_2', title: 'Update task endpoint', completed: true),
        ChecklistItemEntity(id: 'check_3_3', title: 'Get task list endpoint', completed: false),
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
        ChecklistItemEntity(id: 'check_4_1', title: 'Splash screen', completed: true),
        ChecklistItemEntity(id: 'check_4_2', title: 'Login screen layout', completed: true),
        ChecklistItemEntity(id: 'check_4_3', title: 'Task board layout', completed: true),
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
    return Scaffold(
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
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30.r,
                    backgroundColor: Colors.white,
                    child: Text(
                      'JD',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'John Doe',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'john.doe@example.com',
                    style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard_outlined),
              title: const Text('Task Board'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text('Notifications'),
              onTap: () {
                Navigator.pop(context);
                context.pushNamed(MainRoutes.notificationName);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                context.pushNamed(MainRoutes.settingsName);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                // TODO: Implement logout
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _buildBoard(_currentTasks), 
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => CreateTaskModal(
              onCreated: (newTask) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Simulated creation of task: ${newTask.title}')),
                );
                Navigator.pop(context); 
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBoard(List<TaskEntity> tasks) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildColumn('To Do', TaskStatus.todo, tasks),
          _buildColumn('In Progress', TaskStatus.inProgress, tasks),
          _buildColumn('Done', TaskStatus.done, tasks),
        ],
      ),
    );
  }

  Widget _buildColumn(String title, TaskStatus status, List<TaskEntity> tasks) {
    final columnTasks = tasks.where((t) => t.status == status).toList();
    Color accentColor;

    switch (status) {
      case TaskStatus.todo:
        accentColor = AppColors.primaryIndigo;
        break;
      case TaskStatus.inProgress:
        accentColor = AppColors.warningAmber;
        break;
      case TaskStatus.done:
        accentColor = AppColors.successGreen;
        break;
    }

    return DragTarget<TaskEntity>(
      onWillAcceptWithDetails: (details) => details.data.status != status,
      onAcceptWithDetails: (details) {
        final taskToMove = details.data;
        setState(() {
          final taskIndex = _currentTasks.indexWhere((t) => t.id == taskToMove.id);
          if (taskIndex != -1) {
            _currentTasks[taskIndex] = taskToMove.copyWith(
              status: status,
              updatedAt: DateTime.now(),
            );
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Moved to ${title.toUpperCase()}'),
            backgroundColor: accentColor,
          ),
        );
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: 0.85.sw,
          margin: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: candidateData.isNotEmpty
                ? accentColor.withValues(alpha: 0.1)
                : AppColors.scaffoldBackground,
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Column Header
              Padding(
                padding: EdgeInsets.fromLTRB(16.r, 20.r, 16.r, 12.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8.w,
                          height: 24.h,
                          decoration: BoxDecoration(
                            color: accentColor,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18.sp,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: AppColors.softShadow,
                      ),
                      child: Text(
                        columnTasks.length.toString(),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Tasks List
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
                  itemCount: columnTasks.length,
                  itemBuilder: (context, index) {
                    final task = columnTasks[index];
                    return LongPressDraggable<TaskEntity>(
                      data: task,
                      feedback: SizedBox(
                        width: 0.75.sw,
                        child: TaskCard(task: task), 
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.3,
                        child: TaskCard(task: task), 
                      ),
                      child: TaskCard(task: task),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
