import 'package:dio/dio.dart';

/// Retries transient failures up to [_maxRetries] times with linear backoff.
///
/// Retry policy:
/// - `connectionError` / `connectionTimeout` — always retried (the request never
///   reached the server, so resending is safe regardless of HTTP method).
/// - `sendTimeout` / `receiveTimeout` — retried for **idempotent** verbs only
///   (GET / HEAD / OPTIONS), because the server may have processed the request
///   and a retry could double-submit on POST / PUT / DELETE.
/// - 5xx (`badResponse` with status 500–599) — retried for idempotent verbs only,
///   for the same reason.
/// - Everything else (4xx, 401, cancel, certificate errors) — never retried.
///
/// Attempt count is tracked on `RequestOptions.extra` so the same request isn't
/// retried infinitely if `dio.fetch` fails again.
class RetryInterceptor extends Interceptor {
  static const int _maxRetries = 2;
  static const List<Duration> _delays = [
    Duration(milliseconds: 250),
    Duration(milliseconds: 750),
  ];
  static const String _attemptKey = '_retry_attempt';

  final Dio dio;

  RetryInterceptor(this.dio);

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final attempt = (err.requestOptions.extra[_attemptKey] as int?) ?? 0;

    if (attempt >= _maxRetries || !_shouldRetry(err)) {
      return handler.next(err);
    }

    await Future<void>.delayed(_delays[attempt]);
    err.requestOptions.extra[_attemptKey] = attempt + 1;

    try {
      final response = await dio.fetch<dynamic>(err.requestOptions);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  bool _shouldRetry(DioException err) {
    final method = err.requestOptions.method.toUpperCase();
    final isIdempotent =
        method == 'GET' || method == 'HEAD' || method == 'OPTIONS';

    switch (err.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
        return true;
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return isIdempotent;
      case DioExceptionType.badResponse:
        final status = err.response?.statusCode ?? 0;
        return isIdempotent && status >= 500 && status < 600;
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return false;
    }
  }
}
