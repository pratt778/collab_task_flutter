import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_clean_starter/core/app/router/app_router.dart';
import 'package:flutter_clean_starter/l10n/gen/app_localizations.dart';

class UnauthorizedPage extends StatelessWidget {
  final String? message;
  final VoidCallback? onLogin;

  const UnauthorizedPage({super.key, this.message, this.onLogin});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.unauthorizedAppBar)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.lock_outline_rounded,
                size: 72,
                color: Colors.orange,
              ),
              const SizedBox(height: 16),
              Text(
                l.accessDenied,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message ?? l.unauthorizedMessage,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed:
                    onLogin ??
                    () {
                      context.goNamed(MainRoutes.authName);
                    },
                icon: const Icon(Icons.login),
                label: Text(l.goToLogin),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
