import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:collab_task/core/config/constants/api_constant.dart';
import 'package:collab_task/core/network/api_helper.dart';
import 'package:collab_task/core/network/websocket_service.dart';

/// Module for third-party / chassis types that injectable can't construct via
/// annotations alone (no public constructor matching the DI shape, or needs
/// runtime configuration).
///
/// Add new providers here for any class you depend on but don't own — Dio,
/// HTTP clients, plugins, etc. Annotate own classes with `@injectable` /
/// `@lazySingleton` directly instead of routing them through here.
@module
abstract class RegisterModule {
  @lazySingleton
  Dio dio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 20),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
    dio.interceptors.add(ApiLoggerInterceptor());
    return dio;
  }

  @lazySingleton
  ApiHelper apiHelper(Dio dio) => ApiHelper(dio: dio);

  @lazySingleton
  WebSocketService webSocketService() =>
      WebSocketService(baseUrl: ApiConstants.baseUrl);
}
