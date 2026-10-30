import 'dart:math';

import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notified_preferences/notified_preferences.dart';

import '../../_support/fake_e621.dart';
import '../../_support/harness.dart';
import '../../_support/images.dart';
import '../../_support/posts.dart';

void main() {
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
        denylist: ['spider', 'gore'],
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

  bool animating = false;

  Future<void> settle(WidgetTester tester) async {
    await tester.runAsync(() async {
      for (int i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 50));
        await Future<void>.delayed(const Duration(milliseconds: 50));
      }
    });
    if (animating) {
      await tester.pump(const Duration(milliseconds: 300));
    } else {
      await tester.pumpAndSettle();
    }
  }

  Future<void> show(
    WidgetTester tester,
    Widget child, {
    PostFilter? filter,
    PostParamsController? params,
  }) async {
    final PostFilter postFilter = filter ?? PostFilter(client);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<Client>.value(value: client),
          Provider<BaseCacheManager>.value(value: const NoImageCacheManager()),
          Provider<Settings>.value(
            value: Settings(await SharedPreferences.getInstance()),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: testLocalizations,
          home: FilterControllerProvider<PostFilter, Post>.value(
            value: postFilter,
            child: ChangeNotifierProvider.value(
              value: params ?? PostParamsController(),
              child: Scaffold(body: child),
            ),
          ),
        ),
      ),
    );
    await settle(tester);
  }

  displayTest('a cover whose post has no image stays empty', (tester) async {
    client.posts.postCache.savePage([samplePost(id: 9)]);
    await show(
      tester,
      const SizedBox.square(dimension: 64, child: PostCover(id: 9)),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(PostImageWidget), findsNothing);
  });

  Future<List<Rect>> showSkeleton(
    WidgetTester tester,
    GridQuilt stagger,
  ) async {
    await show(
      tester,
      TileLayout(
        tileSize: 200,
        stagger: stagger,
        child: CustomScrollView(
          slivers: [
            PostGridSliver(
              state: PagingState<int, Post>(isLoading: true),
              fetchNextPage: () {},
            ),
          ],
        ),
      ),
    );
    return tester
        .widgetList<Container>(
          find.descendant(
            of: find.byType(PostGridSkeleton),
            matching: find.byType(Container),
          ),
        )
        .map((e) => tester.getRect(find.byWidget(e)))
        .toList();
  }

  testWidgets('a square grid loads behind tiles of its exact size', (
    tester,
  ) async {
    final List<Rect> tiles = await showSkeleton(tester, GridQuilt.square);

    expect(tiles, isNotEmpty);
    for (final Rect tile in tiles) {
      expect(tile.size, const Size(192, 232));
    }
  });

  testWidgets('a masonry grid loads behind columns that start at the top', (
    tester,
  ) async {
    final List<Rect> tiles = await showSkeleton(tester, GridQuilt.vertical);

    final double top = tiles.map((e) => e.top).reduce(min);
    final Set<double> columns = tiles.map((e) => e.left).toSet();
    expect(columns, hasLength(4));
    for (final double left in columns) {
      expect(
        tiles.where((e) => e.left == left).map((e) => e.top).reduce(min),
        top,
      );
    }
    expect(tiles.map((e) => e.height).toSet().length, greaterThan(1));
  });

  testWidgets('a feed loads behind feed skeletons', (tester) async {
    await show(
      tester,
      CustomScrollView(
        slivers: [
          PostTimelineSliver(
            state: PagingState<int, Post>(isLoading: true),
            fetchNextPage: () {},
          ),
        ],
      ),
    );

    expect(find.byType(PostFeedSkeleton), findsOneWidget);
    expect(find.byType(PostGridSkeleton), findsNothing);
  });

  displayTest('no posts offers to remove the last term in a new page', (
    tester,
  ) async {
    final PostParamsController params = PostParamsController(
      initial: const PostParams(tags: 'riolu solo rating:s'),
    );
    addTearDown(params.dispose);
    await show(tester, const PostResultsEmpty(), params: params);

    expect(find.text('No posts'), findsOneWidget);
    await tester.tap(find.text('Remove rating:s'));
    await settle(tester);

    expect(
      tester.widget<PostsPage>(find.byType(PostsPage).last).params?.tags,
      'riolu solo',
    );
    expect(params.value.tags, 'riolu solo rating:s');
  });

  testWidgets('a feed with no posts offers nothing to remove', (tester) async {
    final PostParamsController params = PostParamsController(
      initial: const PostParams(tags: 'order:rank'),
      canSearch: false,
    );
    addTearDown(params.dispose);
    await show(tester, const PostResultsEmpty(), params: params);

    expect(find.text('No posts'), findsOneWidget);
    expect(find.textContaining('Remove'), findsNothing);
  });

  displayTest('a page the blacklist emptied names its lines and shows them', (
    tester,
  ) async {
    final PostFilter filter = PostFilter(client)
      ..track('page', [
        samplePost(
          tags: const {
            'general': ['spider'],
          },
        ),
        samplePost(
          id: 2,
          tags: const {
            'general': ['spider', 'gore'],
          },
        ),
      ]);
    addTearDown(filter.dispose);
    await show(tester, const PostResultsEmpty(), filter: filter);

    expect(find.text('2 posts hidden'), findsOneWidget);
    expect(find.text('No posts'), findsNothing);
    expect(
      tester.getTopLeft(find.text('spider')).dy,
      lessThan(tester.getTopLeft(find.text('gore')).dy),
    );
    await tester.tap(find.text('Show 2 posts'));

    expect(filter.denying, isFalse);
  });

  testWidgets('a lost connection says the host did not answer', (tester) async {
    int retries = 0;
    await show(
      tester,
      PostResultsFailure(
        error: DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.connectionError,
        ),
        onRetry: () => retries++,
      ),
    );

    expect(find.text('No connection'), findsOneWidget);
    expect(
      find.text('${Uri.parse(fake.url).host} did not answer.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Retry'));
    expect(retries, 1);
  });

  testWidgets('a server error says the page did not load', (tester) async {
    await show(
      tester,
      PostResultsFailure(
        error: DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.badResponse,
          response: Response(requestOptions: RequestOptions(), statusCode: 503),
        ),
      ),
    );

    expect(find.text('Did not load'), findsOneWidget);
    expect(find.text('No connection'), findsNothing);
  });

  int fetches = 0;

  Future<void> showGrid(
    WidgetTester tester,
    PagingState<int, Post> state,
  ) async {
    fetches = 0;
    final PostFilter filter = PostFilter(client)
      ..track('page', [
        samplePost(
          id: 7,
          tags: const {
            'general': ['spider'],
          },
        ),
      ]);
    addTearDown(filter.dispose);
    await show(
      tester,
      TileLayout(
        child: CustomScrollView(
          slivers: [
            PostGridSliver(state: state, fetchNextPage: () => fetches++),
          ],
        ),
      ),
      filter: filter,
    );
    await tester.scrollUntilVisible(
      find.byType(LoadMoreFooter),
      200,
      scrollable: find.byType(Scrollable).first,
    );
  }

  final List<Post> shown = [samplePost(id: 3), samplePost(id: 4)];

  displayTest(
    'a later page loads under a moving hexagon and the hidden count',
    (tester) async {
      animating = true;
      addTearDown(() => animating = false);
      await showGrid(
        tester,
        PagingState(pages: [shown], keys: const [1], isLoading: true),
      );

      final LoadMoreFooter footer = tester.widget(find.byType(LoadMoreFooter));
      expect(footer.state, LoadMoreState.loading);
      expect(find.text('1 hidden so far'), findsOneWidget);
    },
  );

  displayTest('a page that did not load names itself and retries', (
    tester,
  ) async {
    await showGrid(
      tester,
      PagingState(
        pages: [shown, shown],
        keys: const [1, 2],
        error: Exception('failed'),
      ),
    );

    expect(find.text('Page 3 did not load'), findsOneWidget);
    final int before = fetches;
    await tester.tap(find.text('Retry'));
    expect(fetches, before + 1);
  });

  displayTest('the end of the results closes the hexagon', (tester) async {
    await showGrid(
      tester,
      PagingState(pages: [shown], keys: const [1], hasNextPage: false),
    );

    final LoadMoreFooter footer = tester.widget(find.byType(LoadMoreFooter));
    expect(footer.state, LoadMoreState.end);
    expect(find.text('No more posts'), findsOneWidget);
  });

  Future<void> pull(WidgetTester tester) async {
    await tester.drag(
      find.byType(CustomScrollView).first,
      const Offset(0, 500),
    );
    await tester.pump();
    await tester.runAsync(() async {
      for (int i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 50));
        await Future<void>.delayed(const Duration(milliseconds: 50));
      }
    });
    await tester.pump(const Duration(milliseconds: 300));
  }

  displayTest('a refresh that brings nothing new says so', (tester) async {
    await show(tester, const PostsPage());
    expect(find.byType(PostTile), findsWidgets);

    await pull(tester);

    expect(find.text('Up to date'), findsOneWidget);
    await tester.pump(refreshNoteDuration);
    await tester.pumpAndSettle();
    expect(find.text('Up to date'), findsNothing);
  });

  displayTest('a refresh that fails keeps the page and offers a retry', (
    tester,
  ) async {
    await show(tester, const PostsPage());
    final int shown = find.byType(PostTile).evaluate().length;
    final String host = Uri.parse(fake.url).host;
    await tester.runAsync(fake.stop);

    await pull(tester);

    expect(find.text('$host did not answer.'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(RefreshFailedNote),
        matching: find.text('Retry'),
      ),
      findsOneWidget,
    );
    expect(find.byType(PostTile).evaluate().length, shown);
    await tester.pump(refreshNoteDuration);
    await tester.pumpAndSettle();
  });

  displayTest('holding a post turns the dock into the selection bar', (
    tester,
  ) async {
    final NavBarDocks docks = NavBarDocks();
    addTearDown(docks.dispose);
    await show(tester, NavBarDockScope(docks: docks, child: const PostsPage()));
    expect(docks.full, isFalse);
    expect(docks.current, isNotNull);

    await tester.longPress(find.byType(PostTile).first);
    await tester.pump();
    await tester.pump();

    expect(docks.full, isTrue);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: Builder(builder: docks.current!)),
      ),
    );
    expect(find.text('1 post'), findsOneWidget);
  });
}
