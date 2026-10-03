import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notified_preferences/notified_preferences.dart';
import 'package:provider/provider.dart';

import '../../_support/fake_e621.dart';
import '../../_support/harness.dart';
import '../../_support/images.dart';
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
    client = Client(
      identity: Identity(id: 1, host: fake.url, username: null, headers: null),
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
    // The fake clock would otherwise leave dio's timeout timers pending
    // on requests that are still in flight when the test ends.
    client.dio.options.connectTimeout = null;
    client.dio.options.receiveTimeout = null;
  });

  tearDown(() async {
    traits.dispose();
    await fake.stop();
  });

  Future<void> show(
    WidgetTester tester,
    Widget child, {
    PostFilter? filter,
  }) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<Client>.value(value: client),
            Provider<BaseCacheManager>.value(
              value: const NoImageCacheManager(),
            ),
            if (filter != null)
              ListenableProvider<FilterController<Post>>.value(value: filter),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: SingleChildScrollView(child: child)),
          ),
        ),
      );
      // The displays fetch what they could not resolve, so that request has
      // to land before the tree is torn down.
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await tester.pump();
  }

  group('RelationshipDisplay', () {
    displayTest('names the artists of a cached parent', (tester) async {
      client.posts.postCache.set(
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
        client.posts.postCache.set(samplePost(id: id));
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
      traits.value = traits.value.copyWith(denylist: const ['bad_tag']);
      client.posts.postCache.set(
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
        filter: PostFilter(client),
      );

      expect(find.byIcon(Icons.block), findsOneWidget);
      expect(find.byType(PostImageWidget), findsNothing);
    });
  });

  group('PoolDisplay', () {
    displayTest('names a cached pool and its size', (tester) async {
      client.pools.poolCache.set(
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
