import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:collab_task/core/config/constants/app_constant.dart';
import 'package:collab_task/core/error/exceptions.dart';
import 'package:collab_task/core/helper/secure_storage_helper.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ApiHelper {
  final Dio dio;

  ApiHelper({required this.dio});

  final Map<String, CancelToken> _cancelTokens = {};
  ChuckerDioInterceptor? _chuckerInterceptor;

  Future<void> init() async {
    _updateChuckerState();
  }

  void updateChuckerState() {
    _updateChuckerState();
  }

  void _updateChuckerState() {
    if (AppConfig.isProduction) return;

    final enabled = SecureStorageHelper().getChuckerEnabled();
    ChuckerFlutter.showOnRelease = enabled;

    final hasInterceptor =
        _chuckerInterceptor != null &&
        dio.interceptors.contains(_chuckerInterceptor);

    if (enabled && !hasInterceptor) {
      _chuckerInterceptor = ChuckerDioInterceptor();
      dio.interceptors.add(_chuckerInterceptor!);
    } else if (!enabled && hasInterceptor) {
      dio.interceptors.remove(_chuckerInterceptor);
      _chuckerInterceptor = null;
    }
  }

  String buildRequestKey(
    String method,
    String path, {
    Map<String, dynamic>? queryParams,
  }) {
    return '$method::$path::${jsonEncode(queryParams ?? {})}';
  }

  CancelToken _createCancelToken(String requestKey) {
    final token = CancelToken();
    _cancelTokens[requestKey] = token;
    return token;
  }

  void cancelRequest(String requestKey, {String reason = 'Cancelled by user'}) {
    final token = _cancelTokens[requestKey];
    if (token != null && !token.isCancelled) {
      token.cancel(reason);
      _cancelTokens.remove(requestKey);
      log('Request [$requestKey] cancelled manually.');
    }
  }

  Future<Map<String, dynamic>> _buildHeaders({
    String? authHeader,
    String? acceptHeader,
    bool isMultipart = false,
    Map<String, dynamic>? extraHeaders,
  }) async {
    final secureStorage = SecureStorageHelper();
    final packageInfo = await PackageInfo.fromPlatform();
    final deviceToken = secureStorage.getDeviceToken();
    final locale = secureStorage.getLocale();
    debugPrint('deviceToken: $deviceToken');
    final token = secureStorage.getToken();
    // final String token =
    //     '${getOrgName(secureStorage.getToken())}::fdkfjdklfjdlkfdjlkfdl';
    debugPrint('token: $token');
    final headers = <String, dynamic>{
      'osType': Platform.isAndroid
          ? 'android'
          : Platform.isIOS
          ? 'ios'
          : Platform.operatingSystem,
      'processorCount': Platform.numberOfProcessors,
      'osVersion': Platform.operatingSystemVersion,
      'dartVersion': Platform.version,
      'appVersion': packageInfo.version,
      'deviceToken': deviceToken,
      HttpHeaders.authorizationHeader:
          (authHeader != null && authHeader.trim().isNotEmpty)
          ? authHeader
          : 'Bearer $token',
      HttpHeaders.contentTypeHeader: isMultipart
          ? 'multipart/form-data'
          : 'application/json',
      HttpHeaders.acceptLanguageHeader: locale,
      HttpHeaders.acceptHeader: acceptHeader ?? 'application/json',
    };

    if (extraHeaders != null && extraHeaders.isNotEmpty) {
      headers.addAll(extraHeaders);
    }

    return headers;
  }

  void _validateResponse(Response response) {
    if (response.data == null) {
      throw ApiException.emptyResponse();
    }
  }

  Future<Response<T>> get<T>({
    required String path,
    Map<String, dynamic> queryParams = const {},
    String? authHeader,
    String? acceptHeader,
    Map<String, dynamic>? extraHeaders,
    Options? options,
    String? requestKey,
  }) async {
    final key =
        requestKey ?? buildRequestKey('GET', path, queryParams: queryParams);
    final cancelToken = _createCancelToken(key);

    final headers = await _buildHeaders(
      authHeader: authHeader,
      acceptHeader: acceptHeader,
      extraHeaders: extraHeaders,
    );

    final response = await dio.get<T>(
      path,
      queryParameters: queryParams,
      cancelToken: cancelToken,
      options: (options ?? Options()).copyWith(headers: headers),
    );

    _validateResponse(response);
    return response;
  }

  Future<Response<T>> post<T>({
    required String path,
    required dynamic body,
    Map<String, dynamic> queryParams = const {},
    String? authHeader,
    String? acceptHeader,
    bool isMultipart = false,
    Map<String, dynamic>? extraHeaders,
    Options? options,
    String? requestKey,
  }) async {
    final key =
        requestKey ?? buildRequestKey('POST', path, queryParams: queryParams);
    final cancelToken = _createCancelToken(key);

    final headers = await _buildHeaders(
      authHeader: authHeader,
      acceptHeader: acceptHeader,
      isMultipart: isMultipart,
      extraHeaders: extraHeaders,
    );

    final response = await dio.post<T>(
      path,
      data: body,
      queryParameters: queryParams,
      cancelToken: cancelToken,
      options: (options ?? Options()).copyWith(headers: headers),
    );

    _validateResponse(response);
    return response;
  }

  Future<Response<T>> put<T>({
    required String path,
    required dynamic body,
    Map<String, dynamic> queryParams = const {},
    String? authHeader,
    String? acceptHeader,
    bool isMultipart = false,
    Map<String, dynamic>? extraHeaders,
    Options? options,
    String? requestKey,
  }) async {
    final key =
        requestKey ?? buildRequestKey('PUT', path, queryParams: queryParams);
    final cancelToken = _createCancelToken(key);

    final headers = await _buildHeaders(
      authHeader: authHeader,
      acceptHeader: acceptHeader,
      isMultipart: isMultipart,
      extraHeaders: extraHeaders,
    );

    final response = await dio.put<T>(
      path,
      data: body,
      queryParameters: queryParams,
      cancelToken: cancelToken,
      options: (options ?? Options()).copyWith(headers: headers),
    );

    _validateResponse(response);
    return response;
  }

  Future<Response<T>> delete<T>({
    required String path,
    dynamic body,
    Map<String, dynamic> queryParams = const {},
    String? authHeader,
    String? acceptHeader,
    Map<String, dynamic>? extraHeaders,
    Options? options,
    String? requestKey,
  }) async {
    final key =
        requestKey ?? buildRequestKey('DELETE', path, queryParams: queryParams);
    final cancelToken = _createCancelToken(key);

    final headers = await _buildHeaders(
      authHeader: authHeader,
      acceptHeader: acceptHeader,
      extraHeaders: extraHeaders,
    );

    final response = await dio.delete<T>(
      path,
      data: body,
      queryParameters: queryParams,
      cancelToken: cancelToken,
      options: (options ?? Options()).copyWith(headers: headers),
    );

    _validateResponse(response);
    return response;
  }
}

class ApiLoggerInterceptor extends Interceptor {
  String _prettyPrint(dynamic data) {
    try {
      if (data == null) return 'null';
      if (data is FormData) return 'Multipart data upload (FormData)';
      if (data is Map || data is List) {
        return const JsonEncoder.withIndent('  ').convert(data);
      }
      return data.toString();
    } catch (_) {
      return data.toString();
    }
  }

  Map<String, dynamic> _maskHeaders(Map<String, dynamic> headers) {
    final masked = Map<String, dynamic>.from(headers);

    for (final key in masked.keys.toList()) {
      final lowerKey = key.toLowerCase();
      if (lowerKey.contains('authorization') ||
          lowerKey.contains('token') ||
          lowerKey.contains('cookie')) {
        masked[key] = '***';
      }
    }

    return masked;
  }

  // dynamic _truncate(dynamic data) {
  //   final text = data.toString();
  //   if (text.length > 2500) {
  //     return '${text.substring(0, 2500)}... [truncated]';
  //   }
  //   return data;
  // }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      log('''
=== API REQUEST ====== API REQUEST ====== API REQUEST ====== API REQUEST ====== API REQUEST ====== API REQUEST ====== API REQUEST ====== API REQUEST ===
[${options.method}] ${options.uri}
Headers: ${_prettyPrint(_maskHeaders(options.headers))}
Query: ${_prettyPrint(options.queryParameters)}
Body: ${_prettyPrint(options.data)}
''');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      log('''
=== API RESPONSE ====== API RESPONSE ====== API RESPONSE ========= API RESPONSE ========= API RESPONSE ========= API RESPONSE ========= API RESPONSE ===

[${response.statusCode}] ${response.requestOptions.uri}
Headers: ${_prettyPrint(response.headers.map)}
Data: ${_prettyPrint(response.data)}
''');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      log('''
=== API ERROR ====== API ERROR ====== API ERROR ====== API ERROR ====== API ERROR ====== API ERROR ====== API ERROR ===
[${err.requestOptions.method}] ${err.requestOptions.uri}
Status: ${err.response?.statusCode}
Message: ${err.message}
Response: ${_prettyPrint(err.response?.data)}
''');
    }
    handler.next(err);
  }
}
