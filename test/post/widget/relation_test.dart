import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../_support/environment.dart';
import '../../_support/fixtures.dart';
import '../../_support/harness.dart';
import '../../_support/posts.dart';

Pool samplePool({
  required int id,
  String name = 'a_pool',
  List<int> postIds = const [],
  int? postCount,
}) => Pool(
  id: id,
  name: name,
  createdAt: DateTime.utc(2020),
  updatedAt: DateTime.utc(2020),
  description: '',
  postIds: postIds,
  postCount: postCount ?? postIds.length,
  active: true,
);

void main() {
  setUpAll(initializeTestApp);

  late TestEnvironment env;

  setUp(() async => env = await TestEnvironment.start());

  tearDown(() => env.dispose());

  Future<void> show(
    WidgetTester tester,
    Widget child, {
    PostFilter? filter,
  }) async {
    await tester.runAsync(
      () => tester.pumpWidget(
        env.app(
          Scaffold(body: SingleChildScrollView(child: child)),
          providers: [
            if (filter != null)
              ListenableProvider<FilterController<Post>>.value(value: filter),
          ],
        ),
      ),
    );
    await env.settle(tester);
  }

  group('RelationshipDisplay', () {
    displayTest('loads a parent and its children in one request', (
      tester,
    ) async {
      final List<int> ids = loadFixtureList(
        'posts.json',
      ).map((e) => e['id']! as int).take(4).toList();
      env.fake.requests.clear();

      await show(
        tester,
        RelationshipDisplay(
          post: samplePost(
            id: 10,
            relationships: Relationships(
              parentId: ids.first,
              hasChildren: true,
              hasActiveChildren: true,
              children: ids.skip(1).toList(),
            ),
          ),
        ),
      );

      expect(env.fake.requests.map((e) => e.path), ['/posts.json']);
      expect(
        env.fake.requests.single.query['tags'],
        'id:${ids.join(',')} status:any',
      );
    });

    displayTest('names the artists of a cached parent', (tester) async {
      env.client.posts.postCache.set(
        samplePost(
          id: 20,
          tags: const {
            'artist': ['sample_artist'],
          },
        ),
      );

      await show(
        tester,
        RelationshipDisplay(
          post: samplePost(
            id: 10,
            relationships: const Relationships(
              parentId: 20,
              hasChildren: false,
              hasActiveChildren: null,
              children: [],
            ),
          ),
        ),
      );

      expect(find.text('Parent'), findsOneWidget);
      expect(find.text('sample artist'), findsOneWidget);
    });

    displayTest('counts children and previews each one', (tester) async {
      for (final id in [21, 22]) {
        env.client.posts.postCache.set(samplePost(id: id));
      }

      await show(
        tester,
        RelationshipDisplay(
          post: samplePost(
            id: 10,
            relationships: const Relationships(
              parentId: null,
              hasChildren: true,
              hasActiveChildren: true,
              children: [21, 22],
            ),
          ),
        ),
      );

      expect(find.text('Children'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.byType(PostRelationPreview), findsNWidgets(2));
    });

    displayTest('warns when a child cannot be loaded', (tester) async {
      await show(
        tester,
        RelationshipDisplay(
          post: samplePost(
            id: 10,
            relationships: const Relationships(
              parentId: null,
              hasChildren: true,
              hasActiveChildren: true,
              children: [21],
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.warning_amber_outlined), findsOneWidget);
    });

    displayTest('drops children the server marked inactive', (tester) async {
      await show(
        tester,
        RelationshipDisplay(
          post: samplePost(
            id: 10,
            relationships: const Relationships(
              parentId: null,
              hasChildren: true,
              hasActiveChildren: false,
              children: [21],
            ),
          ),
        ),
      );

      expect(find.text('Children'), findsNothing);
    });

    displayTest('marks a denied child as blocked', (tester) async {
      env.traits.value = env.traits.value.copyWith(denylist: const ['bad_tag']);
      env.client.posts.postCache.set(
        samplePost(
          id: 21,
          tags: const {
            'general': ['bad_tag'],
          },
          file: 'http://example.invalid/21.jpg',
          preview: 'http://example.invalid/21.jpg',
        ),
      );

      await show(
        tester,
        RelationshipDisplay(
          post: samplePost(
            id: 10,
            relationships: const Relationships(
              parentId: null,
              hasChildren: true,
              hasActiveChildren: true,
              children: [21],
            ),
          ),
        ),
        filter: PostFilter(env.client),
      );

      expect(find.byIcon(Icons.block), findsOneWidget);
      expect(find.byType(PostImageWidget), findsNothing);
    });
  });

  group('PoolDisplay', () {
    displayTest('names a cached pool and its size', (tester) async {
      env.client.pools.poolCache.set(
        samplePool(id: 30, name: 'sample_pool', postIds: const [21, 22, 23]),
      );

      await show(
        tester,
        PoolDisplay(post: samplePost(id: 10, pools: const [30])),
      );

      expect(find.text('sample pool'), findsOneWidget);
      expect(find.text('3 posts'), findsOneWidget);
    });

    displayTest('falls back to the id while a pool resolves', (tester) async {
      await show(
        tester,
        PoolDisplay(post: samplePost(id: 10, pools: const [30])),
      );

      expect(find.text('#30'), findsOneWidget);
    });

    displayTest('shows nothing when a post has no pools', (tester) async {
      await show(tester, PoolDisplay(post: samplePost(id: 10)));

      expect(find.text('Pools'), findsNothing);
    });
  });
}
