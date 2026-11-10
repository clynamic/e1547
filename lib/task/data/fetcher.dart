import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e1547/settings/settings.dart';
import 'package:native_dio_adapter/native_dio_adapter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Fetches a file over the network into a temporary file.
///
/// Reports normalized download progress (0 to 1) while the transfer runs.
/// Canceling [cancelToken] aborts the underlying network transfer, so no
/// further bytes are received, and the partial file is removed.
typedef DownloadFileFetcher =
    Future<File> Function(
      String url,
      CancelToken cancelToken,
      void Function(double progress)? onProgress,
    );

/// The default [DownloadFileFetcher] used by the task controller.
///
/// Downloads go straight to a temporary file with a bare CDN request, without
/// api credentials, and are exported to their destination once complete.
Future<File> fetchFileToTemp(
  String url,
  CancelToken cancelToken,
  void Function(double progress)? onProgress,
) async {
  final Dio dio = Dio(
    BaseOptions(
      headers: {HttpHeaders.userAgentHeader: AppInfo.instance.userAgent},
      connectTimeout: const Duration(seconds: 30),
      // for streamed bodies this applies between chunks, not to the whole file
      receiveTimeout: const Duration(seconds: 60),
    ),
  );
  dio.httpClientAdapter = NativeAdapter();
  final Directory tempDir = await getTemporaryDirectory();
  final File file = File(
    p.join(
      tempDir.path,
      'e1547-task-${DateTime.now().microsecondsSinceEpoch}${p.extension(p.fromUri(url))}',
    ),
  );
  try {
    await dio.download(
      url,
      file.path,
      cancelToken: cancelToken,
      onReceiveProgress: (int count, int total) {
        onProgress?.call(total > 0 ? (count / total).clamp(0, 1) : 0);
      },
    );
    return file;
  } on Object {
    if (file.existsSync()) {
      try {
        file.deleteSync();
      } on FileSystemException {
        // best-effort cleanup of the partial download
      }
    }
    rethrow;
  } finally {
    dio.close();
  }
}
