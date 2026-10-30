import 'package:e1547/app/app.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/set/set.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/bed.dart';
import '../../_support/harness.dart';

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
    late TestBed bed;

    setUpAll(initializeTestApp);

    setUp(() async {
      bed = await TestBed.start();
      bed.fake.state.pools
        ..clear()
        ..addAll([
          poolJson(1, 'river_story', posts: [1, 2, 3]),
          poolJson(2, 'river_sketches', category: 'collection', posts: [4, 5]),
          poolJson(3, 'lake_notes', posts: [6]),
        ]);
      bed.fake.state.sets.addAll([
        setJson(1, 'reference', creator: 3044, public: false, count: 4),
        setJson(2, 'ref_sheets', creator: 7),
        setJson(3, 'den_archive', creator: 7),
        setJson(4, 'hidden_drafts', creator: 7, public: false),
      ]);
    });

    tearDown(() => bed.dispose());

    Future<void> signIn() async {
      bed.traits.value = bed.traits.value.copyWith(userId: 3044);
      await bed.signIn(username: 'user_34');
    }

    late NavBarDocks docks;

    Future<Settings> showPage(
      WidgetTester tester, {
      SearchKind? kind,
      bool settled = true,
    }) async {
      docks = NavBarDocks();
      if (kind != null) bed.settings.searchKind.value = kind;
      await tester.pumpWidget(
        bed.app(
          Column(
            children: [
              Expanded(
                child: NavBarDockScope(docks: docks, child: const SearchPage()),
              ),
              ListenableBuilder(
                listenable: Listenable.merge([docks, docks.content]),
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
      );
      if (settled) await settle(tester);
      return bed.settings;
    }

    Rect skeletonCover(WidgetTester tester) => tester.getRect(
      find
          .descendant(
            of: find.byType(CoverCardSkeleton),
            matching: find.byType(Container),
          )
          .first,
    );

    displayTest('pools load behind skeletons as wide as their cards', (
      tester,
    ) async {
      await showPage(tester, kind: SearchKind.pools, settled: false);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      final Rect cover = skeletonCover(tester);

      await settle(tester);
      expect(cover.width, tester.getSize(find.byType(PoolCard).first).width);
    });

    displayTest('sets load behind skeletons with covers as tall as theirs', (
      tester,
    ) async {
      await showPage(tester, kind: SearchKind.sets, settled: false);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(skeletonCover(tester).height, 170);
      await settle(tester);
    });

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

    displayTest('each kind card shows the icon of its kind', (tester) async {
      await showPage(tester);
      await tester.tap(find.text('Posts'));
      await settle(tester);

      for (final SearchKind kind in SearchKind.values) {
        expect(
          find.descendant(
            of: find.widgetWithText(PickerCard, kind.label),
            matching: find.byIcon(kind.icon),
          ),
          findsOneWidget,
        );
      }
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
        bed.app(
          Scaffold(
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

    displayTest('each public set names who made it', (tester) async {
      bed.fake.state.users.add({
        ...bed.fake.state.users.first,
        'id': 7,
        'name': 'curator',
      });

      await showPage(tester, kind: SearchKind.sets);

      expect(find.textContaining('by curator'), findsNWidgets(2));
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
      bed.fake.state.sets
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
        bed.app(
          Scaffold(
            body: PostSetSearchSheet(
              params: const PostSetParams(),
              onSubmit: (_) {},
              onOpen: opened.add,
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

    displayTest('the pools page lists the pools of the search it opens '
        'with', (tester) async {
      await tester.pumpWidget(
        bed.app(
          NavBarDockScope(
            docks: NavBarDocks(),
            child: const PoolsPage(search: PoolParams(name: 'lake')),
          ),
        ),
      );
      await settle(tester);

      expect(find.text('lake notes'), findsOneWidget);
      expect(find.text('river story'), findsNothing);
    });
  });
}
