import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/bed.dart';
import '../../_support/fixtures.dart';
import '../../_support/harness.dart';
import '../../_support/pools.dart';
import '../../_support/posts.dart';

void main() {
  late TestBed bed;

  setUpAll(initializeTestApp);

  setUp(() async => bed = await TestBed.start(signedIn: true));

  tearDown(() => bed.dispose());

  Future<void> show(WidgetTester tester, Widget child) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        bed.app(
          HandednessScope(
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
      );
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await bed.settle(tester, animating: true);
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

  displayTest('a family thumbnail loads a post it has not seen', (
    tester,
  ) async {
    await show(
      tester,
      PostFamilySection(
        post: samplePost(
          id: 10,
          relationships: const Relationships(
            parentId: 1000,
            hasChildren: false,
            hasActiveChildren: null,
            children: [],
          ),
        ),
      ),
    );

    expect(
      find.descendant(
        of: find.byType(PostThumbnail),
        matching: find.byType(PostImageWidget),
      ),
      findsOneWidget,
    );
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
    bed.client.pools.poolCache.set(
      samplePool(id: 30, name: 'sample_pool', postIds: const [21, 10, 23]),
    );
    bed.client.pools.poolCache.set(
      samplePool(
        id: 31,
        name: 'sample_collection',
        postIds: const [10, 22],
      ).copyWith(category: PoolCategory.collection),
    );

    await show(
      tester,
      PostPoolsSection(post: samplePost(id: 10, pools: const [30, 31])),
    );

    expect(find.text('sample pool'), findsOneWidget);
    expect(find.text('Series · page 2 of 3'), findsOneWidget);
    expect(find.text('Collection · page 1 of 2'), findsOneWidget);
  });

  displayTest('each artist name opens its own search', (tester) async {
    await show(
      tester,
      PostDetailHeader(
        post: samplePost(
          tags: const {
            'artist': ['first_artist', 'second_artist'],
          },
        ),
      ),
    );

    await tester.tap(find.textContaining('second artist'));
    await bed.settle(tester);

    expect(
      tester.widget<PostsPage>(find.byType(PostsPage)).params?.tags,
      'second_artist',
    );
  });

  displayTest('a post whose artist tags are all warnings reads no artist', (
    tester,
  ) async {
    await show(
      tester,
      PostDetailHeader(
        post: samplePost(
          tags: const {
            'artist': ['conditional_dnp', 'sound_warning'],
          },
        ),
      ),
    );

    expect(find.text('no artist'), findsOneWidget);
    expect(find.textContaining('conditional'), findsNothing);
  });

  displayTest('the pool strip shows the neighbours of this post and rings it', (
    tester,
  ) async {
    bed.client.pools.poolCache.set(
      samplePool(id: 30, postIds: List.generate(9, (i) => i + 1)),
    );
    bed.client.posts.postCache.savePage([
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

  displayTest('tags group by category with artists first and general last', (
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

    expect(bed.settings.collapsedPostSections.value, ['tags']);
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

  testWidgets('a long description is at its preview height from the start', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PostDescription(
            post: samplePost().copyWith(
              description: List.filled(12, 'A line').join('\n'),
            ),
          ),
        ),
      ),
    );

    expect(
      tester.getSize(find.byType(HeightLimit)).height,
      PostDescription.previewHeight,
    );
  });

  displayTest('the comments line reads the newest comment its filter allows', (
    tester,
  ) async {
    final List<Map<String, Object?>> comments = loadFixtureList('comments.json')
      ..sort((a, b) => (b['id']! as int).compareTo(a['id']! as int));
    bed.traits.value = bed.traits.value.copyWith(
      denylist: ['user:${comments.first['creator_id']}'],
    );

    await show(
      tester,
      PostCommentsLine(
        post: samplePost(
          id: comments.first['post_id']! as int,
        ).copyWith(commentCount: 3),
      ),
    );

    expect(
      find.textContaining('${comments[1]['creator_name']} · Recorded text'),
      findsOneWidget,
    );
    expect(find.textContaining('COMMENTS 3', findRichText: true), findsOne);
    expect(
      bed.fake.requests
          .where((e) => e.path == '/comments.json')
          .map((e) => e.query['limit']),
      everyElement('5'),
    );
  });

  displayTest('More by the artist leaves out this post and blacklisted ones', (
    tester,
  ) async {
    bed.traits.value = bed.traits.value.copyWith(denylist: ['tag_48']);

    await show(
      tester,
      FilterControllerProvider<PostFilter, Post>(
        create: (_) => PostFilter(bed.client),
        child: PostArtistSection(
          post: samplePost(
            id: 1000,
            tags: const {
              'artist': ['tag_32'],
            },
          ),
        ),
      ),
    );

    expect(thumbnails(tester), [1042]);
    expect(
      bed.fake.requests
          .where((e) => e.path == '/posts.json')
          .map((e) => e.query['limit']),
      everyElement('12'),
    );
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

  displayTest('More opens its menu above the tab navigator', (tester) async {
    await show(
      tester,
      SizedBox(
        height: 400,
        child: Navigator(
          onGenerateRoute: (_) => MaterialPageRoute(
            builder: (context) => Align(
              alignment: Alignment.bottomCenter,
              child: PostToolbar(post: samplePost()),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();

    final NavigatorState root = tester.state<NavigatorState>(
      find.byType(Navigator).first,
    );
    expect(Navigator.of(tester.element(find.text('Edit'))), same(root));
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

  displayTest('the favorite button is pink only for a favorite', (
    tester,
  ) async {
    for (final (bool favorited, IconData icon, Color? color) in [
      (true, Icons.favorite, Colors.pinkAccent),
      (false, Icons.favorite_border, null),
    ]) {
      await show(
        tester,
        PostToolbar(
          key: ValueKey(favorited),
          post: samplePost(isFavorited: favorited),
        ),
      );

      final Icon heart = tester.widget<Icon>(
        find.descendant(
          of: find.byType(FavoriteButton),
          matching: find.byType(Icon),
        ),
      );
      expect(heart.icon, icon);
      expect(heart.color == Colors.pinkAccent, color == Colors.pinkAccent);
    }
  });

  displayTest('the favorite button is at the edge of the holding hand', (
    tester,
  ) async {
    for (final (Handedness hand, bool left) in [
      (Handedness.right, false),
      (Handedness.left, true),
    ]) {
      bed.settings.handedness.value = hand;
      await show(tester, PostToolbar(post: samplePost()));

      final double favorite = tester.getCenter(find.byType(FavoriteButton)).dx;
      final double share = tester.getCenter(find.byIcon(Icons.share)).dx;
      expect(favorite < share, left, reason: hand.name);
    }
  });
}
