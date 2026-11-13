import 'package:e1547/post/post.dart';
import 'package:e1547/task/task.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/environment.dart';
import '../../_support/harness.dart';
import '../../_support/images.dart';
import '../../_support/posts.dart';

void main() {
  late TestEnvironment env;
  late TasksController tasks;

  setUpAll(initializeTestApp);

  setUp(() async {
    env = await TestEnvironment.start();
    env.settings.upvoteFavs.value = false;
    tasks = TasksController(
      repository: TaskRepository(database: env.sqlite),
      client: env.client,
      cacheManager: const NoImageCacheManager(),
      settings: env.settings,
      identity: env.client.identity.id,
    );
  });

  tearDown(() async {
    tasks.dispose();
    await env.dispose();
  });

  Future<Post?> cachedAfter(int id, bool Function(Post post) done) async {
    for (int i = 0; i < 40; i++) {
      final Post? post = env.client.posts.postCache.get(id);
      if (post != null && done(post)) return post;
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
    return env.client.posts.postCache.get(id);
  }

  test('favorite tasks update the cached post both ways', () async {
    env.client.posts.postCache.savePage([samplePost(id: 1000, favCount: 3)]);

    await tasks.enqueueAll([
      const TaskRequest(action: TaskAction.favorite, postId: 1000),
    ]);
    final Post? favorited = await cachedAfter(
      1000,
      (e) => e.isFavorited && env.fake.state.favorites.isNotEmpty,
    );

    expect(favorited?.isFavorited, isTrue);
    expect(favorited?.favCount, 4);
    expect(env.fake.state.favorites, {1000});

    await tasks.enqueueAll([
      const TaskRequest(action: TaskAction.unfavorite, postId: 1000),
    ]);
    final Post? unfavorited = await cachedAfter(
      1000,
      (e) => !e.isFavorited && env.fake.state.favorites.isEmpty,
    );

    expect(unfavorited?.isFavorited, isFalse);
    expect(unfavorited?.favCount, 3);
    expect(env.fake.state.favorites, isEmpty);
  });

  test('a favorite task that upvotes updates the cached score', () async {
    env.settings.upvoteFavs.value = true;
    env.client.posts.postCache.savePage([samplePost(id: 1000, score: 5)]);

    await tasks.enqueueAll([
      const TaskRequest(action: TaskAction.favorite, postId: 1000),
    ]);
    final Post? voted = await cachedAfter(1000, (e) => e.vote == 1);

    expect(voted?.vote, 1);
    expect(voted?.score, 6);
  });
}
