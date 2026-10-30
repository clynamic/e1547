import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/identity/identity.dart';
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

import '../../_support/fake_e621.dart';
import '../../_support/harness.dart';
import '../../_support/images.dart';
import '../../_support/video.dart';

void main() {
  test('each feed searches its own query', () {
    expect(browseFeedTags(BrowseFeed.latest, PopularScale.day), '');
    expect(browseFeedTags(BrowseFeed.hot, PopularScale.day), 'order:rank');
    expect(
      browseFeedTags(BrowseFeed.popular, PopularScale.month),
      'order:score date:month',
    );
  });

  group('BrowseHeader', () {
    late FakeE621 fake;
    late Client client;
    late ValueNotifier<Traits> traits;
    late AppDatabase sqlite;

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
      await sqlite.close();
    });

    int toggles = 0;

    Future<List<(BrowseFeed, PopularScale)>> show(
      WidgetTester tester, {
      required bool picking,
      BrowseFeed feed = BrowseFeed.hot,
    }) async {
      final List<(BrowseFeed, PopularScale)> picked = [];
      toggles = 0;
      await tester.pumpWidget(
        Provider<Client>.value(
          value: client,
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    BrowseHeader(
                      feed: feed,
                      scale: PopularScale.week,
                      picking: picking,
                      onToggle: () => toggles++,
                    ),
                    BrowseFeedPicker(
                      feed: feed,
                      scale: PopularScale.week,
                      picking: picking,
                      onPick: (feed, scale) => picked.add((feed, scale)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)),
      );
      await tester.pumpAndSettle();
      return picked;
    }

    displayTest('the header names the current feed', (tester) async {
      await show(tester, picking: false);

      expect(find.text('Hot'), findsOneWidget);
      expect(find.text('Latest'), findsNothing);
    });

    displayTest('Popular shows its period under the name', (tester) async {
      await show(tester, picking: false, feed: BrowseFeed.popular);

      expect(find.text('This week'), findsOneWidget);
      expect(
        tester.getTopLeft(find.text('This week')).dy,
        greaterThan(tester.getBottomLeft(find.text('Popular')).dy - 1),
      );
    });

    displayTest('the whole header row opens the feeds', (tester) async {
      await show(tester, picking: false);

      final Rect header = tester.getRect(find.byType(BrowseHeader));
      final double width =
          tester.view.physicalSize.width / tester.view.devicePixelRatio;
      await tester.tapAt(Offset(width - 20, header.center.dy));

      expect(toggles, 1);
    });

    displayTest('each feed card shows the icon of its feed', (tester) async {
      await show(tester, picking: true);

      for (final BrowseFeed feed in BrowseFeed.values) {
        expect(
          find.descendant(
            of: find.widgetWithText(BrowseFeedCard, feed.label),
            matching: find.byIcon(feed.icon),
          ),
          findsOneWidget,
        );
      }
    });

    displayTest('unfolded, the feeds keep their order and check the current', (
      tester,
    ) async {
      await show(tester, picking: true, feed: BrowseFeed.popular);

      final Finder cards = find.byType(BrowseFeedCard);
      expect(tester.widgetList<BrowseFeedCard>(cards).map((e) => e.feed), [
        BrowseFeed.hot,
        BrowseFeed.latest,
        BrowseFeed.popular,
        BrowseFeed.timeline,
      ]);
      expect(
        find.descendant(
          of: find.widgetWithText(BrowseFeedCard, 'Popular'),
          matching: find.byIcon(Icons.check),
        ),
        findsOneWidget,
      );
    });

    displayTest('a tapped feed is picked with the current period', (
      tester,
    ) async {
      final picked = await show(tester, picking: true);

      await tester.tap(find.text('Latest'));

      expect(picked, [(BrowseFeed.latest, PopularScale.week)]);
    });

    displayTest('a tapped period picks Popular for that period', (
      tester,
    ) async {
      final picked = await show(tester, picking: true);

      await tester.tap(find.text('Day'));

      expect(picked, [(BrowseFeed.popular, PopularScale.day)]);
    });

    Future<Settings> showPage(
      WidgetTester tester, {
      BrowseFeed? feed,
      bool settled = true,
    }) async {
      final Settings settings = Settings(await SharedPreferences.getInstance());
      if (feed != null) settings.browseFeed.value = feed;
      final AnyRouteObserver routeObserver = AnyRouteObserver();
      final VideoService videos = fakeVideoService();
      addTearDown(videos.dispose);
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<Client>.value(value: client),
            Provider<Settings>.value(value: settings),
            Provider<BaseCacheManager>.value(
              value: const NoImageCacheManager(),
            ),
            Provider<AnyRouteObserver>.value(value: routeObserver),
            ChangeNotifierProvider<VideoService>.value(value: videos),
          ],
          child: MaterialApp(
            theme: AppTheme.dark.data,
            navigatorObservers: [routeObserver],
            localizationsDelegates: testLocalizations,
            home: const BrowsePage(),
          ),
        ),
      );
      if (!settled) return settings;
      await tester.runAsync(() async {
        for (int i = 0; i < 6; i++) {
          await tester.pump(const Duration(milliseconds: 50));
          await Future<void>.delayed(const Duration(milliseconds: 50));
        }
      });
      await tester.pumpAndSettle();
      return settings;
    }

    displayTest('tapping the dimmed feed folds the picker', (tester) async {
      await showPage(tester);
      await tester.tap(find.text('Latest'));
      await tester.pumpAndSettle();
      expect(find.byType(BrowseFeedCard), findsNWidgets(4));

      await tester.tapAt(
        tester.getBottomLeft(find.byType(Scaffold)) + const Offset(20, -20),
      );
      await tester.pumpAndSettle();

      expect(find.byType(BrowseFeedCard), findsNothing);
    });

    displayTest('a picked feed is remembered', (tester) async {
      final Settings settings = await showPage(tester);
      await tester.tap(find.text('Latest'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Hot'));
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)),
      );
      await tester.pumpAndSettle();

      expect(settings.browseFeed.value, BrowseFeed.hot);
      expect(find.byType(BrowseFeedCard), findsNothing);
    });

    displayTest('Timeline without follows says it has no tags', (tester) async {
      await show(tester, picking: true);

      expect(find.text('No tags'), findsOneWidget);
    });

    displayTest('the timeline loads behind feed skeletons', (tester) async {
      await client.follows.create(tags: 'tag_32', type: FollowType.update);

      await showPage(tester, feed: BrowseFeed.timeline, settled: false);
      await tester.pump();

      expect(find.byType(PostFeedSkeleton), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      await tester.runAsync(() async {
        for (int i = 0; i < 6; i++) {
          await tester.pump(const Duration(milliseconds: 50));
          await Future<void>.delayed(const Duration(milliseconds: 50));
        }
      });
      await tester.pumpAndSettle();
    });

    displayTest(
      'a timeline post shows its artist in the artist hue, comments and description',
      (tester) async {
        await client.follows.create(tags: 'tag_32', type: FollowType.update);

        await showPage(tester, feed: BrowseFeed.timeline);

        final Finder first = find.byType(PostFeedTile).first;
        expect(tester.widget<PostFeedTile>(first).post.id, 1000);
        Finder inFirst(Finder finder) =>
            find.descendant(of: first, matching: finder);
        expect(inFirst(find.text('tag 32')), findsOneWidget);
        expect(inFirst(find.text('450')), findsOneWidget);
        expect(
          inFirst(
            find.textContaining('Recorded text with', findRichText: true),
          ),
          findsOneWidget,
        );
        final Container mark = tester.widget<Container>(
          find
              .ancestor(
                of: inFirst(find.text('tag 32')),
                matching: find.byType(Container),
              )
              .first,
        );
        expect(
          ((mark.decoration! as BoxDecoration).border! as Border).left.color,
          TagCategory.artist.colorFor(Brightness.dark),
        );
      },
    );

    displayTest('a timeline post opens on its own', (tester) async {
      await client.follows.create(tags: 'tag_32', type: FollowType.update);
      await showPage(tester, feed: BrowseFeed.timeline);

      await tester.tap(find.byType(PostImageTile).first);
      await tester.runAsync(() async {
        for (int i = 0; i < 6; i++) {
          await tester.pump(const Duration(milliseconds: 50));
          await Future<void>.delayed(const Duration(milliseconds: 50));
        }
      });
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(PostFullscreenGallery), findsNothing);
      expect(
        tester.widget<PostFullscreen>(find.byType(PostFullscreen)).post.id,
        1000,
      );
    });
  });
}
