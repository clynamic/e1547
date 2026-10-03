import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/l10n/app_localizations.dart';
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
  late Settings settings;

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
    settings = Settings(await SharedPreferences.getInstance());
  });

  tearDown(() async {
    traits.dispose();
    await fake.stop();
  });

  /// Pumps [home] under the providers a posts page expects, in chinese.
  ///
  /// With [wait], the page's search is given time to land before the frame.
  Future<void> pumpApp(
    WidgetTester tester, {
    Widget? home,
    bool wait = true,
  }) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.runAsync(() async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<Client>.value(value: client),
            Provider<BaseCacheManager>.value(
              value: const NoImageCacheManager(),
            ),
            Provider<Settings>.value(value: settings),
          ],
          child: MaterialApp(
            locale: const Locale('zh'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: home,
          ),
        ),
      );
      if (wait) {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
    });
    await tester.pump();
  }

  /// Lets requests and animations an interaction started land.
  Future<void> settle(WidgetTester tester) async {
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    // The requests wait on timers of the clock in addition to real time, so
    // the frame that lands their state also advances the clock for them.
    await tester.pump(const Duration(milliseconds: 100));
  }

  /// The page arguments of the page list requests the fake served.
  List<String> listPages() => [
    for (final request in fake.requests)
      if (request.path == '/posts.json') request.query['page']!,
  ];

  /// The query of the search of a page with [tags].
  InfiniteQuery<List<int>, Object> pageQuery(String? tags) =>
      client.posts.usePage(query: PostParams(tags: tags).toQuery());

  displayTest('a posts page reports its paging progress in a footer', (
    tester,
  ) async {
    await pumpApp(tester, home: const PostsPage(), wait: false);

    // Nothing has loaded yet, so there is nothing to report.
    expect(find.byIcon(Icons.onetwothree), findsNothing);
    expect(find.byType(PostListFooter), findsNothing);

    await settle(tester);

    expect(find.byType(PostListFooter), findsOneWidget);
    expect(find.text('第 1 页 · 3 个帖子'), findsOneWidget);
    expect(find.byIcon(Icons.onetwothree), findsOneWidget);
    expect(
      find.byTooltip('跳转页面'),
      findsOneWidget,
      reason: 'the jump button must be discoverable',
    );
    // The search has not ended, so no page limit is reported.
    expect(find.text('已达服务器页数上限，请缩小搜索范围'), findsNothing);
  });

  displayTest('a posts page hides its footer for an empty search', (
    tester,
  ) async {
    await pumpApp(
      tester,
      home: const PostsPage(params: PostParams(tags: 'id:0')),
    );
    await settle(tester);

    expect(find.text('没有帖子'), findsOneWidget);
    expect(find.text('第 1 页 · 0 个帖子'), findsNothing);
    expect(find.byIcon(Icons.onetwothree), findsNothing);
  });

  displayTest('a posts page jumps to the page entered in its prompt', (
    tester,
  ) async {
    fake.state.posts
      ..clear()
      ..addAll(
        FakeE621State.seeded(posts: 200).posts
          ..sort((a, b) => (a['id']! as int).compareTo(b['id']! as int)),
      );
    await pumpApp(
      tester,
      home: const PostsPage(params: PostParams(tags: 'order:score')),
    );
    await settle(tester);

    // The footer sits below the loaded posts, so it has to be scrolled to.
    // Reaching it runs the list into its next page request, which is still
    // in flight when the jump is made.
    await tester.scrollUntilVisible(
      find.byIcon(Icons.onetwothree),
      400,
      scrollable: find.byType(Scrollable).first,
    );

    await tester.tap(find.byIcon(Icons.onetwothree));
    await tester.pump();
    expect(find.text('跳转页面'), findsOneWidget);
    expect(find.text('页码'), findsOneWidget);

    await tester.enterText(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(TextField),
      ),
      '3',
    );
    await tester.tap(find.text('确定'));
    await tester.pump();

    // The in-flight page and the jump's own page have to land. Each needs
    // both real time for its request and a frame for its state, in
    // alternation, so the search is polled until it has settled.
    final query = pageQuery('order:score');
    for (var i = 0; i < 10; i++) {
      await settle(tester);

      if (query.state is InfiniteQuerySuccess && listPages().contains('3')) {
        break;
      }
    }
    await tester.pump(const Duration(milliseconds: 400));

    // The jump is the last page the fake served.
    expect(listPages().last, '3');
    // The search was replaced by the page jumped to.
    expect(pageQuery('order:score').state.data?.args, [3]);
    // The list was returned to the top of that page.
    expect(
      PrimaryScrollController.of(
        tester.element(find.byType(PostList)),
      ).position.pixels,
      0,
    );
    // The footer reports the page it now shows.
    await tester.scrollUntilVisible(
      find.text('第 3 页 · 50 个帖子'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
  });

  displayTest('a page jump prompt rejects pages outside the site', (
    tester,
  ) async {
    await pumpApp(tester, home: const PostsPage());
    await settle(tester);
    final requestsBefore = fake.requests.length;

    await tester.tap(find.byIcon(Icons.onetwothree));
    await tester.pump();

    Future<void> enterPage(String page) async {
      await tester.enterText(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(TextField),
        ),
        page,
      );
      await tester.pump();
    }

    await enterPage('0');
    await tester.tap(find.text('确定'));
    await tester.pump();
    expect(find.text('请输入 1 到 750 之间的页码'), findsOneWidget);
    // The prompt stays open so the entry can be corrected.
    expect(find.text('跳转页面'), findsOneWidget);
    expect(fake.requests, hasLength(requestsBefore));

    await enterPage('751');
    await tester.tap(find.text('确定'));
    await tester.pump();
    expect(find.text('请输入 1 到 750 之间的页码'), findsOneWidget);
    expect(fake.requests, hasLength(requestsBefore));

    // An empty entry is no page either. Letters and signs cannot be entered
    // at all, the field only accepts digits.
    await enterPage('');
    await tester.tap(find.text('确定'));
    await tester.pump();
    expect(find.text('请输入 1 到 750 之间的页码'), findsOneWidget);
    expect(fake.requests, hasLength(requestsBefore));

    // A valid page clears the error.
    await enterPage('2');
    expect(find.text('请输入 1 到 750 之间的页码'), findsNothing);

    // Canceling leaves the search where it was.
    await tester.tap(find.text('取消'));
    await tester.pump();
    expect(find.text('跳转页面'), findsNothing);
    expect(fake.requests, hasLength(requestsBefore));
  });

  displayTest('a page jump prompt survives a double tap on its ok button', (
    tester,
  ) async {
    fake.state.posts
      ..clear()
      ..addAll(
        FakeE621State.seeded(posts: 200).posts
          ..sort((a, b) => (a['id']! as int).compareTo(b['id']! as int)),
      );
    await pumpApp(
      tester,
      home: const PostsPage(params: PostParams(tags: 'order:score')),
    );
    await settle(tester);

    // The footer sits below the loaded posts, so it has to be scrolled to.
    // Reaching it runs the list into its next page request, which is still
    // in flight when the jump is made.
    await tester.scrollUntilVisible(
      find.byIcon(Icons.onetwothree),
      400,
      scrollable: find.byType(Scrollable).first,
    );

    await tester.tap(find.byIcon(Icons.onetwothree));
    await tester.pump();

    await tester.enterText(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(TextField),
      ),
      '3',
    );

    // A double tap fires the ok button twice without a frame between the
    // calls, the tightest window a real double tap can hit.
    final button = tester.widget<TextButton>(
      find.widgetWithText(TextButton, '确定'),
    );
    button.onPressed!();
    button.onPressed!();
    await tester.pump();

    // The prompt left the posts page itself in place.
    expect(find.byType(PostsPage), findsOneWidget);

    // The jump has to land behind the in-flight page before the test ends.
    final query = pageQuery('order:score');
    for (var i = 0; i < 10; i++) {
      await settle(tester);

      if (query.state is InfiniteQuerySuccess && listPages().contains('3')) {
        break;
      }
    }
    await tester.pump(const Duration(milliseconds: 400));

    // The search was replaced by the page jumped to, and only once.
    expect(query.state.data?.args, [3]);

    // The connection of the landed requests waits out its idle timeout on a
    // timer that has to run out before the test can end.
    await tester.pump(const Duration(seconds: 5));
  });

  displayTest('the footer reports the state of the search', (tester) async {
    InfiniteQueryStatus<List<Post>, Object> status({
      required List<List<Post>> pages,
      required List<Object> args,
      required bool hasNextPage,
    }) => InfiniteQueryStatus.success(
      // ignore: deprecated_member_use
      timeCreated: DateTime.now(),
      data: InfiniteQueryData(pages: pages, args: args),
      hasReachedMax: !hasNextPage,
      hasNextPage: hasNextPage,
      hasPreviousPage: false,
    );

    Widget footer(InfiniteQueryStatus<List<Post>, Object> state) => Builder(
      builder: (context) => MaterialApp(
        locale: const Locale('zh'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: PostListFooter(
            state: state,
            query: InfiniteQuery<List<int>, Object>(
              key: 'footerTest',
              queryFn: (page) async => const <int>[],
              getNextArg: (state) => null,
            ),
            scrollController: ScrollController(),
          ),
        ),
      ),
    );

    // A search at the site's page limit is told so.
    await tester.pumpWidget(
      footer(
        status(
          pages: [
            [samplePost(), samplePost(id: 2)],
          ],
          args: [maxSitePage],
          hasNextPage: false,
        ),
      ),
    );
    await tester.pump();
    expect(find.text('第 750 页 · 2 个帖子'), findsOneWidget);
    expect(find.text('已达服务器页数上限，请缩小搜索范围'), findsOneWidget);

    // A cursor search ends without hitting the site page limit.
    await tester.pumpWidget(
      footer(
        status(
          pages: [
            [samplePost(), samplePost(id: 2)],
          ],
          args: ['b123'],
          hasNextPage: false,
        ),
      ),
    );
    await tester.pump();
    expect(find.text('第 1 页 · 2 个帖子'), findsOneWidget);
    expect(find.text('已达服务器页数上限，请缩小搜索范围'), findsNothing);

    // An ended search without posts has nothing to report.
    await tester.pumpWidget(
      footer(status(pages: const [[]], args: const [1], hasNextPage: false)),
    );
    await tester.pump();
    expect(find.text('第 1 页 · 0 个帖子'), findsNothing);
    expect(find.byIcon(Icons.onetwothree), findsNothing);
  });

  test('a posts search counts the page it is on', () {
    final post = samplePost();
    // A page of the search.
    List<List<Post>> pagesOf(int count) => List.generate(count, (_) => [post]);

    InfiniteQueryStatus<List<Post>, Object> status(
      List<List<Post>> pages,
      List<Object> args,
    ) => InfiniteQueryStatus.initial(
      timeCreated: DateTime.now(),
      data: InfiniteQueryData(pages: pages, args: args),
    );

    // Page number searches carry their page in their arguments.
    expect(status(pagesOf(1), const [1]).currentPage, 1);
    expect(status(pagesOf(3), const [1, 2, 3]).currentPage, 3);
    expect(status(pagesOf(1), const [300]).currentPage, 300);
    // Cursor searches count their cursor pages after their page number.
    expect(status(pagesOf(3), const [1, 'b3', 'b2']).currentPage, 3);
    expect(status(pagesOf(2), const [300, 'b1']).currentPage, 301);
    // The empty page that ends a search is no page to be on.
    expect(status([...pagesOf(3), []], const [1, 2, 3, 4]).currentPage, 3);
    // A page that has not landed yet is still the page being fetched.
    expect(status(const [], const [3]).currentPage, 3);
    expect(status(const [[]], const [5]).currentPage, 5);

    // A search that has loaded nothing is on no page.
    expect(
      InfiniteQueryStatus<List<Post>, Object>.loading(
        timeCreated: DateTime.now(),
        data: null,
        isRefetching: false,
        isFetchingNextPage: false,
        isInitialFetch: true,
      ).currentPage,
      0,
    );
  });
}
