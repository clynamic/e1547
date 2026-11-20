import 'dart:async';

import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notified_preferences/notified_preferences.dart';

import '../../_support/fake_e621.dart';
import '../../_support/harness.dart';

void main() {
  late FakeE621 fake;
  late Client client;
  late ValueNotifier<Traits> traits;
  late AppDatabase sqlite;

  setUpAll(() async {
    await initializeTestApp();
    sqlite = AppDatabase(NativeDatabase.memory());
  });

  tearDownAll(() => sqlite.close());

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    fake = await FakeE621.start();
    traits = ValueNotifier(
      const Traits(
        id: 1,
        userId: null,
        denylist: [],
        homeTags: '',
        avatar: null,
        perPage: null,
      ),
    );
    final identity = await IdentityRepository(
      sqlite,
    ).add(IdentityRequest(host: fake.url, username: 'tester'));
    client = Client(
      identity: identity,
      traits: traits,
      storage: AppStorage(
        preferences: await SharedPreferences.getInstance(),
        temporaryFiles: '.',
        queryCache: CachedQuery.asNewInstance()
          ..config(
            config: const GlobalQueryConfig(
              cacheDuration: Duration(milliseconds: 1),
            ),
          ),
        sqlite: sqlite,
      ),
    );
  });

  tearDown(() async {
    traits.dispose();
    await fake.stop();
  });

  test('a sync brings follows with new posts into the unseen list', () async {
    await client.follows.create(tags: 'tag_1', type: FollowType.update);
    final follow = (await client.follows.getByTags(tags: 'tag_1'))!;
    addTearDown(() => client.follows.delete(follow.id));
    await client.follows.repository.replace(
      follow.copyWith(unseen: 0, latest: 1000),
    );

    final query = client.follows.usePage(
      query: FollowsQuery(types: [FollowType.update], hasUnseen: true),
    );
    final lists = StreamController<List<int>>.broadcast();
    final subscription = query.stream.listen((state) {
      final pages = state.data?.pages;
      if (pages != null) lists.add(pages.expand((p) => p).toList());
    });
    addTearDown(subscription.cancel);
    addTearDown(lists.close);

    expect(await lists.stream.first, isEmpty);

    final refreshed = lists.stream.firstWhere((ids) => ids.isNotEmpty);
    await client.followServer.sync(force: true);

    expect(await refreshed.timeout(const Duration(seconds: 2)), [follow.id]);
  });

  test('a cancelled sync ends and lets the next one run', () async {
    await client.follows.create(tags: 'tag_1', type: FollowType.update);
    final follow = (await client.follows.getByTags(tags: 'tag_1'))!;
    addTearDown(() => client.follows.delete(follow.id));
    final Completer<void> server = Completer();
    addTearDown(() => server.isCompleted ? null : server.complete());
    client.dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          await server.future;
          handler.next(options);
        },
      ),
    );

    final first = client.followServer.sync(force: true);
    final cancelled = client.followServer.currentSync!..cancel();
    await first.timeout(const Duration(seconds: 2));

    server.complete();
    final next = client.followServer.sync(force: true);
    expect(client.followServer.currentSync, isNot(same(cancelled)));
    await next.timeout(const Duration(seconds: 2));
  });
}
