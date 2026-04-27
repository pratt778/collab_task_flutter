import 'package:flutter/material.dart';

extension SnackbarExtensions on BuildContext {
  void showSnackbar(
    String message, {
    bool isError = false,
    bool hasIcon = false,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          if (hasIcon && icon != null) ...[
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      backgroundColor: isError ? Colors.red : Colors.green,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void hidepreviousSnackbar() {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
  }
}
