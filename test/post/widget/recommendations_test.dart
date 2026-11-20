import 'package:e1547/post/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../_support/environment.dart';
import '../../_support/fixtures.dart';
import '../../_support/harness.dart';
import '../../_support/posts.dart';

void main() {
  setUpAll(initializeTestApp);

  late TestEnvironment env;

  setUp(
    () async => env = await TestEnvironment.start(denylist: ['blocked_tag']),
  );

  tearDown(() => env.dispose());

  void addWorks(Map<int, List<String>> works) {
    final Map<String, Object?> recorded = env.fake.state.posts.first;
    env.fake.state.posts.addAll([
      for (final MapEntry<int, List<String>> work in works.entries)
        {
          ...recorded,
          'id': work.key,
          'tags': {
            ...(recorded['tags']! as Map<String, Object?>),
            'artist': ['some_artist'],
            'general': work.value,
          },
        },
    ]);
  }

  Future<void> show(
    WidgetTester tester,
    Post post, {
    double width = 800,
  }) async {
    final PostFilter filter = PostFilter(env.client);
    addTearDown(filter.dispose);
    await tester.runAsync(
      () => tester.pumpWidget(
        env.app(
          Scaffold(
            body: SingleChildScrollView(
              child: SizedBox(
                width: width,
                child: ArtistRecommendations(post: post),
              ),
            ),
          ),
          providers: [ListenableProvider<PostFilter>.value(value: filter)],
        ),
      ),
    );
    await env.settle(tester);
  }

  Post work(int id) => samplePost(
    id: id,
    tags: const {
      'artist': ['some_artist'],
    },
  );

  List<int> tiles(WidgetTester tester) => tester
      .widgetList<PostTileOverlay>(find.byType(PostTileOverlay))
      .map((e) => e.post.id)
      .toList();

  displayTest(
    'artist recommendations list what the server finds, in its order',
    (tester) async {
      addWorks({41: [], 42: [], 43: [], 44: []});

      await show(tester, work(41));

      expect(find.text('From the artist'), findsOneWidget);
      expect(tiles(tester), [42, 43, 44]);
    },
  );

  displayTest(
    'artist recommendations show only the posts that fit their width',
    (tester) async {
      addWorks({41: [], 42: [], 43: [], 44: [], 45: [], 46: []});

      await show(tester, work(41), width: 360);

      expect(tiles(tester), [42, 43, 44]);
      expect(
        tester.getSize(find.byType(RelationPreviewCard).first),
        const Size(120, 120),
      );
    },
  );

  displayTest('a blacklisted post is left out of artist recommendations', (
    tester,
  ) async {
    addWorks({
      41: [],
      42: [],
      43: ['blocked_tag'],
      44: [],
    });

    await show(tester, work(41));

    expect(tiles(tester), [42, 44]);
  });

  displayTest('a post opens among the others the artist made', (tester) async {
    addWorks({41: [], 42: [], 43: [], 44: []});
    await show(tester, work(41));
    env.fake.requests.clear();

    await tester.tap(
      find.ancestor(
        of: find.byWidgetPredicate(
          (e) => e is PostTileOverlay && e.post.id == 43,
        ),
        matching: find.byType(RelationPreviewCard),
      ),
    );
    await env.settle(tester, animating: true);

    expect(shownPost(tester), 43);
    expect(
      env.fake.requests
          .where((e) => e.path == '/posts.json')
          .map((e) => e.query['tags']),
      ['id:42,43,44'],
    );

    await tester.fling(find.byType(PostDetail), const Offset(600, 0), 2000);
    await env.settle(tester, animating: true);
    expect(shownPost(tester), 42);
  });

  displayTest('a recommended post shows its image while it loads', (
    tester,
  ) async {
    addWorks({41: [], 42: [], 43: [], 44: []});
    await show(tester, work(41));

    await tester.tap(
      find.ancestor(
        of: find.byWidgetPredicate(
          (e) => e is PostTileOverlay && e.post.id == 43,
        ),
        matching: find.byType(RelationPreviewCard),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    final PostDetail waiting = tester.widget(
      skeletons(find.byType(PostDetail)),
    );
    expect(waiting.summary?.id, 43);
    expect(
      waiting.summary?.preview,
      (((env.fake.state.posts.first['files']! as Map)['preview']! as Map)['jpg']
              as String)
          .replaceAll(fixtureHost, env.fake.url),
    );
    expect(
      find.byWidgetPredicate((e) => e is PostImageWidget && e.post.id == 43),
      findsOneWidget,
    );

    await env.settle(tester, animating: true);

    expect(skeletons(find.byType(PostDetail)), findsNothing);
    expect(shownPost(tester), 43);
  });

  displayTest('a recommended post shows at once when it is cached', (
    tester,
  ) async {
    addWorks({41: [], 42: [], 43: [], 44: []});
    await show(tester, work(41));
    await tester.runAsync(
      () => env.client.posts.usePage(query: {'tags': 'some_artist'}).fetch(),
    );

    await tester.tap(
      find.ancestor(
        of: find.byWidgetPredicate(
          (e) => e is PostTileOverlay && e.post.id == 43,
        ),
        matching: find.byType(RelationPreviewCard),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(skeletons(find.byType(PostDetail)), findsNothing);
    expect(shownPost(tester), 43);
    await env.settle(tester, animating: true);
  });

  displayTest('see all searches for every artist of the post', (tester) async {
    addWorks({41: [], 42: []});
    await show(
      tester,
      samplePost(
        id: 41,
        tags: const {
          'artist': ['some_artist', 'other_artist', 'conditional_dnp'],
        },
      ),
    );
    env.fake.requests.clear();

    await tester.tap(find.text('See all'));
    await env.settle(tester, animating: true);

    expect(
      env.fake.requests
          .where((e) => e.path == '/posts.json')
          .map((e) => e.query['tags']),
      contains('~some_artist ~other_artist'),
    );
  });

  displayTest('a post whose artist tags name no artist has no '
      'recommendations', (tester) async {
    addWorks({41: [], 42: []});

    await show(
      tester,
      samplePost(
        id: 41,
        tags: const {
          'artist': ['conditional_dnp'],
        },
      ),
    );

    expect(find.byType(ArtistRecommendationsRow), findsNothing);
    expect(env.fake.requests.where((e) => e.path.contains('similar')), isEmpty);
  });
}
