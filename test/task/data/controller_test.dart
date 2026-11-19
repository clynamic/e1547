import 'dart:async';

import 'package:e1547/post/post.dart';
import 'package:e1547/task/task.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/environment.dart';
import '../../_support/harness.dart';
import '../../_support/posts.dart';

class HeldDownloads implements BaseCacheManager {
  final Map<String, StreamController<FileResponse>> transfers = {};

  @override
  Stream<FileResponse> getFileStream(
    String url, {
    String? key,
    Map<String, String>? headers,
    bool? withProgress,
  }) => (transfers[url] = StreamController<FileResponse>()).stream;

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} only holds downloads');
}

void main() {
  late TestEnvironment env;
  late HeldDownloads downloads;
  late TasksController tasks;

  setUpAll(initializeTestApp);

  setUp(() async {
    env = await TestEnvironment.start();
    env.settings.upvoteFavs.value = false;
    downloads = HeldDownloads();
    tasks = TasksController(
      repository: TaskRepository(database: env.sqlite),
      client: env.client,
      cacheManager: downloads,
      settings: env.settings,
      identity: env.client.identity.id,
    );
  });

  tearDown(() async {
    tasks.dispose();
    await env.dispose();
  });

  Future<void> until(bool Function() done) async {
    for (int i = 0; i < 40 && !done(); i++) {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
  }

  Future<Post?> cachedAfter(int id, bool Function(Post post) done) async {
    bool cached() => switch (env.client.posts.postCache.get(id)) {
      final Post post => done(post),
      null => false,
    };
    await until(cached);
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

  group('downloads', () {
    String urlOf(int id) => 'http://example.invalid/$id.png';

    TaskRequest download(int id) => TaskRequest(
      action: TaskAction.download,
      postId: id,
      metadata: TaskMetadata(fileUrl: urlOf(id), fileName: '$id.png'),
    );

    test('downloads added while one transfers start alongside it', () async {
      await tasks.enqueue(download(1));
      await until(() => downloads.transfers.length == 1);

      await tasks.enqueueAll([download(2), download(3), download(4)]);
      await until(() => downloads.transfers.length == 4);

      expect(downloads.transfers, hasLength(4));
    });
  });
}
