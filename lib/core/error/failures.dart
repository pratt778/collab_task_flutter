import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];

  @override
  String toString() => '$runtimeType(message: $message, statusCode: $statusCode)';
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error occurred', int? statusCode])
      : super(message: message,statusCode: statusCode);
}
class ApiFailure extends Failure {
  const ApiFailure([String message = 'API error occurred', int? statusCode])
      : super(message: message,statusCode: statusCode);
}
class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'No internet connection', int? statusCode])
      : super(message: message,statusCode: statusCode);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([String message = 'Request timed out', int? statusCode])
      : super(message: message,statusCode: statusCode);
}

class AuthFailure extends Failure {
  const AuthFailure([String message = 'Authentication error occurred', int? statusCode])
      : super(message: message,statusCode: statusCode);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Unable to read from local storage'])
      : super(message: message);
}

class TokenExpiredFailure extends Failure {
  const TokenExpiredFailure([String message = 'Access token has expired'])
      : super(message: message);
}

class RefreshTokenExpiredFailure extends Failure {
  const RefreshTokenExpiredFailure(
      [String message = 'Refresh token has expired'])
      : super(message: message);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([String message = 'An unexpected error occurred'])
      : super(message: message);
}
