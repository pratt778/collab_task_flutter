import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:collab_task/core/app/di/injection_container.dart';
import 'package:collab_task/core/error/error_page_helper.dart';
import 'package:collab_task/core/error/failure_messages.dart';
import 'package:collab_task/features/shared/widget/network_auto_refresh_mixin.dart';
import 'package:collab_task/features/tasks/domain/entities/task_entity.dart';
import 'package:collab_task/features/tasks/presentation/cubit/task_list_cubit.dart';
import 'package:collab_task/features/tasks/presentation/cubit/task_list_state.dart';
import 'package:collab_task/features/tasks/presentation/widgets/task_card.dart';

class TaskBoardScreen extends StatefulWidget {
  const TaskBoardScreen({super.key});

  @override
  State<TaskBoardScreen> createState() => _TaskBoardScreenState();
}

class _TaskBoardScreenState extends State<TaskBoardScreen>
    with NetworkAutoRefreshMixin {
  late final TaskListCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<TaskListCubit>();
    _fetch();
  }

  void _fetch() => _cubit.getTasks();

  @override
  void onNetworkRestored() => _fetch();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('CollabTask Board'),
          actions: [
            IconButton(
              onPressed: _fetch,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: BlocBuilder<TaskListCubit, TaskListState>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const Center(child: CircularProgressIndicator()),
              loaded: _buildBoard,
              error: (failure) {
                final page = fullScreenErrorPageOrNull(
                  context,
                  failure: failure,
                  onRetry: _fetch,
                );
                if (page != null) return page;
                return Center(
                  child: Text(localizedFailureMessage(context, failure)),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO: Open Create Task Modal
          },
          child: const Icon(Icons.add),
        ),
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

    return Container(
      width: 0.8.sw,
      margin: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(12.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 2.r),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    columnTasks.length.toString(),
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 8.r),
              itemCount: columnTasks.length,
              itemBuilder: (context, index) {
                return TaskCard(task: columnTasks[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
