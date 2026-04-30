import 'package:dio/dio.dart';
import 'package:collab_task/core/error/exceptions.dart';
import 'package:collab_task/core/error/failures.dart';

class SafeRequest {
  static Future<T> call<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on ApiException catch (e) {
      throw ApiFailure(e.message);
    } on DioException catch (e) {
      throw _mapDioError(e);
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    } catch (e) {
      throw UnexpectedFailure('Unexpected error: $e');
    }
  }

  static Failure _mapDioError(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => const TimeoutFailure(),
      DioExceptionType.badResponse => _mapBadResponse(e),
      DioExceptionType.connectionError => const NetworkFailure(),
      DioExceptionType.cancel => const UnexpectedFailure('Request cancelled'),
      _ => const UnexpectedFailure(),
    };
  }

  static Failure _mapBadResponse(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;
    final serverMessage = data is Map<String, dynamic>
        ? (data['message'] ?? data['error'])?.toString()
        : null;
    // debugPrint('response is $data');
    return switch (statusCode) {
      401 => AuthFailure(serverMessage ?? 'Unauthorized', statusCode),
      403 => AuthFailure('Forbidden', statusCode),
      404 => ServerFailure(serverMessage ?? 'Not Found', statusCode),
      final int code when code >= 400 && code < 500 => ApiFailure(
        serverMessage ?? 'Request failed',
        statusCode,
      ),
      final int code when code >= 500 && code < 600 => ServerFailure(
        serverMessage ?? 'Server error',
        statusCode,
      ),
      _ => ServerFailure(serverMessage ?? 'Server error'),
    };
  }
}
