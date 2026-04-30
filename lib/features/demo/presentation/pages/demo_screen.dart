import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:collab_task/core/config/constants/typography_constant.dart';
import 'package:collab_task/core/config/theme/app_colors_extension.dart';
import 'package:collab_task/core/error/error_page_helper.dart';
import 'package:collab_task/core/error/failure_messages.dart';
import 'package:collab_task/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:collab_task/features/demo/presentation/cubit/demo_cubit.dart';
import 'package:collab_task/features/demo/presentation/cubit/demo_state.dart';
import 'package:collab_task/features/shared/widget/network_auto_refresh_mixin.dart';
import 'package:shimmer/shimmer.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> with NetworkAutoRefreshMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetch());
  }

  Future<void> _fetch() => context.read<DemoCubit>().getDemos();

  @override
  void onNetworkRestored() => _fetch();

  @override
  Widget build(BuildContext context) {
    final error = context.select(
      (DemoCubit c) => c.state.maybeWhen(
        error: (f) => isFullScreenFailure(f) ? f : null,
        orElse: () => null,
      ),
    );
    final errorPage = fullScreenErrorPageOrNull(
      context,
      failure: error,
      onRetry: _fetch,
    );
    if (errorPage != null) return errorPage;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthCubit>().logout(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetch,
        child: BlocBuilder<DemoCubit, DemoState>(
          builder: (context, state) {
            return state.maybeWhen(
              loading: _Shimmer.new,
              loaded: (demos) => demos.isEmpty
                  ? const Center(child: Text('No demos yet'))
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      itemCount: demos.length,
                      separatorBuilder: (_, _) => SizedBox(height: 12.h),
                      itemBuilder: (_, i) {
                        final demo = demos[i];
                        return Card(
                          child: ListTile(
                            title: Text(demo.title),
                            subtitle: Text(
                              demo.body,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      },
                    ),
              error: (failure) => Center(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Text(
                    localizedFailureMessage(context, failure),
                    style: AppTypography.bodyMedium.copyWith(
                      color: context.appColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              orElse: () => const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }
}

class _Shimmer extends StatelessWidget {
  const _Shimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      itemCount: 6,
      separatorBuilder: (_, _) => SizedBox(height: 12.h),
      itemBuilder: (_, _) => Shimmer.fromColors(
        baseColor: context.appColors.dividerLight,
        highlightColor: context.appColors.surfaceAlt,
        child: Container(
          height: 80.h,
          decoration: BoxDecoration(
            color: context.appColors.dividerLight,
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }
}
