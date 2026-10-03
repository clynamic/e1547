import 'package:cached_query/cached_query.dart';
import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notified_preferences/notified_preferences.dart';
import 'package:provider/provider.dart';

import '../../_support/harness.dart';
import '../../_support/images.dart';

/// Like [displayTest], but the tree is always torn down, even when the body
/// fails, so a failing test cannot leak a mounted page into the next one.
void strictDisplayTest(String description, WidgetTesterCallback body) =>
    testWidgets(description, (tester) async {
      try {
        await body(tester);
      } finally {
        // Snackbars outlive their page through the root messenger; their
        // timers have to run out while the test still owns the clock.
        final messengerFinder = find.byType(ScaffoldMessenger);
        if (messengerFinder.evaluate().isNotEmpty) {
          tester
              .state<ScaffoldMessengerState>(messengerFinder.first)
              .clearSnackBars();
        }
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump(const Duration(seconds: 1));
      }
    });

void main() {
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
        queryCache: CachedQuery.asNewInstance(),
        sqlite: sqlite,
      ),
    );
    // The fake clock would otherwise leave dio's timeout timers pending
    // on requests that are still in flight when the test ends.
    client.dio.options.connectTimeout = null;
    client.dio.options.receiveTimeout = null;
  });

  tearDown(() => traits.dispose());

  Future<void> pumpPage(WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<Client>.value(value: client),
            Provider<BaseCacheManager>.value(
              value: const NoImageCacheManager(),
            ),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: DenyListPage(),
          ),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await tester.pump();
  }

  /// Deletes the denylist entry at [index] through its popup menu.
  Future<void> deleteEntry(WidgetTester tester, int index) async {
    await tester.tap(find.byIcon(Icons.more_vert).at(index));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    // The snackbar slides in from below the viewport; only a settled
    // entrance puts its action within reach of a tap.
    await tester.pumpAndSettle();
  }

  testWidgets('the denylist page lists the denylist', (tester) async {
    traits.value = traits.value.copyWith(denylist: ['a', 'b', 'c']);
    await pumpPage(tester);

    expect(find.text('a'), findsOneWidget);
    expect(find.text('b'), findsOneWidget);
    expect(find.text('c'), findsOneWidget);
  });

  strictDisplayTest('undoing a deleted entry keeps later deletions', (
    tester,
  ) async {
    traits.value = traits.value.copyWith(denylist: ['a', 'b', 'c']);
    await pumpPage(tester);

    await deleteEntry(tester, 0);
    expect(client.traits.value.denylist, ['b', 'c']);

    await deleteEntry(tester, 0);
    expect(client.traits.value.denylist, ['c']);

    // The first snackbar is still the one on screen; the second one is
    // queued behind it.
    expect(find.byType(SnackBarAction), findsOneWidget);
    await tester.tap(find.byType(SnackBarAction));
    await tester.pump();

    expect(client.traits.value.denylist, ['a', 'c']);
  });

  strictDisplayTest('undoing twice does not duplicate an entry', (
    tester,
  ) async {
    traits.value = traits.value.copyWith(denylist: ['a']);
    await pumpPage(tester);

    await deleteEntry(tester, 0);
    expect(client.traits.value.denylist, isEmpty);

    await tester.tap(find.byType(SnackBarAction));
    await tester.pump();
    expect(client.traits.value.denylist, ['a']);

    // The snackbar outlives its action, so the undo can be fired again.
    await tester.tap(find.byType(SnackBarAction));
    await tester.pump();

    expect(client.traits.value.denylist, ['a']);
  });
}
