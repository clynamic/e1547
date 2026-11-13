import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/query/query.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase sqlite;
  late CachedQuery cache;

  setUp(() {
    sqlite = AppDatabase(NativeDatabase.memory());
    cache = CachedQuery.asNewInstance()
      ..config(
        storage: DriftQueryStorage(
          repository: QueryStorageRepository(database: sqlite),
        ),
      );
  });

  tearDown(() async {
    await cache.dispose();
    await sqlite.close();
  });

  Query<Map<String, dynamic>> build({required bool vendored, int fetches = 0}) {
    return Query<Map<String, dynamic>>(
      cache: cache,
      key: const ['ident', 1, 'posts', 5],
      queryFn: () async => {'id': 5, 'source': 'network'},
      config: QueryConfig(
        shouldFetch: QueryBridge.vendorFetch<Map<String, dynamic>>(vendored),
        storeQuery: true,
        storageDuration: const Duration(days: 1),
        storageDeserializer: (json) => (json as Map).cast<String, dynamic>(),
      ),
    );
  }

  test('a live query restores from storage', () async {
    await build(vendored: false).fetch();
    await cache.dispose();

    cache = CachedQuery.asNewInstance()
      ..config(
        storage: DriftQueryStorage(
          repository: QueryStorageRepository(database: sqlite),
        ),
      );

    final restored = build(vendored: false);
    await restored.fetch();
    expect(restored.state.data, isNotNull);
  });

  test('a vendored query restores from storage', () async {
    await build(vendored: false).fetch();
    await cache.dispose();

    cache = CachedQuery.asNewInstance()
      ..config(
        storage: DriftQueryStorage(
          repository: QueryStorageRepository(database: sqlite),
        ),
      );

    final restored = build(vendored: true);
    await restored.fetch();
    expect(
      restored.state.data,
      isNotNull,
      reason: 'a vendored query must still read local storage',
    );
  });

  test('an infinite query restores its pages from storage', () async {
    QueryBridge<Map<String, dynamic>, int> bridgeFor(CachedQuery cache) =>
        cache.bridge<Map<String, dynamic>, int>(
          const ['ident', 1, 'posts'],
          getId: (item) => item['id'] as int,
          fromJson: (json) => (json as Map).cast<String, dynamic>(),
        );

    InfiniteQuery<List<int>, int> pageFor(
      CachedQuery cache, {
      required bool offline,
    }) => InfiniteQuery<List<int>, int>(
      cache: cache,
      key: const ['ident', 1, 'posts', 'page'],
      getNextArg: (state) => (state?.pages.isEmpty ?? true) ? 1 : null,
      config: pagedIdConfig(),
      queryFn: (page) async {
        if (offline) throw StateError('network is unavailable');
        return bridgeFor(cache).savePage([
          {'id': 5, 'source': 'network'},
        ]);
      },
    );

    await pageFor(cache, offline: false).fetch();
    await cache.dispose();

    cache = CachedQuery.asNewInstance()
      ..config(
        storage: DriftQueryStorage(
          repository: QueryStorageRepository(database: sqlite),
        ),
      );

    final restored = pageFor(cache, offline: true);
    await restored.fetch();
    expect(restored.state.data?.pages.first, [
      5,
    ], reason: 'the page must restore without the network');
  });

  test('savePage persists the items it vendors', () async {
    final bridge = cache.bridge<Map<String, dynamic>, int>(
      const ['ident', 1, 'posts'],
      getId: (item) => item['id'] as int,
      fromJson: (json) => (json as Map).cast<String, dynamic>(),
    );
    bridge.savePage([
      {'id': 5, 'source': 'vendored'},
    ]);

    Query<Map<String, dynamic>>(
      cache: cache,
      key: const ['ident', 1, 'posts', 5],
      config: bridge.getConfig(vendored: true),
      queryFn: () async => {'id': 5, 'source': 'network'},
    );

    final storage = cache.storage!;
    final stored = await storage.get('["ident",1,"posts",5]');
    expect(
      stored,
      isNotNull,
      reason: 'vendored items must reach storage to survive a restart',
    );
  });
}
