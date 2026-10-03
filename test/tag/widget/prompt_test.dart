import 'package:cached_query/cached_query.dart';
import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notified_preferences/notified_preferences.dart';
import 'package:provider/provider.dart';
import 'package:relative_time/relative_time.dart';

import '../../_support/fake_e621.dart';
import '../../_support/harness.dart';
import '../../_support/images.dart';

/// Counts the material page routes pushed onto the navigator.
class _PushCounter extends NavigatorObserver {
  int get pages => pushed.whereType<MaterialPageRoute<dynamic>>().length;

  final List<Route<dynamic>> pushed = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      pushed.add(route);
}

void main() {
  late FakeE621 fake;
  late Client client;
  late ValueNotifier<Traits> traits;
  late AppDatabase sqlite;
  late Settings settings;

  setUpAll(() async {
    await initializeTestApp();
    sqlite = AppDatabase(NativeDatabase.memory());
    // The prompt records the wiki lookup in the history, whose entries
    // reference the identity that made them.
    await IdentityRepository(
      sqlite,
    ).add(const IdentityRequest(host: 'e621.net', username: 'tester'));
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

  displayTest('a double tapped tag prompt opens one posts page', (
    tester,
  ) async {
    final counter = _PushCounter();
    // The prompt's sheet keeps its header below a short screen's fold.
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
            navigatorObservers: [counter],
            locale: const Locale('zh'),
            localizationsDelegates: const [
              ...AppLocalizations.localizationsDelegates,
              RelativeTimeLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: TextButton(
                    onPressed: () =>
                        showTagSearchPrompt(context: context, tag: 'canine'),
                    child: const Text('open'),
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

    await tester.tap(find.text('open'));
    await tester.pump();
    // The sheet's entrance snaps over several frames, and its wiki request
    // only lands in real time.
    for (int i = 0; i < 12; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 200));
    });
    for (int i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    // A double tap fires the tag twice before a frame can come between.
    // The sheet's own gestures sit over its header, so the tag is fired
    // directly, which also makes the two calls back to back.
    final header = tester.widget<InkWell>(
      find.ancestor(of: find.text('canine'), matching: find.byType(InkWell)),
    );
    final pagesBefore = counter.pages;
    header.onTap!();
    header.onTap!();
    await tester.pump();
    // The pushed page only builds on a frame with time on it.
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(PostsPage), findsOneWidget);
    // The unguarded double tap would push a second posts page after
    // popping the first, which the lone count above could not tell apart.
    expect(counter.pages - pagesBefore, 1);

    // The pushed page keeps its requests coming, and the test client's
    // cache expires them again in no time, refetching whatever still
    // listens. Real and fake time take turns until a whole round passes
    // without a single request, so none is left in flight at the end.
    int previous = -1;
    while (fake.requests.length != previous) {
      previous = fake.requests.length;
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 200));
      });
      await tester.pump(const Duration(milliseconds: 200));
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      });
    }
    // The connection of the last request idles out on a timer that has to
    // run out while the test still owns the clock, so a few more seconds
    // pass, with real time between them for any late request to land.
    for (var i = 0; i < 4; i++) {
      await tester.pump(const Duration(seconds: 1));
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 50));
      });
    }
  });
}
