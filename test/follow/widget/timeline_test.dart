import 'package:cached_query/cached_query.dart';
import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notified_preferences/notified_preferences.dart';
import 'package:relative_time/relative_time.dart';

import '../../_support/fake_e621.dart';
import '../../_support/harness.dart';
import '../../_support/images.dart';

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

  /// Pumps a follow timeline under the providers it expects, in chinese.
  Future<void> pumpTimeline(
    WidgetTester tester, {
    required List<String> tags,
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
            localizationsDelegates: const [
              ...AppLocalizations.localizationsDelegates,
              RelativeTimeLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              // The timeline tiles size themselves through the tile layout.
              body: TileLayout(child: FollowTimelinePostList(tags: tags)),
            ),
          ),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await tester.pump();
  }

  /// Lets the timeline's requests land and its frames settle.
  Future<void> settle(WidgetTester tester) async {
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await tester.pump(const Duration(milliseconds: 100));
  }

  displayTest('a follow timeline reports its paging progress in a footer', (
    tester,
  ) async {
    // byTags filters the tag list in place, so it has to stay mutable.
    final List<String> tags = ['tag_1'];
    await pumpTimeline(tester, tags: tags);
    await settle(tester);

    // The tiles of a timeline feed fill the surface on their own, so the
    // footer below them has to be scrolled to.
    await tester.scrollUntilVisible(
      find.byType(PostListFooter),
      400,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.byType(PostListFooter), findsOneWidget);
    expect(find.text('第 1 页 · 3 个帖子'), findsOneWidget);
    expect(find.byIcon(Icons.onetwothree), findsOneWidget);
  });

  displayTest('a follow timeline hides its footer without subscriptions', (
    tester,
  ) async {
    // The timeline request would be pointless without a tag to follow.
    final List<String> tags = [];
    await pumpTimeline(tester, tags: tags);
    await settle(tester);

    expect(
      fake.requests.where((request) => request.path == '/posts.json'),
      isEmpty,
    );

    // The footer sits below the timeline, so it is scrolled to before
    // anything is claimed about it.
    await tester.scrollUntilVisible(
      find.byType(PostListFooter),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.textContaining('第 1 页'), findsNothing);
    expect(find.byIcon(Icons.onetwothree), findsNothing);
  });

  displayTest('a follow timeline hides its footer for an empty search', (
    tester,
  ) async {
    fake.state.posts.clear();
    final List<String> tags = ['tag_1'];
    await pumpTimeline(tester, tags: tags);
    await settle(tester);

    await tester.scrollUntilVisible(
      find.byType(PostListFooter),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.textContaining('第 1 页'), findsNothing);
    expect(find.byIcon(Icons.onetwothree), findsNothing);
  });
}
