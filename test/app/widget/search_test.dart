import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/set/set.dart';
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

Map<String, Object?> setJson(
  int id,
  String name, {
  required int creator,
  bool public = true,
  int count = 2,
}) => {
  'id': id,
  'name': name,
  'shortname': name,
  'description': '',
  'is_public': public,
  'creator_id': creator,
  'post_ids': List.generate(count, (i) => i + 1),
  'post_count': count,
  'created_at': '2026-09-01T12:00:00.000-04:00',
  'updated_at': '2026-10-23T12:00:00.000-04:00',
};

PostSet sampleSet({bool public = true, int creator = 7, int count = 2310}) =>
    PostSet(
      id: 1,
      name: 'reference',
      shortname: 'reference',
      description: '',
      public: public,
      creatorId: creator,
      postIds: const [],
      postCount: count,
      createdAt: DateTime(2026, 9, 2),
      updatedAt: DateTime(2026, 10, 23),
    );

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

  group('set words', () {
    test('a set reads its size and who can see it', () {
      expect(postSetSubtitle(sampleSet()), '2,310 posts · public');
      expect(
        postSetSubtitle(sampleSet(public: false, count: 4)),
        '4 posts · private',
      );
    });

    test('the public list leaves out private sets and your own', () {
      final PublicPostSetFilter filter = PublicPostSetFilter(userId: 3);
      expect(filter.filter(sampleSet()), isTrue);
      expect(filter.filter(sampleSet(public: false)), isFalse);
      expect(filter.filter(sampleSet(creator: 3)), isFalse);
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
      fake.state.sets.addAll([
        setJson(1, 'reference', creator: 3044, public: false, count: 4),
        setJson(2, 'ref_sheets', creator: 7),
        setJson(3, 'den_archive', creator: 7),
        setJson(4, 'hidden_drafts', creator: 7, public: false),
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

    Future<void> signIn() async {
      traits.value = traits.value.copyWith(userId: 3044);
      client = Client(
        identity: await IdentityRepository(
          sqlite,
        ).add(IdentityRequest(host: fake.url, username: 'user_34')),
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
    }

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
        'Sets',
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

    displayTest('Sets lists yours, then the public sets of others', (
      tester,
    ) async {
      await tester.runAsync(signIn);
      await showPage(tester, kind: SearchKind.sets);

      expect(find.text('YOURS'), findsOneWidget);
      expect(find.text('reference'), findsOneWidget);
      expect(find.text('4 posts · private'), findsOneWidget);
      expect(find.text('PUBLIC · RECENTLY UPDATED'), findsOneWidget);
      expect(find.text('ref sheets'), findsOneWidget);
      expect(find.text('den archive'), findsOneWidget);
      expect(find.text('hidden drafts'), findsNothing);
      expect(
        tester.getTopLeft(find.text('reference')).dy,
        lessThan(tester.getTopLeft(find.text('ref sheets')).dy),
      );
    });

    displayTest('each public set shows its first post as a cover', (
      tester,
    ) async {
      fake.state.sets
        ..clear()
        ..add({
          ...setJson(2, 'ref_sheets', creator: 7),
          'post_ids': [1021, 1000],
        });
      await showPage(tester, kind: SearchKind.sets);

      final Finder cover = find.descendant(
        of: find.byType(PostSetCard),
        matching: find.byType(PostImageWidget),
      );
      expect(cover, findsOneWidget);
      expect(tester.widget<PostImageWidget>(cover).post.id, 1021);
    });

    displayTest('a signed out reader sees only public sets', (tester) async {
      await showPage(tester, kind: SearchKind.sets);

      expect(find.text('YOURS'), findsNothing);
      expect(find.text('reference'), findsNothing);
      expect(find.text('ref sheets'), findsOneWidget);
    });

    displayTest('typing a set name suggests your sets first', (tester) async {
      await tester.runAsync(signIn);
      final List<PostSet> opened = [];
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
              body: PostSetSearchSheet(
                params: const PostSetParams(),
                onSubmit: (_) {},
                onOpen: opened.add,
              ),
            ),
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), 'ref');
      await settle(tester);

      expect(find.text('den archive'), findsNothing);
      expect(
        tester.getTopLeft(find.text('reference')).dy,
        lessThan(tester.getTopLeft(find.text('ref sheets')).dy),
      );
      await tester.tap(find.text('ref sheets'));
      expect(opened.map((e) => e.id), [2]);
    });
  });
}
