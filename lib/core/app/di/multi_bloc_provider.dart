import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_starter/core/app/di/injection_container.dart';
import 'package:flutter_clean_starter/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter_clean_starter/features/demo/presentation/cubit/demo_cubit.dart';
import 'package:flutter_clean_starter/features/locale/presentation/cubit/locale_cubit.dart';
import 'package:flutter_clean_starter/features/shared/cubits/network_cubits.dart';
import 'package:flutter_clean_starter/features/theme/presentation/cubit/theme_cubit.dart';

class MultipleBlocProviders extends StatelessWidget {
  const MultipleBlocProviders({super.key, required Widget child})
    : _child = child;

  final Widget _child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => sl<AuthCubit>()),
        BlocProvider<DemoCubit>(create: (_) => sl<DemoCubit>()),
        BlocProvider<ThemeCubit>(create: (_) => sl<ThemeCubit>()),
        BlocProvider<LocaleCubit>(create: (_) => sl<LocaleCubit>()),
        BlocProvider<NetworkCubit>(create: (_) => sl<NetworkCubit>()),
      ],
      child: _child,
    );
  }
}
