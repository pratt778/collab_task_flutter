import 'package:collab_task/features/tasks/presentation/cubit/task_detail_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collab_task/core/app/di/injection_container.dart';
import 'package:collab_task/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:collab_task/features/locale/presentation/cubit/locale_cubit.dart';
import 'package:collab_task/features/shared/cubits/network_cubits.dart';
import 'package:collab_task/features/theme/presentation/cubit/theme_cubit.dart';
import 'package:collab_task/features/workspaces/presentation/cubit/workspace_cubit.dart';
import 'package:collab_task/features/tasks/presentation/cubit/task_list_cubit.dart';

class MultipleBlocProviders extends StatelessWidget {
  const MultipleBlocProviders({super.key, required Widget child})
    : _child = child;

  final Widget _child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => sl<AuthCubit>()),
        BlocProvider<ThemeCubit>(create: (_) => sl<ThemeCubit>()),
        BlocProvider<LocaleCubit>(create: (_) => sl<LocaleCubit>()),
        BlocProvider<NetworkCubit>(create: (_) => sl<NetworkCubit>()),
        BlocProvider<WorkspaceCubit>(create: (_) => sl<WorkspaceCubit>()),
        BlocProvider<TaskListCubit>(create: (_) => sl<TaskListCubit>()),
        BlocProvider<TaskDetailCubit>(create: (_) => sl<TaskDetailCubit>()),
      ],
      child: _child,
    );
  }
}
