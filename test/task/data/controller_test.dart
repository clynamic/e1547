import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/task/task.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notified_preferences/notified_preferences.dart';

import '../../_support/fake_e621.dart';
import '../../_support/harness.dart';
import '../../_support/images.dart';
import '../../_support/posts.dart';

void main() {
  late FakeE621 fake;
  late Client client;
  late ValueNotifier<Traits> traits;
  late AppDatabase sqlite;
  late TasksController tasks;

  setUpAll(initializeTestApp);

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    sqlite = AppDatabase(NativeDatabase.memory());
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
    client = Client(
      identity: await IdentityRepository(
        sqlite,
      ).add(IdentityRequest(host: fake.url)),
      traits: traits,
      storage: AppStorage(
        preferences: await SharedPreferences.getInstance(),
        temporaryFiles: '.',
        queryCache: CachedQuery.asNewInstance(),
        sqlite: sqlite,
      ),
    );
    final Settings settings = Settings(await SharedPreferences.getInstance());
    settings.upvoteFavs.value = false;
    tasks = TasksController(
      repository: TaskRepository(database: sqlite),
      client: client,
      cacheManager: const NoImageCacheManager(),
      settings: settings,
      identity: client.identity.id,
    );
  });

  tearDown(() async {
    tasks.dispose();
    traits.dispose();
    await fake.stop();
    await sqlite.close();
  });

  Future<Post?> cachedAfter(int id, bool Function(Post post) done) async {
    for (int i = 0; i < 40; i++) {
      final Post? post = client.posts.postCache.get(id);
      if (post != null && done(post)) return post;
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
    return client.posts.postCache.get(id);
  }

  test('favorite tasks update the cached post both ways', () async {
    client.posts.postCache.savePage([samplePost(id: 1000, favCount: 3)]);

    await tasks.enqueueAll([
      const TaskRequest(action: TaskAction.favorite, postId: 1000),
    ]);
    final Post? favorited = await cachedAfter(
      1000,
      (e) => e.isFavorited && fake.state.favorites.isNotEmpty,
    );

    expect(favorited?.isFavorited, isTrue);
    expect(favorited?.favCount, 4);
    expect(fake.state.favorites, {1000});

    await tasks.enqueueAll([
      const TaskRequest(action: TaskAction.unfavorite, postId: 1000),
    ]);
    final Post? unfavorited = await cachedAfter(
      1000,
      (e) => !e.isFavorited && fake.state.favorites.isEmpty,
    );

    expect(unfavorited?.isFavorited, isFalse);
    expect(unfavorited?.favCount, 3);
    expect(fake.state.favorites, isEmpty);
  });
}
