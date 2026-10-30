import 'package:e1547/history/history.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/bed.dart';
import '../../_support/harness.dart';

void main() {
  late TestBed bed;

  setUpAll(initializeTestApp);

  setUp(
    () async =>
        bed = await TestBed.start(username: 'tester', denylist: ['tag_114']),
  );

  tearDown(() => bed.dispose());

  Future<List<History>> open(WidgetTester tester, Widget home) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(bed.app(home));
      await tester.pump();
      await Future<void>.delayed(const Duration(milliseconds: 200));
    });
    await tester.pump();
    final entries = await tester.runAsync(() => bed.client.histories.page());
    addTearDown(
      () => tester.runAsync(
        () =>
            bed.client.histories.removeAll(entries!.map((e) => e.id).toList()),
      ),
    );
    return entries!;
  }

  Future<List<History>> visit(
    WidgetTester tester,
    Widget Function(Widget child) connector,
  ) {
    final filter = PostFilter(bed.client);
    addTearDown(filter.dispose);
    return open(
      tester,
      FilterControllerProvider<PostFilter, Post>.value(
        value: filter,
        child: ChangeNotifierProvider(
          create: (_) =>
              PostParamsController(initial: const PostParams(tags: 'tag_1')),
          child: connector(
            PostPageQueryBuilder(
              builder: (context, state, query) => const SizedBox(),
            ),
          ),
        ),
      ),
    );
  }

  List<String> samplesOf(List<int> ids) =>
      ids.map((id) => bed.client.posts.postCache.get(id)!.sample!).toList();

  displayTest('a post entry takes its thumbnail from what it shows', (
    tester,
  ) async {
    final [allowed, denied] = (await tester.runAsync(
      () => Future.wait([
        bed.client.posts.get(id: 1021),
        bed.client.posts.get(id: 1042),
      ]),
    ))!;

    final entries = await visit(
      tester,
      (child) => PostHistoryConnector(
        post: allowed,
        child: PostHistoryConnector(post: denied, child: child),
      ),
    );

    expect(
      {for (final entry in entries) entry.link: entry.thumbnails},
      {
        allowed.link: [allowed.sample],
        denied.link: <String>[],
      },
    );
  });

  displayTest('a search entry takes thumbnails from posts it shows', (
    tester,
  ) async {
    final [entry] = await visit(
      tester,
      (child) => PostPageHistoryConnector(child: child),
    );

    expect(entry.thumbnails, samplesOf([1000, 1021]));
  });

  displayTest('a pool entry takes thumbnails from posts it shows', (
    tester,
  ) async {
    final pool = Pool(
      id: 1,
      name: 'a_pool',
      createdAt: DateTime.utc(2020),
      updatedAt: DateTime.utc(2020),
      description: '',
      postIds: const [1000, 1021, 1042],
      postCount: 3,
      active: true,
    );

    final [entry] = await visit(
      tester,
      (child) => PoolHistoryConnector(pool: pool, child: child),
    );

    expect(entry.thumbnails, samplesOf([1000, 1021]));
  });

  displayTest('a pools search entry takes thumbnails from pools it shows', (
    tester,
  ) async {
    final template = bed.fake.state.pools.first;
    bed.fake.state.pools
      ..clear()
      ..addAll([
        {
          ...template,
          'id': 1,
          'post_ids': const [1042],
        },
        {
          ...template,
          'id': 2,
          'post_ids': const [1021],
        },
      ]);
    await tester.runAsync(
      () => bed.client.posts
          .page(query: const PostParams(tags: 'tag_1').toQuery())
          .then(bed.client.posts.postCache.savePage),
    );

    final [entry] = await open(tester, const PoolsPage());

    expect(entry.thumbnails, samplesOf([1021]));
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 31));
  });
}
