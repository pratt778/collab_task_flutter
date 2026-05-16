import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:collab_task/core/app/router/app_router.dart';
import 'package:collab_task/core/config/constants/color_constant.dart';
import 'package:collab_task/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:collab_task/features/auth/presentation/cubit/auth_state.dart';
import 'package:collab_task/features/workspaces/presentation/cubit/workspace_cubit.dart';
import 'package:collab_task/features/tasks/domain/entities/task_entity.dart';
import 'package:collab_task/features/tasks/presentation/cubit/task_list_cubit.dart';
import 'package:collab_task/features/tasks/presentation/cubit/task_list_state.dart';
import 'package:collab_task/features/tasks/presentation/widgets/task_card.dart';
import 'package:collab_task/features/tasks/presentation/widgets/create_task_modal.dart';
import 'package:collab_task/features/shared/widget/logout_dialog.dart';

class TaskBoardScreen extends StatefulWidget {
  const TaskBoardScreen({super.key});

  @override
  State<TaskBoardScreen> createState() => _TaskBoardScreenState();
}

class _TaskBoardScreenState extends State<TaskBoardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final workspaceCubit = context.read<WorkspaceCubit>();
      workspaceCubit.state.maybeWhen(
        loaded: (_, selected) {
          if (selected != null) {
            context.read<TaskListCubit>().getTasks(selected.id);
          }
        },
        orElse: workspaceCubit.loadWorkspaces,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkspaceCubit, WorkspaceState>(
      listener: (context, state) {
        state.maybeWhen(
          loaded: (workspaces, selected) {
            if (selected != null) {
              context.read<TaskListCubit>().getTasks(selected.id);
            }
          },
          orElse: () {},
        );
      },
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: BlocBuilder<WorkspaceCubit, WorkspaceState>(
              builder: (context, state) {
                final name = state.maybeWhen(
                  loaded: (_, selected) => selected?.name,
                  orElse: () => null,
                );
                return Text(name ?? 'CollabTask Board');
              },
            ),
            actions: [
              IconButton(
                onPressed: () => context.pushNamed(MainRoutes.notificationName),
                icon: const Icon(Icons.notifications_outlined),
              ),
              IconButton(
                onPressed: () {
                  final workspace = context.read<WorkspaceCubit>().state.maybeWhen(
                    loaded: (_, selected) => selected,
                    orElse: () => null,
                  );
                  if (workspace != null) {
                    context.read<TaskListCubit>().getTasks(workspace.id);
                  }
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
          drawer: _buildDrawer(context),
          body: BlocBuilder<TaskListCubit, TaskListState>(
            builder: (context, state) {
              return state.when(
                initial: () => const SizedBox.shrink(),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (failure) => Center(child: Text(failure.toString())),
                loaded: (tasks) => TabBarView(
                  children: [
                    _buildTaskList(context, tasks, TaskStatus.todo),
                    _buildTaskList(context, tasks, TaskStatus.inProgress),
                    _buildTaskList(context, tasks, TaskStatus.done),
                  ],
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showCreateTask(context),
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final userState = context.watch<AuthCubit>().state;
    final workspaceState = context.watch<WorkspaceCubit>().state;

    final userName = userState.maybeWhen(
      authenticated: (user) => user.displayName,
      orElse: () => 'User',
    );
    final email = userState.maybeWhen(
      authenticated: (user) => user.email,
      orElse: () => 'user@example.com',
    );

    return Drawer(
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
                    userName != null && userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  userName ?? 'User',
                  style: TextStyle(color: AppColors.textDark, fontSize: 18.sp, fontWeight: FontWeight.w800),
                ),
                Text(
                  email,
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp),
                ),
              ],
            ),
          ),
          
          // Workspace Section
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'WORKSPACES',
                  style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w900, color: AppColors.textTertiary, letterSpacing: 1),
                ),
                GestureDetector(
                  onTap: () => _showCreateWorkspaceDialog(context),
                  child: Icon(Icons.add_circle_outline_rounded, size: 18.sp, color: AppColors.primaryBlue),
                ),
              ],
            ),
          ),
          
          // Workspace List
          workspaceState.maybeWhen(
            loaded: (workspaces, selected) => Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ...workspaces.map((w) {
                    final isSelected = w.id == selected?.id;
                    return ListTile(
                      dense: true,
                      leading: Icon(
                        Icons.workspaces_outline,
                        size: 20.sp,
                        color: isSelected ? AppColors.primaryBlue : AppColors.textSecondary,
                      ),
                      title: Text(
                        w.name,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: isSelected ? AppColors.primaryBlue : AppColors.textDark,
                        ),
                      ),
                      trailing: isSelected ? Icon(Icons.check_circle_rounded, size: 16.sp, color: AppColors.primaryBlue) : null,
                      onTap: () {
                        context.read<WorkspaceCubit>().selectWorkspace(w);
                        Navigator.pop(context);
                      },
                    );
                  }),
                  const Divider(height: 32, color: AppColors.borderSubtle),
                  _buildDrawerItem(context, Icons.dashboard_outlined, 'Task Board', () => Navigator.pop(context)),
                  _buildDrawerItem(context, Icons.notifications_outlined, 'Notifications', () {
                    Navigator.pop(context);
                    context.pushNamed(MainRoutes.notificationName);
                  }),
                  _buildDrawerItem(context, Icons.settings_outlined, 'Settings', () {
                    Navigator.pop(context);
                    context.pushNamed(MainRoutes.settingsName);
                  }),
                ],
              ),
            ),
            orElse: () => const Expanded(child: Center(child: CircularProgressIndicator())),
          ),

          const Divider(height: 1, color: AppColors.borderSubtle),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.errorRed),
            title: const Text('Logout', style: TextStyle(color: AppColors.errorRed, fontWeight: FontWeight.w600)),
            onTap: () {
              Navigator.pop(context);
              showLogoutDialog(context, onConfirm: () => context.read<AuthCubit>().logout());
            },
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textDark, size: 22.sp),
      title: Text(title, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: AppColors.textDark)),
      onTap: onTap,
    );
  }

  Widget _buildTaskList(BuildContext context, List<TaskEntity> tasks, TaskStatus status) {
    final filteredTasks = tasks.where((t) => t.status == status).toList();
    if (filteredTasks.isEmpty) {
      return Center(
        child: Text('No tasks here', style: TextStyle(color: AppColors.textTertiary, fontSize: 16.sp)),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.all(20.r),
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        final task = filteredTasks[index];
        return TaskCard(
          task: task,
          onMove: () => _showMoveBottomSheet(context, task),
        );
      },
    );
  }

  void _showCreateTask(BuildContext context) {
    final user = context.read<AuthCubit>().state.maybeWhen(
      authenticated: (user) => user,
      orElse: () {
        debugPrint('❌ Create Task Failed: User not authenticated');
        return null;
      },
    );
    final workspace = context.read<WorkspaceCubit>().state.maybeWhen(
      loaded: (_, selected) => selected,
      orElse: () {
        debugPrint('❌ Create Task Failed: Workspace not loaded');
        return null;
      },
    );

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please wait for login to complete...')),
      );
      return;
    }

    if (workspace == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Still setting up your workspace. Please try in a second.')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => CreateTaskModal(
        userId: user.id,
        onCreated: (newTask) {
          final taskToCreate = newTask.copyWith(workspaceId: workspace.id);
          context.read<TaskListCubit>().createTask(taskToCreate);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showMoveBottomSheet(BuildContext context, TaskEntity task) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(20.r),
            child: Text('Move task to...', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800)),
          ),
          ...TaskStatus.values.map((status) => ListTile(
            leading: Icon(_getStatusIcon(status), color: _getStatusColor(status)),
            title: Text(_getStatusName(status)),
            enabled: task.status != status,
            onTap: () {
              context.read<TaskListCubit>().updateTask(task.copyWith(status: status, updatedAt: DateTime.now()));
              Navigator.pop(context);
            },
          )),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  void _showCreateWorkspaceDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        title: const Text('New Workspace', style: TextStyle(fontWeight: FontWeight.w800)),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Workspace Name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<WorkspaceCubit>().createWorkspace(name: controller.text);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, foregroundColor: Colors.white),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo: return Icons.radio_button_unchecked;
      case TaskStatus.inProgress: return Icons.radio_button_checked;
      case TaskStatus.done: return Icons.check_circle;
    }
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo: return AppColors.primaryIndigo;
      case TaskStatus.inProgress: return AppColors.warningAmber;
      case TaskStatus.done: return AppColors.successGreen;
    }
  }

  String _getStatusName(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo: return 'To Do';
      case TaskStatus.inProgress: return 'In Progress';
      case TaskStatus.done: return 'Done';
    }
  }
}
