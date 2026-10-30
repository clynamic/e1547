import 'dart:io';

import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notified_preferences/notified_preferences.dart';
import 'package:relative_time/relative_time.dart';

import '../../_support/fake_e621.dart';
import '../../_support/fixtures.dart';
import '../../_support/harness.dart';
import '../../_support/images.dart';
import '../../_support/posts.dart';

Pool samplePool({
  required int id,
  String name = 'a_pool',
  List<int> postIds = const [],
}) => Pool(
  id: id,
  name: name,
  createdAt: DateTime.utc(2020),
  updatedAt: DateTime.utc(2020),
  description: '',
  postIds: postIds,
  postCount: postIds.length,
  active: true,
);

void main() {
  late FakeE621 fake;
  late Client client;
  late ValueNotifier<Traits> traits;
  late AppDatabase sqlite;
  late Settings settings;

  setUpAll(() async {
    await initializeTestApp();
    sqlite = AppDatabase(NativeDatabase.memory());
  });

  tearDownAll(() => sqlite.close());

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    settings = Settings(await SharedPreferences.getInstance());
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
      identity: Identity(
        id: 1,
        host: fake.url,
        username: 'tester',
        headers: {
          HttpHeaders.authorizationHeader: const Credentials(
            username: 'tester',
            password: 'key',
          ).basicAuth,
        },
      ),
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

  Future<void> show(WidgetTester tester, Widget child) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<Client>.value(value: client),
            Provider<Settings>.value(value: settings),
            Provider<BaseCacheManager>.value(
              value: const NoImageCacheManager(),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              DefaultMaterialLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
              RelativeTimeLocalizations.delegate,
            ],
            home: HandednessScope(
              child: Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [child],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await tester.pump();
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump();
  }

  List<int> thumbnails(WidgetTester tester) => tester
      .widgetList<PostThumbnail>(find.byType(PostThumbnail))
      .map((e) => e.id)
      .toList();

  displayTest('a post opened alone under the tab bar keeps no room for it', (
    tester,
  ) async {
    const double bar = 70;
    await tester.runAsync(() async {
      await tester.pumpWidget(
        bed.app(
          Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(padding: const EdgeInsets.only(bottom: bar)),
              child: NavBarInset(
                space: bar,
                child: HandednessScope(child: PostDetail(post: samplePost())),
              ),
            ),
          ),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await bed.settle(tester, animating: true);

    final Finder fade = find.descendant(
      of: find.byType(PostDetail),
      matching: find.byWidgetPredicate(
        (e) =>
            e is DecoratedBox &&
            e.decoration is BoxDecoration &&
            (e.decoration as BoxDecoration).gradient is LinearGradient,
      ),
    );
    expect(tester.getSize(fade.last).height, postToolbarFadeHeight);
    final double height =
        tester.view.physicalSize.height / tester.view.devicePixelRatio;
    final Finder row = find
        .descendant(of: find.byType(PostToolbar), matching: find.byType(Row))
        .first;
    expect(tester.getRect(row).bottom, height - 16);
  });

  displayTest('the family shows the parent and each child labelled', (
    tester,
  ) async {
    await show(
      tester,
      PostFamilySection(
        post: samplePost(
          id: 10,
          relationships: const Relationships(
            parentId: 20,
            hasChildren: true,
            hasActiveChildren: true,
            children: [21, 22],
          ),
        ),
      ),
    );

    expect(thumbnails(tester), [20, 21, 22]);
    expect(find.text('Parent'), findsOneWidget);
    expect(find.text('Child'), findsNWidgets(2));
  });

  displayTest('the family drops children the server marked inactive', (
    tester,
  ) async {
    await show(
      tester,
      PostFamilySection(
        post: samplePost(
          id: 10,
          relationships: const Relationships(
            parentId: 20,
            hasChildren: true,
            hasActiveChildren: false,
            children: [21],
          ),
        ),
      ),
    );

    expect(thumbnails(tester), [20]);
  });

  displayTest('a pool names itself, its kind and the page of this post', (
    tester,
  ) async {
    client.pools.poolCache.set(
      samplePool(id: 30, name: 'sample_pool', postIds: const [21, 10, 23]),
    );

    await show(
      tester,
      PostPoolsSection(post: samplePost(id: 10, pools: const [30])),
    );

    expect(find.text('sample pool'), findsOneWidget);
    expect(find.text('Series · page 2 of 3'), findsOneWidget);
  });

  displayTest('the pool strip shows the neighbours of this post and rings it', (
    tester,
  ) async {
    client.pools.poolCache.set(
      samplePool(id: 30, postIds: List.generate(9, (i) => i + 1)),
    );
    client.posts.postCache.savePage([
      for (int id = 1; id <= 9; id++) samplePost(id: id),
    ]);

    for (final (int current, List<int> expected) in [
      (5, [3, 4, 5, 6, 7]),
      (1, [1, 2, 3, 4, 5]),
      (9, [5, 6, 7, 8, 9]),
    ]) {
      await show(
        tester,
        PostPoolsSection(
          key: ValueKey(current),
          post: samplePost(id: current, pools: const [30]),
        ),
      );

      expect(thumbnails(tester), expected);
      expect(
        tester
            .widgetList<PostThumbnail>(find.byType(PostThumbnail))
            .where(
              (thumbnail) => find
                  .descendant(
                    of: find.byWidget(thumbnail),
                    matching: find.byWidgetPredicate(
                      (e) =>
                          e is DecoratedBox &&
                          e.decoration is BoxDecoration &&
                          (e.decoration as BoxDecoration).border != null,
                    ),
                  )
                  .evaluate()
                  .isNotEmpty,
            )
            .map((e) => e.id),
        [current],
      );
    }
  });

  displayTest('tags group by category in the order of the site', (
    tester,
  ) async {
    await show(
      tester,
      PostTagsSection(
        post: samplePost(
          tags: const {
            'general': ['solo'],
            'species': ['riolu'],
            'artist': ['sample_artist'],
          },
        ),
      ),
    );

    expect(
      tester
          .widgetList<PostSectionTitle>(find.byType(PostSectionTitle))
          .map((e) => e.label),
      ['Tags', 'artist', 'species', 'general'],
    );
    expect(
      tester.widgetList<QueryChip>(find.byType(QueryChip)).map((e) => e.term),
      ['sample_artist', 'riolu', 'solo'],
    );
  });

  displayTest('a collapsed section stays collapsed on the next post', (
    tester,
  ) async {
    final Post first = samplePost(
      tags: const {
        'general': ['solo'],
      },
    );
    await show(tester, PostTagsSection(post: first));

    await tester.tap(find.byIcon(Icons.expand_less));
    await tester.pump();
    await show(
      tester,
      PostTagsSection(
        key: const ValueKey(2),
        post: first.copyWith(
          id: 2,
          tags: const {
            'general': ['duo'],
          },
        ),
      ),
    );

    expect(settings.collapsedPostSections.value, ['tags']);
    expect(find.byType(QueryChip), findsNothing);
    expect(find.text('duo'), findsOneWidget);
    expect(find.byIcon(Icons.expand_more), findsOneWidget);
  });

  displayTest('a long description shows its start and opens on Show more', (
    tester,
  ) async {
    final Post post = samplePost().copyWith(
      description: List.filled(12, 'A line of the description.').join('\n'),
    );
    await show(tester, PostDescription(post: post));
    final double preview = tester.getSize(find.byType(PostDescription)).height;

    await tester.tap(find.text('Show more'));
    await tester.pump();

    expect(
      tester.getSize(find.byType(PostDescription)).height,
      greaterThan(preview + 22 * 6),
    );
    expect(find.text('Show less'), findsOneWidget);
  });

  displayTest('the comments line reads the newest comment', (tester) async {
    final Map<String, Object?> newest = loadFixtureList('comments.json').first;

    await show(
      tester,
      PostCommentsLine(
        post: samplePost(
          id: newest['post_id']! as int,
        ).copyWith(commentCount: 3),
      ),
    );

    expect(
      find.textContaining('${newest['creator_name']} · Recorded text'),
      findsOneWidget,
    );
    expect(find.textContaining('COMMENTS 3', findRichText: true), findsOne);
  });

  displayTest('details read the file as type, size and weight', (tester) async {
    await show(
      tester,
      PostDetailsSection(
        post: samplePost(ext: 'png', width: 2480, height: 3508, size: 2516582),
      ),
    );

    expect(find.text('PNG · 2480 × 3508 · 2.4 MB'), findsOneWidget);
  });

  displayTest('More offers edit, report, flag and browse', (tester) async {
    await show(tester, PostToolbar(post: samplePost()));

    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();

    expect(
      tester
          .widgetList(find.byWidgetPredicate((e) => e is PopupMenuTile))
          .map((e) => (e as PopupMenuTile).title),
      ['Edit', 'Report', 'Flag', 'Browse'],
    );
  });

  displayTest('the favorite button is at the edge of the holding hand', (
    tester,
  ) async {
    for (final (Handedness hand, bool left) in [
      (Handedness.right, false),
      (Handedness.left, true),
    ]) {
      settings.handedness.value = hand;
      await show(tester, PostToolbar(post: samplePost()));

      final double favorite = tester.getCenter(find.byType(FavoriteButton)).dx;
      final double share = tester.getCenter(find.byIcon(Icons.share)).dx;
      expect(favorite < share, left, reason: hand.name);
    }
  });
}
