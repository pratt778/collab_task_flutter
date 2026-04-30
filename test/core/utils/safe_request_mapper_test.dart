import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:collab_task/core/error/exceptions.dart';
import 'package:collab_task/core/error/failures.dart';
import 'package:collab_task/core/utils/safe_request_mapper.dart';

void main() {
  final requestOptions = RequestOptions(path: '/test');

  DioException dioException({
    required DioExceptionType type,
    int? statusCode,
    Object? data,
  }) {
    return DioException(
      requestOptions: requestOptions,
      type: type,
      response: statusCode != null
          ? Response(
              requestOptions: requestOptions,
              statusCode: statusCode,
              data: data,
            )
          : null,
    );
  }

  group('SafeRequest.call', () {
    test('returns the value when the callback succeeds', () async {
      final result = await SafeRequest.call(() async => 42);
      expect(result, 42);
    });

    group('typed exception → matching Failure', () {
      test('ApiException → ApiFailure (message preserved)', () async {
        await expectLater(
          SafeRequest.call(() async => throw const ApiException('boom')),
          throwsA(
            isA<ApiFailure>().having((f) => f.message, 'message', 'boom'),
          ),
        );
      });

      test('AuthException → AuthFailure (message preserved)', () async {
        await expectLater(
          SafeRequest.call(
            () async => throw const AuthException(message: 'nope'),
          ),
          throwsA(
            isA<AuthFailure>().having((f) => f.message, 'message', 'nope'),
          ),
        );
      });

      test('CacheException → CacheFailure (message preserved)', () async {
        await expectLater(
          SafeRequest.call(
            () async => throw const CacheException(message: 'cache miss'),
          ),
          throwsA(
            isA<CacheFailure>().having(
              (f) => f.message,
              'message',
              'cache miss',
            ),
          ),
        );
      });

      test('unknown exception → UnexpectedFailure', () async {
        await expectLater(
          SafeRequest.call(() async => throw StateError('weird')),
          throwsA(isA<UnexpectedFailure>()),
        );
      });
    });

    group('DioException.type branches', () {
      test('connectionTimeout → TimeoutFailure', () async {
        await expectLater(
          SafeRequest.call(
            () async =>
                throw dioException(type: DioExceptionType.connectionTimeout),
          ),
          throwsA(isA<TimeoutFailure>()),
        );
      });

      test('sendTimeout → TimeoutFailure', () async {
        await expectLater(
          SafeRequest.call(
            () async => throw dioException(type: DioExceptionType.sendTimeout),
          ),
          throwsA(isA<TimeoutFailure>()),
        );
      });

      test('receiveTimeout → TimeoutFailure', () async {
        await expectLater(
          SafeRequest.call(
            () async =>
                throw dioException(type: DioExceptionType.receiveTimeout),
          ),
          throwsA(isA<TimeoutFailure>()),
        );
      });

      test('connectionError → NetworkFailure', () async {
        await expectLater(
          SafeRequest.call(
            () async =>
                throw dioException(type: DioExceptionType.connectionError),
          ),
          throwsA(isA<NetworkFailure>()),
        );
      });

      test('cancel → UnexpectedFailure with "Request cancelled"', () async {
        await expectLater(
          SafeRequest.call(
            () async => throw dioException(type: DioExceptionType.cancel),
          ),
          throwsA(
            isA<UnexpectedFailure>().having(
              (f) => f.message,
              'message',
              'Request cancelled',
            ),
          ),
        );
      });
    });

    group('DioException.badResponse by status code', () {
      test('401 → AuthFailure with server message and statusCode', () async {
        await expectLater(
          SafeRequest.call(
            () async => throw dioException(
              type: DioExceptionType.badResponse,
              statusCode: 401,
              data: {'message': 'token expired'},
            ),
          ),
          throwsA(
            isA<AuthFailure>()
                .having((f) => f.statusCode, 'statusCode', 401)
                .having((f) => f.message, 'message', 'token expired'),
          ),
        );
      });

      test('403 → AuthFailure (always "Forbidden")', () async {
        await expectLater(
          SafeRequest.call(
            () async => throw dioException(
              type: DioExceptionType.badResponse,
              statusCode: 403,
            ),
          ),
          throwsA(
            isA<AuthFailure>()
                .having((f) => f.statusCode, 'statusCode', 403)
                .having((f) => f.message, 'message', 'Forbidden'),
          ),
        );
      });

      test('404 → ServerFailure with statusCode 404', () async {
        await expectLater(
          SafeRequest.call(
            () async => throw dioException(
              type: DioExceptionType.badResponse,
              statusCode: 404,
            ),
          ),
          throwsA(
            isA<ServerFailure>().having(
              (f) => f.statusCode,
              'statusCode',
              404,
            ),
          ),
        );
      });

      test('422 (generic 4xx) → ApiFailure with server-provided message',
          () async {
        await expectLater(
          SafeRequest.call(
            () async => throw dioException(
              type: DioExceptionType.badResponse,
              statusCode: 422,
              data: {'error': 'validation failed'},
            ),
          ),
          throwsA(
            isA<ApiFailure>()
                .having((f) => f.statusCode, 'statusCode', 422)
                .having((f) => f.message, 'message', 'validation failed'),
          ),
        );
      });

      test('503 (5xx) → ServerFailure with statusCode', () async {
        await expectLater(
          SafeRequest.call(
            () async => throw dioException(
              type: DioExceptionType.badResponse,
              statusCode: 503,
            ),
          ),
          throwsA(
            isA<ServerFailure>().having(
              (f) => f.statusCode,
              'statusCode',
              503,
            ),
          ),
        );
      });
    });
  });
}
