import 'dart:async';

import 'package:drift/drift.dart';
import 'package:drift/native.dart' show SqliteException;
import 'package:e1547/logs/logs.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// ignore: always_use_package_imports
import 'storage.drift.dart';

@TableIndex(name: 'file_cache_lookup', columns: {#cache, #key}, unique: true)
@TableIndex(name: 'file_cache_touched', columns: {#cache, #touched})
class FileCacheTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get cache => text()();
  TextColumn get key => text()();
  TextColumn get url => text()();
  TextColumn get relativePath => text()();
  DateTimeColumn get validTill => dateTime()();
  TextColumn get eTag => text().nullable()();
  IntColumn get length => integer().nullable()();
  DateTimeColumn get touched => dateTime()();
}

@DriftAccessor(tables: [FileCacheTable])
class FileCacheRepository extends DatabaseAccessor<GeneratedDatabase>
    with $FileCacheRepositoryMixin {
  FileCacheRepository({required GeneratedDatabase database}) : super(database);

  Future<FileCacheTableData?> get(String cache, String key) =>
      (select(fileCacheTable)
            ..where((tbl) => tbl.cache.equals(cache) & tbl.key.equals(key)))
          .getSingleOrNull();

  Future<List<FileCacheTableData>> all(String cache) =>
      (select(fileCacheTable)..where((tbl) => tbl.cache.equals(cache))).get();

  Future<int> add(FileCacheTableDataCompanion entry) =>
      into(fileCacheTable).insert(entry);

  Future<void> updateAll(List<FileCacheTableDataCompanion> entries) =>
      batch((b) {
        for (final entry in entries) {
          b.update(
            fileCacheTable,
            entry,
            where: (tbl) => tbl.id.equals(entry.id.value),
          );
        }
      });

  Future<void> put(FileCacheTableData entry) =>
      into(fileCacheTable).insertOnConflictUpdate(entry);

  Future<int> removeAll(Iterable<int> ids) =>
      (delete(fileCacheTable)..where((tbl) => tbl.id.isIn(ids))).go();

  Future<int> removeCache(String cache) =>
      (delete(fileCacheTable)..where((tbl) => tbl.cache.equals(cache))).go();

  Future<List<FileCacheTableData>> overCapacity(String cache, int capacity) =>
      (select(fileCacheTable)
            ..where((tbl) => tbl.cache.equals(cache))
            ..orderBy([
              (tbl) => OrderingTerm(
                expression: tbl.touched,
                mode: OrderingMode.desc,
              ),
            ])
            ..limit(-1, offset: capacity))
          .get();

  Future<List<FileCacheTableData>> touchedBefore(
    String cache,
    DateTime oldest,
  ) =>
      (select(fileCacheTable)..where(
            (tbl) =>
                tbl.cache.equals(cache) &
                tbl.touched.isSmallerThanValue(oldest),
          ))
          .get();

  Future<bool> any(String cache) async =>
      await (select(fileCacheTable)
            ..where((tbl) => tbl.cache.equals(cache))
            ..limit(1))
          .getSingleOrNull() !=
      null;
}

class DriftFileCacheStorage extends CacheInfoRepository {
  DriftFileCacheStorage({
    required this.repository,
    required this.cache,
    this.flushDelay = const Duration(seconds: 1),
  });

  final FileCacheRepository repository;

  final String cache;

  final Duration flushDelay;

  final Logger _logger = Logger('FileCache');

  final Map<String, CacheObject> _pending = {};
  Timer? _timer;

  int _connections = 0;
  Completer<bool>? _opened;

  @override
  Future<bool> open() async {
    _connections++;
    if (_opened case final Completer<bool> opened) return opened.future;
    final opened = _opened = Completer<bool>();
    opened.complete(true);
    return opened.future;
  }

  @override
  Future<bool> close() async {
    await _flush();
    _connections--;
    if (_connections > 0) return false;
    _opened = null;
    return true;
  }

  Future<void> _flush() async {
    _timer?.cancel();
    _timer = null;
    if (_pending.isEmpty) return;
    final pending = _pending.values.toList();
    _pending.clear();
    await _guarded(
      'update',
      null,
      () => repository.updateAll([
        for (final object in pending)
          _toCompanion(object, setTouchedToNow: false),
      ]),
    );
  }

  // The cache database can become unwritable when the OS wipes app
  // directories under storage pressure, or when its file is replaced
  // beneath an open connection (issue #178, SqliteException(1032)).
  // The file cache is not worth crashing over: database failures
  // degrade into cache misses, so files download again.
  Future<T> _guarded<T>(
    String action,
    T fallback,
    Future<T> Function() run,
  ) async {
    try {
      return await run();
    } on SqliteException catch (error, stackTrace) {
      _logger.error(
        'Ignoring cache {action} failure: {error}',
        {'action': action, 'error': error.toString()},
        error,
        stackTrace,
      );
      return fallback;
    }
  }

  CacheObject _touched(CacheObject object, DateTime touched) => CacheObject(
    object.url,
    key: object.key,
    relativePath: object.relativePath,
    validTill: object.validTill,
    eTag: object.eTag,
    id: object.id,
    length: object.length,
    touched: touched,
  );

  CacheObject _toObject(FileCacheTableData data) => CacheObject(
    data.url,
    key: data.key,
    relativePath: data.relativePath,
    validTill: data.validTill,
    eTag: data.eTag,
    id: data.id,
    length: data.length,
    touched: data.touched,
  );

  FileCacheTableDataCompanion _toCompanion(
    CacheObject object, {
    required bool setTouchedToNow,
  }) => FileCacheTableDataCompanion(
    id: object.id == null ? const Value.absent() : Value(object.id!),
    cache: Value(cache),
    key: Value(object.key),
    url: Value(object.url),
    relativePath: Value(object.relativePath),
    validTill: Value(object.validTill),
    eTag: Value(object.eTag),
    length: Value(object.length),
    touched: Value(
      setTouchedToNow ? DateTime.now() : object.touched ?? DateTime.now(),
    ),
  );

  @override
  Future<CacheObject?> get(String key) async {
    if (_pending[key] case final CacheObject pending) return pending;
    return _guarded('read', null, () async {
      final data = await repository.get(cache, key);
      if (data == null) return null;
      return _toObject(data);
    });
  }

  @override
  Future<CacheObject> insert(
    CacheObject cacheObject, {
    bool setTouchedToNow = true,
  }) async {
    return _guarded('insert', cacheObject, () async {
      final id = await repository.add(
        _toCompanion(
          cacheObject,
          setTouchedToNow: setTouchedToNow,
        ).copyWith(id: const Value.absent()),
      );
      return cacheObject.copyWith(id: id);
    });
  }

  @override
  Future<int> update(
    CacheObject cacheObject, {
    bool setTouchedToNow = true,
  }) async {
    if (cacheObject.id == null) {
      throw ArgumentError('Updated objects should have an existing id.');
    }
    _pending[cacheObject.key] = setTouchedToNow
        ? _touched(cacheObject, DateTime.now())
        : cacheObject;
    _timer ??= Timer(flushDelay, _flush);
    return 1;
  }

  @override
  Future<dynamic> updateOrInsert(CacheObject cacheObject) =>
      cacheObject.id == null ? insert(cacheObject) : update(cacheObject);

  Future<List<CacheObject>> _read(
    Future<List<FileCacheTableData>> Function() query,
  ) async {
    await _flush();
    return _guarded('query', const [], () async {
      return (await query()).map(_toObject).toList();
    });
  }

  @override
  Future<List<CacheObject>> getAllObjects() =>
      _read(() => repository.all(cache));

  @override
  Future<List<CacheObject>> getObjectsOverCapacity(int capacity) =>
      _read(() => repository.overCapacity(cache, capacity));

  @override
  Future<List<CacheObject>> getOldObjects(Duration maxAge) => _read(
    () => repository.touchedBefore(cache, DateTime.now().subtract(maxAge)),
  );

  @override
  Future<int> delete(int id) => deleteAll([id]);

  @override
  Future<int> deleteAll(Iterable<int> ids) async {
    _pending.removeWhere((_, object) => ids.contains(object.id));
    await _flush();
    return _guarded('delete', 0, () => repository.removeAll(ids));
  }

  @override
  Future<void> deleteDataFile() async {
    _pending.clear();
    await _guarded('reset', null, () => repository.removeCache(cache));
  }

  @override
  Future<bool> exists() =>
      _guarded('exists check', false, () => repository.any(cache));
}
