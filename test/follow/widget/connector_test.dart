import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notified_preferences/notified_preferences.dart';

import '../../_support/fake_e621.dart';
import '../../_support/harness.dart';
import '../../_support/images.dart';

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

  Future<Follow> seedFollow(WidgetTester tester, String tags) async {
    final follow = await tester.runAsync(() async {
      await client.follows.create(tags: tags, type: FollowType.update);
      final follow = (await client.follows.getByTags(tags: tags))!;
      await client.follows.repository.replace(
        follow.copyWith(unseen: 3, latest: 1000),
      );
      return follow;
    });
    addTearDown(() => tester.runAsync(() => client.follows.delete(follow!.id)));
    return follow!;
  }

  Future<void> visit(WidgetTester tester, String tags) async {
    final filter = PostFilter(client);
    addTearDown(filter.dispose);
    await tester.runAsync(() async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<Client>.value(value: client),
            Provider<BaseCacheManager>.value(
              value: const NoImageCacheManager(),
            ),
          ],
          child: MaterialApp(
            home: FilterControllerProvider<PostFilter, Post>.value(
              value: filter,
              child: ChangeNotifierProvider(
                create: (_) =>
                    PostParamsController(initial: PostParams(tags: tags)),
                child: FollowSeenConnector(
                  child: PostPageQueryBuilder(
                    builder: (context, state, query) => const SizedBox(),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await Future<void>.delayed(const Duration(milliseconds: 200));
    });
    await tester.pump();
  }

  displayTest('visiting a followed search marks it seen', (tester) async {
    final follow = await seedFollow(tester, 'tag_1');

    await visit(tester, 'tag_1');

    final updated = await tester.runAsync(
      () => client.follows.get(id: follow.id),
    );
    expect(updated!.unseen, 0);
    expect(updated.latest, 1042);
    expect(updated.thumbnail, isNotNull);
  });

  displayTest('visiting a follow sets its latest from the posts shown', (
    tester,
  ) async {
    traits.value = traits.value.copyWith(denylist: ['tag_114']);
    final follow = await seedFollow(tester, 'tag_1');

    await visit(tester, 'tag_1');

    final updated = await tester.runAsync(
      () => client.follows.get(id: follow.id),
    );
    expect(updated!.latest, 1021);
    expect(updated.thumbnail, client.posts.postCache.get(1021)!.sample);
  });

  displayTest('visiting a search leaves other follows alone', (tester) async {
    final follow = await seedFollow(tester, 'tag_2');

    await visit(tester, 'tag_1');

    final updated = await tester.runAsync(
      () => client.follows.get(id: follow.id),
    );
    expect(updated!.unseen, 3);
    expect(updated.latest, 1000);
  });
}
