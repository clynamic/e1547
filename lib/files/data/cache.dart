import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:e1547/files/files.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

const String fileCacheKey = DefaultCacheManager.key;

CacheManager createFileCache({
  required Dio dio,
  required GeneratedDatabase database,
  Duration stalePeriod = const Duration(days: 7),
  // e621 originals are large; the old default of 2000 objects could pile
  // up gigabytes on old devices, filling their storage and inviting the
  // OS to wipe the cache directory altogether (see issue #178).
  int maxNrOfCacheObjects = 500,
}) => CacheManager(
  Config(
    fileCacheKey,
    stalePeriod: stalePeriod,
    maxNrOfCacheObjects: maxNrOfCacheObjects,
    repo: DriftFileCacheStorage(
      repository: FileCacheRepository(database: database),
      cache: fileCacheKey,
    ),
    fileService: DioFileService(dio),
  ),
);

Future<void> discardLegacyFileCache() async {
  final File index = File(
    join((await getApplicationSupportDirectory()).path, '$fileCacheKey.json'),
  );
  if (!index.existsSync()) return;
  await index.delete();
  final Directory files = Directory(
    join((await getTemporaryDirectory()).path, fileCacheKey),
  );
  if (files.existsSync()) {
    await files.delete(recursive: true);
  }
}
