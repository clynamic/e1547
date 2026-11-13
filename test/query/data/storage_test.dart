import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/query/query.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase sqlite;
  late QueryStorageRepository repository;
  late DriftQueryStorage storage;

  StoredQuery entry(
    String key,
    Object? data, {
    Duration? duration = const Duration(days: 1),
    DateTime? createdAt,
  }) => StoredQuery(
    key: key,
    data: data,
    createdAt: createdAt ?? DateTime.now(),
    storageDuration: duration,
  );

  /// [put] is fire and forget, so writes are drained through a read.
  Future<void> settle() => storage.get('drain');

  setUp(() {
    sqlite = AppDatabase(NativeDatabase.memory());
    repository = QueryStorageRepository(database: sqlite);
    storage = DriftQueryStorage(repository: repository, maxEntries: 3);
  });

  tearDown(() => sqlite.close());

  group('DriftQueryStorage', () {
    test('restores what it stored', () async {
      storage.put(entry('["ident",1,"posts",5]', {'id': 5, 'name': 'tester'}));
      await settle();

      final stored = await storage.get('["ident",1,"posts",5]');
      expect(stored, isNotNull);
      expect(stored!.data, {'id': 5, 'name': 'tester'});
      expect(stored.storageDuration, const Duration(days: 1));
    });

    test('restores paged id lists', () async {
      final pages = InfiniteQueryData<List<int>, int>(
        pages: [
          [1, 2],
          [3],
        ],
        args: [1, 2],
      );
      storage.put(entry('["ident",1,"posts"]', pages));
      await settle();

      final restored = pagedIdConfig().storageDeserializer!(
        (await storage.get('["ident",1,"posts"]'))!.data,
      );
      expect(restored.pages, [
        [1, 2],
        [3],
      ]);
      expect(restored.args, [1, 2]);
    });

    test('reports a missing key as null', () async {
      expect(await storage.get('["ident",1,"posts",404]'), isNull);
    });

    test('replaces an existing key instead of duplicating it', () async {
      storage.put(entry('["ident",1,"posts",5]', {'score': 1}));
      storage.put(entry('["ident",1,"posts",5]', {'score': 2}));
      await settle();

      expect((await storage.get('["ident",1,"posts",5]'))!.data, {'score': 2});
      expect(await repository.count(), 1);
    });

    test('drops the least recent entries past the cap', () async {
      final now = DateTime.now();
      for (int i = 0; i < 5; i++) {
        storage.put(
          entry('["ident",1,"posts",$i]', {
            'id': i,
          }, createdAt: now.subtract(Duration(minutes: 5 - i))),
        );
      }
      await settle();

      expect(await repository.count(), 3);
      expect(await storage.get('["ident",1,"posts",0]'), isNull);
      expect(await storage.get('["ident",1,"posts",1]'), isNull);
      expect(await storage.get('["ident",1,"posts",4]'), isNotNull);
    });

    test('sweeps expired entries when the cap is reached', () async {
      storage.put(
        entry(
          '["ident",1,"posts",0]',
          {'id': 0},
          duration: const Duration(milliseconds: 1),
          createdAt: DateTime(2020),
        ),
      );
      for (int i = 1; i < 4; i++) {
        storage.put(entry('["ident",1,"posts",$i]', {'id': i}));
      }
      await settle();

      expect(await storage.get('["ident",1,"posts",0]'), isNull);
    });

    test('removes only the queries of one identity', () async {
      storage.put(entry('["ident",1,"posts",5]', {'id': 5}));
      storage.put(entry('["ident",2,"posts",5]', {'id': 5}));
      await settle();

      await repository.removeIdentity(1);

      expect(await storage.get('["ident",1,"posts",5]'), isNull);
      expect(await storage.get('["ident",2,"posts",5]'), isNotNull);
    });

    test('deleteAll empties the store', () async {
      storage.put(entry('["ident",1,"posts",5]', {'id': 5}));
      await settle();

      storage.deleteAll();
      await settle();

      expect(await repository.count(), 0);
    });
  });
}
