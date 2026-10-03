import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter_test/flutter_test.dart';

/// Models the package:http ClientException family, which is not a direct
/// dependency: its toString starts with the class name.
class _FakeClientException implements Exception {
  @override
  String toString() =>
      'ClientException: Connection failed, uri=https://e621.net/';
}

void main() {
  group('isConnectionError', () {
    test('classifies timeout and connection dio exceptions', () {
      expect(
        isConnectionError(
          DioException.connectionTimeout(
            timeout: const Duration(seconds: 30),
            requestOptions: RequestOptions(),
          ),
        ),
        isTrue,
      );
      expect(
        isConnectionError(
          DioException.sendTimeout(
            timeout: const Duration(seconds: 30),
            requestOptions: RequestOptions(),
          ),
        ),
        isTrue,
      );
      expect(
        isConnectionError(
          DioException.receiveTimeout(
            timeout: const Duration(seconds: 30),
            requestOptions: RequestOptions(),
          ),
        ),
        isTrue,
      );
      expect(
        isConnectionError(
          DioException.connectionError(
            reason: 'closed',
            requestOptions: RequestOptions(),
          ),
        ),
        isTrue,
      );
    });

    test('classifies native adapter failures', () {
      expect(
        isConnectionError(
          DioException(
            requestOptions: RequestOptions(),
            error: const SocketException('failed'),
          ),
        ),
        isTrue,
      );
      // The native adapters wrap package:http ClientExceptions in
      // unknown errors; those are not a direct dependency.
      expect(
        isConnectionError(
          DioException(
            requestOptions: RequestOptions(),
            error: _FakeClientException(),
          ),
        ),
        isTrue,
      );
    });

    test('rejects server errors, responses and cancels', () {
      expect(
        isConnectionError(
          DioException.badResponse(
            statusCode: 500,
            requestOptions: RequestOptions(),
            response: Response(requestOptions: RequestOptions()),
          ),
        ),
        isFalse,
      );
      expect(
        isConnectionError(
          DioException(
            requestOptions: RequestOptions(),
            error: Exception('some parsing bug'),
          ),
        ),
        isFalse,
      );
      final cancelToken = CancelToken();
      cancelToken.cancel();
      expect(
        isConnectionError(
          DioException(
            type: DioExceptionType.cancel,
            error: cancelToken,
            requestOptions: RequestOptions(),
          ),
        ),
        isFalse,
      );
    });

    test('classifies raw io errors', () {
      expect(isConnectionError(const SocketException('failed')), isTrue);
      expect(isConnectionError(Exception('other')), isFalse);
      expect(isConnectionError(null), isFalse);
    });
  });
}
