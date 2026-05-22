import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:collab_task/l10n/gen/app_localizations.dart';
import 'package:collab_task/core/app/router/app_router.dart';
import 'package:collab_task/core/config/constants/color_constant.dart';
import 'package:collab_task/core/error/failure_messages.dart';
import 'package:collab_task/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:collab_task/features/auth/presentation/cubit/auth_state.dart';
import 'package:collab_task/features/workspaces/domain/entities/workspace_entity.dart';
import 'package:collab_task/features/workspaces/presentation/cubit/workspace_cubit.dart';
import 'package:collab_task/features/tasks/domain/entities/task_entity.dart';
import 'package:collab_task/features/tasks/presentation/cubit/task_list_cubit.dart';
import 'package:collab_task/features/tasks/presentation/cubit/task_list_state.dart';
import 'package:collab_task/features/tasks/presentation/widgets/task_card.dart';
import 'package:collab_task/features/tasks/presentation/widgets/create_task_modal.dart';
import 'package:collab_task/features/shared/widget/logout_dialog.dart';
import 'package:collab_task/core/config/theme/app_colors_extension.dart';

class TaskBoardScreen extends StatefulWidget {
  const TaskBoardScreen({super.key});

  @override
  State<TaskBoardScreen> createState() => _TaskBoardScreenState();
}

class _TaskBoardScreenState extends State<TaskBoardScreen> {
  String? _loadedWorkspaceId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final workspaceCubit = context.read<WorkspaceCubit>();
      workspaceCubit.state.maybeWhen(
        loaded: (workspaces, selected, allUsers, currentMembers) => _loadTasksForWorkspace(selected),
        orElse: workspaceCubit.loadWorkspaces,
      );
    });
  }

  void _loadTasksForWorkspace(
    WorkspaceEntity? workspace, {
    bool force = false,
  }) {
    if (workspace == null) return;
    if (!force && _loadedWorkspaceId == workspace.id) return;

    _loadedWorkspaceId = workspace.id;
    context.read<TaskListCubit>().getTasks(workspace.id);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l = AppLocalizations.of(context)!;
    return BlocListener<WorkspaceCubit, WorkspaceState>(
      listener: (context, state) {
        state.maybeWhen(
          loaded: (workspaces, selected, allUsers, currentMembers) => _loadTasksForWorkspace(selected),
          orElse: () {},
        );
      },
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: colors.scaffold,
          appBar: AppBar(
            backgroundColor: colors.surface,
            foregroundColor: colors.textPrimary,
            title: BlocBuilder<WorkspaceCubit, WorkspaceState>(
              builder: (context, state) {
                return state.maybeWhen(
                  loaded: (workspaces, selected, allUsers, currentMembers) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selected?.name ?? l.appName,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          color: colors.textPrimary,
                        ),
                      ),
                      if (currentMembers.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: Row(
                            children: [
                              ...currentMembers.take(4).map((member) {
                                final profile = member['profiles'] as Map<String, dynamic>;
                                final name = profile['display_name'] as String? ?? 'U';
                                return Padding(
                                  padding: EdgeInsets.only(right: 4.w),
                                  child: CircleAvatar(
                                    radius: 8.r,
                                    backgroundColor: colors.secondary,
                                    child: Text(
                                      name[0].toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 8.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                              if (currentMembers.length > 4)
                                Text(
                                  '+${currentMembers.length - 4}',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: colors.textTertiary,
                                  ),
                                ),
                              SizedBox(width: 4.w),
                              Text(
                                '${currentMembers.length} ${l.members.toLowerCase()}',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: colors.textTertiary,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  orElse: () => Text(l.appName, style: TextStyle(color: colors.textPrimary)),
                );
              },
            ),
            actions: [
              IconButton(
                onPressed: () => _showInviteMemberDialog(context),
                icon: Icon(Icons.person_add_alt_1_outlined, color: colors.textPrimary),
                tooltip: l.inviteMember,
              ),
              IconButton(
                onPressed: () => context.pushNamed(MainRoutes.notificationName),
                icon: Icon(Icons.notifications_outlined, color: colors.textPrimary),
              ),
              IconButton(
                onPressed: () {
                  final workspace = context
                      .read<WorkspaceCubit>()
                      .state
                      .maybeWhen(
                        loaded: (workspaces, selected, allUsers, currentMembers) => selected,
                        orElse: () => null,
                      );
                  _loadTasksForWorkspace(workspace, force: true);
                },
                icon: Icon(Icons.refresh, color: colors.textPrimary),
              ),
            ],
            bottom: TabBar(
              indicatorColor: colors.primary,
              labelColor: colors.primary,
              unselectedLabelColor: colors.textTertiary,
              tabs: [
                Tab(text: l.todo),
                Tab(text: l.inProgress),
                Tab(text: l.done),
              ],
            ),
          ),
          drawer: _buildDrawer(context, colors),
          body: _buildBody(context, colors),
          floatingActionButton: FloatingActionButton(
            backgroundColor: colors.primary,
            foregroundColor: Colors.white,
            onPressed: () => _showCreateTask(context),
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppColorsExtension colors) {
    return BlocBuilder<TaskListCubit, TaskListState>(
      builder: (context, state) {
        return state.when(
          initial: () => Center(child: CircularProgressIndicator(color: colors.primary)),
          loading: () => Center(child: CircularProgressIndicator(color: colors.primary)),
          error: (failure) => _buildErrorState(
            context,
            colors: colors,
            message: localizedFailureMessage(context, failure),
            onRetry: () {
              final workspace = context.read<WorkspaceCubit>().state.maybeWhen(
                    loaded: (workspaces, selected, allUsers, currentMembers) => selected,
                    orElse: () => null,
                  );
              _loadTasksForWorkspace(workspace, force: true);
            },
          ),
          loaded: (tasks) => TabBarView(
            children: [
              _buildTaskList(context, tasks, TaskStatus.todo, colors),
              _buildTaskList(context, tasks, TaskStatus.inProgress, colors),
              _buildTaskList(context, tasks, TaskStatus.done, colors),
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorState(
    BuildContext context, {
    required AppColorsExtension colors,
    required String message,
    required VoidCallback onRetry,
  }) {
    return Center(
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
                color: colors.textSecondary,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.h),
            FilledButton.icon(
              onPressed: onRetry,
              style: FilledButton.styleFrom(backgroundColor: colors.primary),
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              label: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, AppColorsExtension colors) {
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
      backgroundColor: colors.surface,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(24.w, 64.h, 24.w, 32.h),
            width: double.infinity,
            decoration: BoxDecoration(color: colors.surfaceAlt),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28.r,
                  backgroundColor: colors.primary,
                  child: Text(
                    userName != null && userName.isNotEmpty
                        ? userName[0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  userName ?? 'User',
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  email,
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 13.sp,
                  ),
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
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w900,
                    color: colors.textTertiary,
                    letterSpacing: 1,
                  ),
                ),
                GestureDetector(
                  onTap: () => _showCreateWorkspaceDialog(context),
                  child: Icon(
                    Icons.add_circle_outline_rounded,
                    size: 18.sp,
                    color: colors.primary,
                  ),
                ),
              ],
            ),
          ),

          // Workspace List
          workspaceState.maybeWhen(
            loaded: (workspaces, selected, allUsers, currentMembers) {
              final currentUserId = context.read<AuthCubit>().state.maybeWhen(
                    authenticated: (u) => u.id,
                    orElse: () => '',
                  );

              return Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ...workspaces.map((w) {
                      final isSelected = w.id == selected?.id;
                      final isOwner = w.ownerId == currentUserId;

                      return ListTile(
                        dense: true,
                        leading: Icon(
                          Icons.workspaces_outline,
                          size: 20.sp,
                          color: isSelected
                              ? colors.primary
                              : colors.textSecondary,
                        ),
                        title: Text(
                          w.name,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight:
                                isSelected ? FontWeight.w800 : FontWeight.w600,
                            color: isSelected
                                ? colors.primary
                                : colors.textPrimary,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isOwner && workspaces.length > 1)
                              IconButton(
                                icon: Icon(
                                  Icons.delete_outline_rounded,
                                  size: 18.sp,
                                  color: colors.textSecondary,
                                ),
                                onPressed: () =>
                                    _showDeleteWorkspaceDialog(context, w),
                              ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle_rounded,
                                size: 16.sp,
                                color: colors.primary,
                              ),
                          ],
                        ),
                        onTap: () {
                          context.read<WorkspaceCubit>().selectWorkspace(w);
                          Navigator.pop(context);
                        },
                      );
                    }),
                    Divider(height: 32, color: colors.divider),

                    // Team Members Section
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      child: Text(
                        'MEMBERS',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w900,
                          color: colors.textTertiary,
                          letterSpacing: 1,
                        ),
                      ),
                    ),

                    ...currentMembers.map((member) {
                      final profile = member['profiles'] as Map<String, dynamic>;
                      final name = profile['display_name'] as String? ?? 'User';
                      final role = member['role'] as String? ?? 'member';

                      return ListTile(
                        dense: true,
                        leading: CircleAvatar(
                          radius: 12.r,
                          backgroundColor: colors.surfaceAlt,
                          child: Text(
                            name[0].toUpperCase(),
                            style: TextStyle(
                                fontSize: 10.sp, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          name,
                          style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary),
                        ),
                        subtitle: Text(
                          role.toUpperCase(),
                          style: TextStyle(
                              fontSize: 9.sp, color: colors.textTertiary),
                        ),
                      );
                    }),

                    Divider(height: 16, color: Colors.transparent),

                    _buildDrawerItem(
                      context,
                      colors,
                      Icons.dashboard_outlined,
                      'Task Board',
                      () => Navigator.pop(context),
                    ),
                    _buildDrawerItem(
                      context,
                      colors,
                      Icons.notifications_outlined,
                      'Notifications',
                      () {
                        Navigator.pop(context);
                        context.pushNamed(MainRoutes.notificationName);
                      },
                    ),
                    _buildDrawerItem(
                      context,
                      colors,
                      Icons.settings_outlined,
                      'Settings',
                      () {
                        Navigator.pop(context);
                        context.pushNamed(MainRoutes.settingsName);
                      },
                    ),
                  ],
                ),
              );
            },
            orElse: () => Expanded(
              child: Center(
                  child: CircularProgressIndicator(color: colors.primary)),
            ),
          ),

          Divider(height: 1, color: colors.divider),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red.shade400),
            title: Text(
              'Logout',
              style: TextStyle(
                color: Colors.red.shade400,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              showLogoutDialog(
                context,
                onConfirm: () => context.read<AuthCubit>().logout(),
              );
            },
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    AppColorsExtension colors,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: colors.textPrimary, size: 22.sp),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildTaskList(
    BuildContext context,
    List<TaskEntity> tasks,
    TaskStatus status,
    AppColorsExtension colors,
  ) {
    final filteredTasks = tasks.where((t) => t.status == status).toList();
    if (filteredTasks.isEmpty) {
      return Center(
        child: Text(
          'No tasks here',
          style: TextStyle(color: colors.textTertiary, fontSize: 16.sp),
        ),
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
      loaded: (workspaces, selected, allUsers, currentMembers) => selected,
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
        const SnackBar(
          content: Text(
            'Still setting up your workspace. Please try in a second.',
          ),
        ),
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
                context.read<TaskListCubit>().updateTask(
                  task.copyWith(status: status, updatedAt: DateTime.now()),
                );
                Navigator.pop(context);
              },
            ),
          ),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        title: const Text(
          'New Workspace',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Workspace Name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<WorkspaceCubit>().createWorkspace(
                  name: controller.text,
                );
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showDeleteWorkspaceDialog(BuildContext context, WorkspaceEntity workspace) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        title: Text('Delete "${workspace.name}"?'),
        content: const Text(
          'This will permanently remove the workspace and all its tasks. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<WorkspaceCubit>().deleteWorkspace(workspace.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Workspace deleted')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showInviteMemberDialog(BuildContext context) {
    final workspaceCubit = context.read<WorkspaceCubit>();
    final state = workspaceCubit.state;

    state.maybeWhen(
      loaded: (workspaces, selected, allUsers, currentMembers) {
        String? selectedEmail;

        showDialog(
          context: context,
          builder: (context) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
                title: const Text(
                  'Invite Member',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Select a user to invite to this workspace.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    SizedBox(height: 20.h),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Select User',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person_search),
                      ),
                      initialValue: selectedEmail,
                      items: allUsers.map((user) {
                        return DropdownMenuItem<String>(
                          value: user.email,
                          child: Text(
                            user.displayName ?? user.email,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => selectedEmail = value);
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: selectedEmail == null
                        ? null
                        : () {
                            workspaceCubit.addMember(selectedEmail!);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Inviting $selectedEmail...'),
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Invite'),
                  ),
                ],
              );
            },
          ),
        );
      },
      orElse: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Wait for workspaces to load...')),
        );
      },
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
