import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/identity/identity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase sqlite;
  late FollowRepository repository;
  late int identity;

  setUp(() async {
    sqlite = AppDatabase(NativeDatabase.memory());
    repository = FollowRepository(database: sqlite);
    identity = (await IdentityRepository(
      sqlite,
    ).add(const IdentityRequest(host: 'e621.net', username: 'tester'))).id;
  });

  tearDown(() => sqlite.close());

  group('FollowRepository.add', () {
    test('keeps one follow for a tag followed twice at once', () async {
      const FollowRequest follow = FollowRequest(tags: 'cat');

      await Future.wait([
        repository.add(follow, identity),
        repository.add(follow, identity),
      ]);

      expect(await repository.length(identity: identity), 1);
    });
  });
}
