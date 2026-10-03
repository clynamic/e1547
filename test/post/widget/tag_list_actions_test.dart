import 'package:cached_query/cached_query.dart';
import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notified_preferences/notified_preferences.dart';
import 'package:provider/provider.dart';

import '../../_support/harness.dart';

void main() {
  late Client client;
  late ValueNotifier<Traits> traits;
  late AppDatabase sqlite;

  setUpAll(() async {
    await initializeTestApp();
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    // A fresh database per test keeps the follow lists of the bookmark and
    // follow cases independent; the identity row has to exist for the
    // follow join table to accept writes.
    sqlite = AppDatabase(NativeDatabase.memory());
    await IdentityRepository(
      sqlite,
    ).add(const IdentityRequest(host: 'e621.net'));
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
      identity: const Identity(
        id: 1,
        host: 'e621.net',
        username: null,
        headers: null,
      ),
      traits: traits,
      storage: AppStorage(
        preferences: await SharedPreferences.getInstance(),
        temporaryFiles: '.',
        // The follow list is a local database query; the cache entry it
        // lands in has to expire before the test gives up its clock.
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
    await sqlite.close();
  });

  Future<void> pumpActions(WidgetTester tester, {required String tag}) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [Provider<Client>.value(value: client)],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: Center(child: TagListActions(tag: tag)),
            ),
          ),
        ),
      );
      // The follow list query is a real database read; it has to land
      // before the actions build their state.
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await tester.pump();
  }

  /// Lets database writes from the actions land and the tree settle.
  Future<void> settle(WidgetTester tester) async {
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 200));
    });
    await tester.pump();
  }

  /// Fires the button under [icon] twice before a frame can come between,
  /// like a double tap on a slow connection.
  void doubleTap(WidgetTester tester, IconData icon) {
    final button = tester.widget<MaterialButton>(
      find.ancestor(
        of: find.byIcon(icon),
        matching: find.byType(MaterialButton),
      ),
    );
    button.onPressed!();
    button.onPressed!();
  }

  displayTest('double tapping the bookmark button follows once', (
    tester,
  ) async {
    await pumpActions(tester, tag: 'test_tag');

    doubleTap(tester, Icons.turned_in_not);
    await settle(tester);

    final follows =
        await tester.runAsync(client.follows.all) ?? const <Follow>[];
    expect(follows, hasLength(1));
    expect(follows.single.tags, 'test_tag');
    expect(follows.single.type, FollowType.bookmark);
  });

  displayTest('double tapping the follow button follows once', (tester) async {
    await pumpActions(tester, tag: 'test_tag');

    doubleTap(tester, Icons.person_add_alt_1);
    await settle(tester);

    final follows =
        await tester.runAsync(client.follows.all) ?? const <Follow>[];
    expect(follows, hasLength(1));
    expect(follows.single.tags, 'test_tag');
    expect(follows.single.type, FollowType.update);
  });
}
