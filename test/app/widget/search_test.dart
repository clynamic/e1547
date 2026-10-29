import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/pool/pool.dart';
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

Pool samplePool({
  String name = 'river_story',
  PoolCategory category = PoolCategory.series,
  bool active = true,
  int count = 3,
}) => Pool(
  id: 1,
  name: name,
  createdAt: DateTime(2026, 9, 2),
  updatedAt: DateTime(2026, 10, 23),
  description: '',
  postIds: List.generate(count, (i) => i + 1),
  postCount: count,
  active: active,
  category: category,
);

Map<String, Object?> poolJson(
  int id,
  String name, {
  String category = 'series',
  List<int> posts = const [],
}) => {
  'id': id,
  'name': name,
  'created_at': '2026-09-01T12:00:00.000-04:00',
  'updated_at': '2026-10-23T12:00:00.000-04:00',
  'creator_id': 1,
  'description': '',
  'is_active': true,
  'category': category,
  'post_ids': posts,
  'post_count': posts.length,
};

void main() {
  group('pool words', () {
    test('a series counts pages and a collection counts posts', () {
      expect(poolSubtitle(samplePool()), 'Series · 3 pages');
      expect(
        poolSubtitle(samplePool(category: PoolCategory.collection)),
        'Collection · 3 posts',
      );
    });

    test('a detailed series says when it updated or that it finished', () {
      expect(
        poolSubtitle(samplePool(), detailed: true),
        'Series · 3 pages · updated 23 Oct',
      );
      expect(
        poolSubtitle(samplePool(active: false), detailed: true),
        'Series · 3 pages · finished',
      );
    });

    test('the dock reads the order alone until a name is searched', () {
      expect(poolParamsWords(const PoolParams()), 'Recently updated');
      expect(
        poolParamsWords(const PoolParams(name: 'river')),
        'Series and collections · last updated',
      );
      expect(
        poolParamsWords(
          const PoolParams(
            name: 'river',
            category: PoolCategory.collection,
            order: PoolOrder.name,
          ),
        ),
        'Collections · by name',
      );
    });
  });

  group('Search', () {
    late FakeE621 fake;
    late Client client;
    late ValueNotifier<Traits> traits;
    late AppDatabase sqlite;

    setUpAll(initializeTestApp);

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      sqlite = AppDatabase(NativeDatabase.memory());
      fake = await FakeE621.start();
      fake.state.pools
        ..clear()
        ..addAll([
          poolJson(1, 'river_story', posts: [1, 2, 3]),
          poolJson(2, 'river_sketches', category: 'collection', posts: [4, 5]),
          poolJson(3, 'lake_notes', posts: [6]),
        ]);
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

    Future<void> settle(WidgetTester tester) async {
      await tester.runAsync(() async {
        for (int i = 0; i < 6; i++) {
          await tester.pump(const Duration(milliseconds: 50));
          await Future<void>.delayed(const Duration(milliseconds: 50));
        }
      });
      await tester.pumpAndSettle();
    }

    late NavBarDocks docks;

    Future<Settings> showPage(WidgetTester tester, {SearchKind? kind}) async {
      docks = NavBarDocks();
      final Settings settings = Settings(await SharedPreferences.getInstance());
      if (kind != null) settings.searchKind.value = kind;
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
            home: Column(
              children: [
                Expanded(
                  child: NavBarDockScope(
                    docks: docks,
                    child: const SearchPage(),
                  ),
                ),
                ListenableBuilder(
                  listenable: docks,
                  builder: (context, child) => Material(
                    child: SizedBox(
                      height: navBarDockHeight,
                      child: docks.current?.call(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await settle(tester);
      return settings;
    }

    displayTest('the header unfolds every kind in order, the current checked', (
      tester,
    ) async {
      await showPage(tester, kind: SearchKind.pools);

      await tester.tap(find.text('Pools'));
      await settle(tester);

      final Finder cards = find.byType(PickerCard);
      expect(tester.widgetList<PickerCard>(cards).map((e) => e.title), [
        'Posts',
        'Pools',
      ]);
      expect(
        find.descendant(
          of: find.widgetWithText(PickerCard, 'Pools'),
          matching: find.byIcon(Icons.check),
        ),
        findsOneWidget,
      );
    });

    displayTest('a picked kind is remembered and docks its own search', (
      tester,
    ) async {
      final Settings settings = await showPage(tester);
      expect(find.byType(PoolDock), findsNothing);

      await tester.tap(find.text('Posts'));
      await settle(tester);
      await tester.tap(find.text('Pools'));
      await settle(tester);

      expect(settings.searchKind.value, SearchKind.pools);
      expect(find.byType(PickerCard), findsNothing);
      expect(find.byType(PoolDock), findsOneWidget);
      expect(find.text('Pool name'), findsOneWidget);
    });

    displayTest('Pools lists each pool with its kind and size', (tester) async {
      await showPage(tester, kind: SearchKind.pools);

      expect(find.text('river story'), findsOneWidget);
      expect(find.text('Series · 3 pages'), findsOneWidget);
      expect(find.text('Collection · 2 posts'), findsOneWidget);
    });

    Future<({List<PoolParams> submitted, List<Pool> opened})> openSheet(
      WidgetTester tester,
    ) async {
      final List<PoolParams> submitted = [];
      final List<Pool> opened = [];
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<Client>.value(value: client),
            Provider<BaseCacheManager>.value(
              value: const NoImageCacheManager(),
            ),
            Provider<Settings>.value(
              value: Settings(await SharedPreferences.getInstance()),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => TextButton(
                  onPressed: () => showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => PoolSearchSheet(
                      params: const PoolParams(),
                      onSubmit: submitted.add,
                      onOpen: opened.add,
                    ),
                  ),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await settle(tester);
      return (submitted: submitted, opened: opened);
    }

    displayTest('typing suggests pools whose name matches', (tester) async {
      await openSheet(tester);

      await tester.enterText(find.byType(TextField), 'river');
      await settle(tester);

      expect(find.text('river story'), findsOneWidget);
      expect(find.text('river sketches'), findsOneWidget);
      expect(find.text('lake notes'), findsNothing);
    });

    displayTest('a suggested pool opens it', (tester) async {
      final result = await openSheet(tester);
      await tester.enterText(find.byType(TextField), 'river');
      await settle(tester);

      await tester.tap(find.text('river sketches'));

      expect(result.opened.map((e) => e.id), [2]);
    });

    displayTest('the search applies the name and the picked kind', (
      tester,
    ) async {
      final result = await openSheet(tester);
      await tester.enterText(find.byType(TextField), 'river');
      await tester.tap(find.byTooltip('Filters'));
      await settle(tester);

      await tester.tap(find.text('Collections'));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.search));
      await settle(tester);

      expect(result.submitted, [
        const PoolParams(name: 'river', category: PoolCategory.collection),
      ]);
    });
  });
}
