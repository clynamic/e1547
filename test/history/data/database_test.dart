import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/history/history.dart';
import 'package:e1547/identity/identity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase sqlite;
  late HistoryRepository repository;
  late int identity;

  Future<void> visit(String link) => repository.add(
    HistoryRequest(
      visitedAt: DateTime.utc(2020),
      link: link,
      category: HistoryCategory.items,
      type: HistoryType.posts,
    ),
    identity,
  );

  setUp(() async {
    sqlite = AppDatabase(NativeDatabase.memory());
    repository = HistoryRepository(database: sqlite);
    identity = (await IdentityRepository(
      sqlite,
    ).add(const IdentityRequest(host: 'e621.net', username: 'tester'))).id;
  });

  tearDown(() => sqlite.close());

  group('HistoryRepository.removeAll', () {
    test('clears every entry when given no ids', () async {
      await visit('/posts/1');
      await visit('/posts/2');

      await repository.removeAll(null, identity: identity);

      expect(await repository.length(identity: identity), 0);
    });

    test('clears only the given ids', () async {
      await visit('/posts/1');
      await visit('/posts/2');
      final entries = await repository.page(identity: identity);

      await repository.removeAll([entries.first.id], identity: identity);

      final remaining = await repository.page(identity: identity);
      expect(remaining.map((e) => e.link), [entries.last.link]);
    });
  });

  group('HistoryRepository.isDuplicate', () {
    test('counts a recent visit only for its own identity', () async {
      final int other = (await IdentityRepository(
        sqlite,
      ).add(const IdentityRequest(host: 'e926.net', username: 'tester'))).id;
      final HistoryRequest request = HistoryRequest(
        visitedAt: DateTime.now(),
        link: '/posts/1',
        category: HistoryCategory.items,
        type: HistoryType.posts,
      );
      await repository.add(request, identity);

      expect(await repository.isDuplicate(request, identity), isTrue);
      expect(await repository.isDuplicate(request, other), isFalse);
    });
  });
}
