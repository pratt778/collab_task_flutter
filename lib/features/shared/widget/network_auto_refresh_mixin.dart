// lib/mixins/network_auto_refresh_mixin.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_starter/features/shared/cubits/network_cubits.dart';

mixin NetworkAutoRefreshMixin<T extends StatefulWidget> on State<T> {
  StreamSubscription<void>? _recoverySub;

  /// 📝 Override this in your screen to define what to reload
  void onNetworkRestored();

  @override
  void initState() {
    super.initState();
    _recoverySub = context.read<NetworkCubit>().onRecoveryStream.listen((_) {
      if (mounted) onNetworkRestored();
    });
  }

  @override
  void dispose() {
    _recoverySub?.cancel();
    super.dispose();
  }
}