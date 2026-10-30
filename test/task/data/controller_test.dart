import 'package:e1547/post/post.dart';
import 'package:e1547/task/task.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/bed.dart';
import '../../_support/harness.dart';
import '../../_support/images.dart';
import '../../_support/posts.dart';

void main() {
  late TestBed bed;
  late TasksController tasks;

  setUpAll(initializeTestApp);

  setUp(() async {
    bed = await TestBed.start();
    bed.settings.upvoteFavs.value = false;
    tasks = TasksController(
      repository: TaskRepository(database: bed.sqlite),
      client: bed.client,
      cacheManager: const NoImageCacheManager(),
      settings: bed.settings,
      identity: bed.client.identity.id,
    );
  });

  tearDown(() async {
    tasks.dispose();
    await bed.dispose();
  });

  Future<Post?> cachedAfter(int id, bool Function(Post post) done) async {
    for (int i = 0; i < 40; i++) {
      final Post? post = bed.client.posts.postCache.get(id);
      if (post != null && done(post)) return post;
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
    return bed.client.posts.postCache.get(id);
  }

  test('favorite tasks update the cached post both ways', () async {
    bed.client.posts.postCache.savePage([samplePost(id: 1000, favCount: 3)]);

    await tasks.enqueueAll([
      const TaskRequest(action: TaskAction.favorite, postId: 1000),
    ]);
    final Post? favorited = await cachedAfter(
      1000,
      (e) => e.isFavorited && bed.fake.state.favorites.isNotEmpty,
    );

    expect(favorited?.isFavorited, isTrue);
    expect(favorited?.favCount, 4);
    expect(bed.fake.state.favorites, {1000});

    await tasks.enqueueAll([
      const TaskRequest(action: TaskAction.unfavorite, postId: 1000),
    ]);
    final Post? unfavorited = await cachedAfter(
      1000,
      (e) => !e.isFavorited && bed.fake.state.favorites.isEmpty,
    );

    expect(unfavorited?.isFavorited, isFalse);
    expect(unfavorited?.favCount, 3);
    expect(bed.fake.state.favorites, isEmpty);
  });
}
