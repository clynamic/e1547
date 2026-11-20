import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e1547/files/files.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late HttpServer server;
  late Dio dio;
  late List<HttpHeaders> received;

  void Function(HttpRequest request) respond = (request) {};

  setUp(() async {
    received = [];
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((request) {
      received.add(request.headers);
      respond(request);
    });
    dio = Dio(BaseOptions(baseUrl: 'http://127.0.0.1:${server.port}'));
  });

  tearDown(() async {
    dio.close();
    await server.close(force: true);
  });

  String url(String path) => 'http://127.0.0.1:${server.port}$path';

  group('DioFileService', () {
    test('reads the body, length, etag and extension of an image', () async {
      final List<int> bytes = List.filled(2048, 42);
      respond = (request) {
        request.response
          ..statusCode = 200
          ..headers.contentType = ContentType('image', 'jpeg')
          ..headers.contentLength = bytes.length
          ..headers.set(HttpHeaders.etagHeader, '"abc123"')
          ..headers.set(HttpHeaders.cacheControlHeader, 'public, max-age=600')
          ..add(bytes)
          ..close();
      };

      final response = await DioFileService(dio).get(url('/a.jpg'));

      expect(response.statusCode, 200);
      expect(response.contentLength, bytes.length);
      expect(response.eTag, '"abc123"');
      expect(response.fileExtension, '.jpg');
      expect(
        response.validTill.difference(DateTime.now()).inSeconds,
        closeTo(600, 5),
      );

      final List<int> body = [];
      await for (final chunk in response.content) {
        body.addAll(chunk);
      }
      expect(body, bytes);
    });

    test('passes the headers the cache asks for', () async {
      respond = (request) => request.response
        ..statusCode = 200
        ..close();

      await DioFileService(dio).get(
        url('/a.jpg'),
        headers: {HttpHeaders.ifNoneMatchHeader: '"abc123"'},
      );

      expect(received.single.value(HttpHeaders.ifNoneMatchHeader), '"abc123"');
    });

    test(
      'reports a 304 instead of throwing, so the cached file is kept',
      () async {
        respond = (request) => request.response
          ..statusCode = 304
          ..close();

        final response = await DioFileService(dio).get(url('/a.jpg'));

        expect(response.statusCode, 304);
      },
    );

    test('reports a 404 instead of throwing, so the cache can evict', () async {
      respond = (request) => request.response
        ..statusCode = 404
        ..close();

      final response = await DioFileService(dio).get(url('/gone.jpg'));

      expect(response.statusCode, 404);
    });

    test('falls back to no extension when the type is unknown', () async {
      respond = (request) => request.response
        ..statusCode = 200
        ..headers.contentType = ContentType('application', 'x-nonsense')
        ..close();

      final response = await DioFileService(dio).get(url('/a'));

      expect(response.fileExtension, '');
    });

    test('keeps a file for a week when no cache-control is given', () async {
      respond = (request) => request.response
        ..statusCode = 200
        ..close();

      final response = await DioFileService(dio).get(url('/a.jpg'));

      expect(
        response.validTill.difference(DateTime.now()).inMinutes,
        closeTo(const Duration(days: 7).inMinutes, 1),
      );
    });

    test('fetches with the headers of the given dio', () async {
      dio.options.headers[HttpHeaders.authorizationHeader] = 'Basic dGVzdGVy';
      final List<int> bytes = List.filled(64, 7);
      respond = (request) => request.response
        ..statusCode = 200
        ..headers.contentType = ContentType('image', 'png')
        ..headers.contentLength = bytes.length
        ..add(bytes)
        ..close();

      final CacheManager manager = CacheManager(
        Config(
          'test',
          repo: NonStoringObjectProvider(),
          fileSystem: MemoryCacheSystem(),
          fileService: DioFileService(dio),
        ),
      );
      addTearDown(manager.dispose);

      final FileInfo info = await manager.downloadFile(url('/a.png'));

      expect(await info.file.readAsBytes(), bytes);
      expect(
        received.single.value(HttpHeaders.authorizationHeader),
        'Basic dGVzdGVy',
      );
    });
  });
}
