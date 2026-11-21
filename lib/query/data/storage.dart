import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';

// ignore: always_use_package_imports
import 'storage.drift.dart';

class QueryStorageTable extends Table {
  TextColumn get key => text()();
  TextColumn get data => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get duration => integer().nullable()();
  DateTimeColumn get expiresAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {key};
}

@DriftAccessor(tables: [QueryStorageTable])
class QueryStorageRepository extends DatabaseAccessor<GeneratedDatabase>
    with $QueryStorageRepositoryMixin {
  QueryStorageRepository({required GeneratedDatabase database})
    : super(database);

  Future<QueryStorageTableData?> get(String key) => (select(
    queryStorageTable,
  )..where((tbl) => tbl.key.equals(key))).getSingleOrNull();

  Future<void> put(QueryStorageTableData entry) =>
      into(queryStorageTable).insertOnConflictUpdate(entry);

  Future<void> remove(String key) =>
      (delete(queryStorageTable)..where((tbl) => tbl.key.equals(key))).go();

  Future<void> removeAll() => delete(queryStorageTable).go();

  Future<int> count() async {
    final Expression<int> amount = queryStorageTable.key.count();
    final query = selectOnly(queryStorageTable)..addColumns([amount]);
    return await query.map((row) => row.read(amount)).getSingle() ?? 0;
  }

  Future<void> removeIdentity(int identity) => (delete(
    queryStorageTable,
  )..where((tbl) => tbl.key.like('["$identityKeyTag",$identity,%'))).go();

  Future<void> removeExpired(DateTime now) => (delete(
    queryStorageTable,
  )..where((tbl) => tbl.expiresAt.isSmallerThanValue(now))).go();

  Future<void> trim({required int maxAmount}) async {
    final oldest = selectOnly(queryStorageTable)
      ..addColumns([queryStorageTable.key])
      ..orderBy([
        OrderingTerm(
          expression: queryStorageTable.createdAt,
          mode: OrderingMode.desc,
        ),
      ])
      ..limit(-1, offset: maxAmount);

    await (delete(
      queryStorageTable,
    )..where((tbl) => tbl.key.isInQuery(oldest))).go();
  }
}

class DriftQueryStorage extends StorageInterface {
  DriftQueryStorage({required this.repository, this.maxEntries = 5000});

  final QueryStorageRepository repository;

  final int maxEntries;

  int? _estimatedEntries;

  Future<void> _writes = Future.value();

  void _enqueue(Future<void> Function() write) {
    _writes = _writes.then((_) => write()).catchError((_) {});
  }

  Future<void> _evict() async {
    _estimatedEntries ??= await repository.count();
    if (_estimatedEntries! <= maxEntries) return;
    await repository.removeExpired(DateTime.now());
    await repository.trim(maxAmount: maxEntries);
    _estimatedEntries = await repository.count();
  }

  @override
  Future<StoredQuery?> get(String key) async {
    // Writes are fire and forget, so a read has to wait for them.
    await _writes;
    final entry = await repository.get(key);
    if (entry == null) return null;
    return StoredQuery(
      key: entry.key,
      data: jsonDecode(entry.data),
      createdAt: entry.createdAt,
      storageDuration: entry.duration == null
          ? null
          : Duration(milliseconds: entry.duration!),
    );
  }

  @override
  void put(StoredQuery query) => _enqueue(() async {
    await repository.put(
      QueryStorageTableData(
        key: query.key,
        data: jsonEncode(query.data),
        createdAt: query.createdAt,
        duration: query.storageDuration?.inMilliseconds,
        expiresAt: query.expiry,
      ),
    );
    _estimatedEntries = switch (_estimatedEntries) {
      final int entries => entries + 1,
      null => await repository.count(),
    };
    await _evict();
  });

  @override
  void delete(String key) => _enqueue(() async {
    await repository.remove(key);
    if (_estimatedEntries case int entries) _estimatedEntries = entries - 1;
  });

  @override
  void deleteAll() => _enqueue(() async {
    await repository.removeAll();
    _estimatedEntries = 0;
  });

  @override
  void close() {}
}

Future<void> removeIdentityQueries({
  required CachedQuery cache,
  required GeneratedDatabase database,
  required int identity,
}) async {
  cache.deleteCache(
    filterFn: (unencoded, _) =>
        unencoded is List &&
        unencoded.length >= 2 &&
        unencoded[0] == identityKeyTag &&
        unencoded[1] == identity,
  );
  await QueryStorageRepository(database: database).removeIdentity(identity);
}
