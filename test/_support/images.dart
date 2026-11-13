import 'dart:async';
import 'dart:typed_data';

import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Cache manager that never yields an image.
///
/// Post widgets read a [BaseCacheManager] from the tree, and the real one wants
/// a plugin backed directory to write to. Every image drawn under this one
/// falls back to its error widget instead.
class NoImageCacheManager implements BaseCacheManager {
  const NoImageCacheManager();

  @override
  Stream<FileResponse> getFileStream(
    String url, {
    String? key,
    Map<String, String>? headers,
    bool? withProgress,
  }) => const Stream.empty();

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} holds no image');
}

class PendingImageCacheManager implements BaseCacheManager {
  const PendingImageCacheManager({this.downloaded});

  final int? downloaded;

  @override
  Stream<FileResponse> getFileStream(
    String url, {
    String? key,
    Map<String, String>? headers,
    bool? withProgress,
  }) async* {
    if (downloaded case final int downloaded) {
      yield DownloadProgress(url, 100, downloaded);
    }
    await Completer<void>().future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} holds no image');
}

class FailingImageCacheManager implements BaseCacheManager {
  const FailingImageCacheManager();

  @override
  Stream<FileResponse> getFileStream(
    String url, {
    String? key,
    Map<String, String>? headers,
    bool? withProgress,
  }) => Stream.error(StateError('no image at $url'));

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} holds no image');
}

class ServedImageCacheManager implements BaseCacheManager {
  ServedImageCacheManager(this.bytes);

  final Uint8List bytes;
  final MemoryFileSystem _files = MemoryFileSystem();

  @override
  Stream<FileResponse> getFileStream(
    String url, {
    String? key,
    Map<String, String>? headers,
    bool? withProgress,
  }) {
    final File file = _files.file(url.hashCode.toString())
      ..writeAsBytesSync(bytes);
    return Stream.value(FileInfo(file, FileSource.Cache, DateTime(9999), url));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} only serves images');
}
