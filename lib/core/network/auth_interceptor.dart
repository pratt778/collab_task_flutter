import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AuthInterceptor extends Interceptor {
  final VoidCallback onUnauthorized;
  AuthInterceptor({required this.onUnauthorized});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('interceptor error is ${err.response?.statusCode}');
    if (err.response?.statusCode == 401) {
      debugPrint('inside 401');
      onUnauthorized();
    }
    handler.next(err); // let SafeRequest still map the error
  }
}
