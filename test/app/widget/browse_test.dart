import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notified_preferences/notified_preferences.dart';
import 'package:provider/provider.dart';

import '../../_support/fake_e621.dart';
import '../../_support/harness.dart';

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

    Future<List<(BrowseFeed, PopularScale)>> show(
      WidgetTester tester, {
      required bool picking,
      BrowseFeed feed = BrowseFeed.hot,
    }) async {
      final List<(BrowseFeed, PopularScale)> picked = [];
      await tester.pumpWidget(
        Provider<Client>.value(
          value: client,
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: BrowseHeader(
                  feed: feed,
                  scale: PopularScale.week,
                  picking: picking,
                  onToggle: () {},
                  onPick: (feed, scale) => picked.add((feed, scale)),
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

    Future<Settings> showPage(WidgetTester tester) async {
      final Settings settings = Settings(await SharedPreferences.getInstance());
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<Client>.value(value: client),
            Provider<Settings>.value(value: settings),
          ],
          child: const MaterialApp(home: BrowsePage()),
        ),
      );
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)),
      );
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
  });
}
