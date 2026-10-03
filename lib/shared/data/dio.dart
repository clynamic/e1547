import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e1547/query/query.dart';

export 'package:dio/dio.dart' show CancelToken;

// TODO: Controllers now also throw Database exceptions, so this needs to be a real class.
typedef ClientException = DioException;

bool isCloudflareChallenge(Response? response) {
  if (response == null) return false;
  // Set on managed (403) and legacy JS (503) challenges alike.
  final String? mitigated = response.headers.value('cf-mitigated');
  if (mitigated?.toLowerCase() == 'challenge') return true;
  final String? server = response.headers.value(HttpHeaders.serverHeader);
  if (server != null && server.toLowerCase().contains('cloudflare')) {
    final dynamic data = response.data;
    if (data is String) {
      return const [
        'challenge-platform',
        'cf-chl',
        '_cf_chl_opt',
      ].any(data.contains);
    }
  }
  return false;
}

/// Whether [error] looks like the device could not reach the network,
/// as opposed to a server rejecting or failing a request.
///
/// Used to pick offline fallbacks over failure states in query UIs.
bool isConnectionError(Object? error) => switch (error) {
  DioException e when CancelToken.isCancel(e) => false,
  DioException(:final type, :final error) => switch (type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.connectionError => true,
    DioExceptionType.unknown =>
      error is SocketException ||
          // The native dio adapter surfaces platform http failures as unknown
          // errors wrapping package:http's ClientException family
          // (CronetClientException, NetworkClientException,
          // NSErrorClientException, ...). That package is not a direct
          // dependency, so the family is recognized by its stable
          // toString format instead of its type.
          error.toString().startsWith('ClientException:'),
    _ => false,
  },
  SocketException() => true,
  _ => false,
};

Future<bool> validateCall(Future<void> Function() call) async {
  try {
    await call();
    return true;
  } on ClientException {
    return false;
  }
}

/// Ensures that a call takes at least [duration] time to complete.
/// This allows making API calls in loops while being mindful of the server.
///
/// - [duration] defaults to 500 ms
Future<T> rateLimit<T>(Future<T> call, [Duration? duration]) => Future.wait([
  call,
  Future.delayed(duration ?? const Duration(milliseconds: 500)),
]).then((value) => value[0]);

const String identityKeyTag = 'ident';

extension QueryCacheDioExtension on Dio {
  CachedQuery? get queryCache => options.extra['@query_cache@'] as CachedQuery?;

  set queryCache(CachedQuery? value) {
    options.extra['@query_cache@'] = value;
  }

  int? get queryIdentity => options.extra['@query_identity@'] as int?;

  set queryIdentity(int? value) {
    options.extra['@query_identity@'] = value;
  }

  /// Keys are scoped, so that user-specific fields
  /// like votes and favorites cannot leak between accounts.
  List<Object> identityQueryKey(String domain) => [
    identityKeyTag,
    queryIdentity!,
    domain,
  ];
}
