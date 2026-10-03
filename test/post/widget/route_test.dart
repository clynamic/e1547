import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
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

  /// Opens a post detail route from a tree layered like the app, where the
  /// client sits above the [Navigator] and the post list below it, so the route
  /// sees only what it was handed.
  Future<void> pushDetail(
    WidgetTester tester,
    PostFilter filter, {
    Post? post,
  }) async {
    final routeObserver = AnyRouteObserver();
    await tester.runAsync(() async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<Client>.value(value: client),
            Provider<BaseCacheManager>.value(
              value: const NoImageCacheManager(),
            ),
            Provider<AnyRouteObserver>.value(value: routeObserver),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            navigatorObservers: [routeObserver],
            home: FilterControllerProvider<PostFilter, Post>.value(
              value: filter,
              child: ChangeNotifierProvider(
                create: (_) => PostParamsController(),
                child: ImageCacheSizeProvider(
                  size: null,
                  child: Builder(
                    builder: (context) => TextButton(
                      onPressed: () =>
                          defaultPushPostDetail(context, post ?? samplePost()),
                      child: const Text('open'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pump();
      // The gallery queries as it opens, so that request has to land before
      // the tree is torn down.
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await tester.pump();
  }

  displayTest('a pushed gallery keeps the filter of its list', (tester) async {
    final filter = PostFilter(client);
    addTearDown(filter.dispose);

    await pushDetail(tester, filter);

    final gallery = tester.element(find.byType(PostDetailGallery));
    expect(gallery.read<FilterController<Post>?>(), same(filter));
  });

  displayTest('a pushed gallery drops the posts its list denies', (
    tester,
  ) async {
    traits.value = traits.value.copyWith(denylist: ['tag_47']);
    final filter = PostFilter(client);
    addTearDown(filter.dispose);

    await pushDetail(tester, filter, post: samplePost(id: 1000));

    final view = tester.widget<PagedPageView<Object, Post>>(
      find.byType(PagedPageView<Object, Post>),
    );
    expect(view.state.items?.map((post) => post.id), [1000]);
  });
}
