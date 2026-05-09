import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';

/// Safe wrapper around ChuckerDioInterceptor to prevent LateInitializationError
/// when errors occur before onRequest is called.
///
/// Chucker's interceptor declares _requestTime as late but doesn't initialize it
/// in onError(), causing crashes when connection errors occur before onRequest.
class SafeChuckerInterceptor extends Interceptor {
  late final ChuckerDioInterceptor _delegate;
  DateTime? _requestTime;

  SafeChuckerInterceptor() {
    _delegate = ChuckerDioInterceptor();
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    _requestTime = DateTime.now();
    return _delegate.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) async {
    return _delegate.onResponse(response, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Chucker's onError accesses _requestTime which may not be initialized.
    // Only call if we've seen a request. Otherwise, delegate to handler.
    if (_requestTime != null) {
      return _delegate.onError(err, handler);
    }
    handler.next(err);
  }
}
