class CacheException implements Exception {
  final String message;

  const CacheException({this.message = 'Unable to read from local storage'});

  @override
  String toString() => 'CacheException: $message';
}

class AuthException implements Exception {
  final String message;

  const AuthException({this.message = 'Authentication error occurred'});

  @override
  String toString() => 'AuthException: $message';
}

class ApiException implements Exception {
  final String message;

  const ApiException(this.message);

  factory ApiException.emptyResponse() {
    return const ApiException('Something went wrong, please try again later');
  }

  @override
  String toString() => 'ApiException: $message';
}
