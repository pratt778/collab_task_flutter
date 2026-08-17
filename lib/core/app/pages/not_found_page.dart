import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:collab_task/core/app/router/app_router.dart';
import 'package:collab_task/features/shared/widget/custom_appbar.dart';
import 'package:collab_task/l10n/gen/app_localizations.dart';

class NotFoundPage extends StatelessWidget {
  final String? message;
  final int? statusCode;

  const NotFoundPage({super.key, this.message, this.statusCode});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: statusCode?.toString() ?? l.pageNotFoundAppBar,
        showBackButton: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.search_off_rounded, size: 72),
              const SizedBox(height: 16),
              Text(
                statusCode?.toString() ?? '',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Text(l.notFoundDescription, textAlign: TextAlign.center),
              if (message != null) ...[
                const SizedBox(height: 8),
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  debugPrint('Retry button pressed');
                  context.goNamed(MainRoutes.taskBoardName);
                },
                child: Text(l.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
