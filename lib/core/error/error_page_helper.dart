import 'package:flutter/widgets.dart';
import 'package:flutter_clean_starter/core/app/pages/app_error_page.dart';
import 'package:flutter_clean_starter/core/app/pages/not_found_page.dart';
import 'package:flutter_clean_starter/core/error/failure_messages.dart';
import 'package:flutter_clean_starter/core/error/failures.dart';

/// True when [failure] should swap the whole scaffold for a full-screen page
/// (no internet OR backend says 404). Anything else stays inline.
bool isFullScreenFailure(Failure failure) =>
    failure is NetworkFailure || failure.statusCode == 404;

/// Returns the appropriate full-screen error page for [failure], or `null` if
/// [failure] is `null`. 404s become [NotFoundPage]; everything else becomes
/// [AppErrorPage] with [onRetry] when supplied.
///
/// Usage:
/// ```dart
/// final f = context.select((SomeCubit c) => c.state.maybeWhen(
///   error: (f) => isFullScreenFailure(f) ? f : null,
///   orElse: () => null,
/// ));
/// final page = fullScreenErrorPageOrNull(context, failure: f, onRetry: _fetch);
/// if (page != null) return page;
/// ```
Widget? fullScreenErrorPageOrNull(
  BuildContext context, {
  required Failure? failure,
  VoidCallback? onRetry,
}) {
  if (failure == null) return null;
  final message = localizedFailureMessage(context, failure);
  if (failure.statusCode == 404) {
    return NotFoundPage(message: message, statusCode: failure.statusCode!);
  }
  return AppErrorPage(message: message, onRetry: onRetry);
}
