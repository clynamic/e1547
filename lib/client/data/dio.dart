import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/logs/logs.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:native_dio_adapter/native_dio_adapter.dart';

/// Create a default [Dio] instance for the given [Identity].
Dio createDefaultDio(Identity identity, {CachedQuery? queryCache}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: normalizeHostUrl(identity.host),
      headers: {
        HttpHeaders.userAgentHeader: AppInfo.instance.userAgent,
        ...?identity.headers,
      },
      sendTimeout: const Duration(seconds: 30),
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
  dio.httpClientAdapter = NativeAdapter();
  dio.interceptors.add(NewlineReplaceInterceptor());
  dio.interceptors.add(LoggingDioInterceptor());
  if (queryCache != null) {
    dio.queryCache = queryCache;
  }
  dio.queryIdentity = identity.id;
  return dio;
}
