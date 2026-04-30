import 'package:flutter/widgets.dart';
import 'package:collab_task/core/error/failures.dart';
import 'package:collab_task/l10n/gen/app_localizations.dart';

/// Resolves a [Failure] to a user-facing, locale-aware message.
///
/// `ApiFailure.message` is passed through because backend error strings are
/// already user-readable (e.g. "Invalid OTP"). Every other failure type maps
/// to a localized ARB key.
String localizedFailureMessage(BuildContext context, Failure failure) {
  final l = AppLocalizations.of(context);
  return switch (failure) {
    NetworkFailure() => l.errNoInternet,
    TimeoutFailure() => l.errTimeout,
    ServerFailure() => l.errServer,
    AuthFailure() => l.errAuth,
    TokenExpiredFailure() ||
    RefreshTokenExpiredFailure() => l.errSessionExpired,
    CacheFailure() => l.errCache,
    UnexpectedFailure() => l.errUnexpected,
    ApiFailure() => failure.message,
  };
}
