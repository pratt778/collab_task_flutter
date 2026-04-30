// lib/widgets/global_network_recovery_listener.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collab_task/core/app/app.dart';
import 'package:collab_task/core/extension/snackbar_extension.dart';
import 'package:collab_task/features/shared/cubits/network_cubits.dart';
import 'package:collab_task/l10n/gen/app_localizations.dart';

class GlobalNetworkRecoveryListener extends StatefulWidget {
  final Widget child;
  const GlobalNetworkRecoveryListener({required this.child, super.key});

  @override
  State<GlobalNetworkRecoveryListener> createState() =>
      _GlobalNetworkRecoveryListenerState();
}

class _GlobalNetworkRecoveryListenerState
    extends State<GlobalNetworkRecoveryListener> {
  StreamSubscription<void>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = context.read<NetworkCubit>().onRecoveryStream.listen(
      _showRecoveryBanner,
    );
  }

  void _showRecoveryBanner(_) {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      // Use navigator key to guarantee ScaffoldMessenger exists globally
      final context = navigatorKey.currentContext;
      if (context != null) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        context.showSnackbar(
          AppLocalizations.of(context).networkRestored,
          hasIcon: true,
          icon: Icons.wifi,
        );
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
