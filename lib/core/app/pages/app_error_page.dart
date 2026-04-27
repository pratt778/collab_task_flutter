import 'package:flutter/material.dart';
import 'package:flutter_clean_starter/features/shared/widget/custom_appbar.dart';
import 'package:flutter_clean_starter/l10n/gen/app_localizations.dart';

class AppErrorPage extends StatelessWidget {
  final String? title;
  final String? message;
  final VoidCallback? onRetry;

  const AppErrorPage({super.key, this.title, this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: CustomAppBar(title: l.errorPageAppBar, showBackButton: false),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 72,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 16),
              Text(
                title ?? l.somethingWentWrong,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(message ?? l.errUnexpected, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              if (onRetry != null)
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: Text(l.retry),
                )
              else
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Text(l.goToHome),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
