import 'dart:io';

import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notified_preferences/notified_preferences.dart';

import '../../_support/fake_e621.dart';
import '../../_support/fixtures.dart';
import '../../_support/harness.dart';
import '../../_support/images.dart';

void main() {
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
        denylist: ['tag_14'],
        homeTags: '',
        avatar: null,
        perPage: null,
      ),
    );
    client = Client(
      identity: await IdentityRepository(sqlite).add(
        IdentityRequest(
          host: fake.url,
          username: 'tester',
          headers: {
            HttpHeaders.authorizationHeader: const Credentials(
              username: 'tester',
              password: 'key',
            ).basicAuth,
          },
        ),
      ),
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

  Future<void> show(WidgetTester tester, String tags) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<Client>.value(value: client),
          Provider<BaseCacheManager>.value(value: const NoImageCacheManager()),
          Provider<Settings>.value(
            value: Settings(await SharedPreferences.getInstance()),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: testLocalizations,
          home: PostsPage(params: PostParams(tags: tags)),
        ),
      ),
    );
    await settle(tester);
  }

  Finder title() => find.descendant(
    of: find.byType(PostSearchTitle),
    matching: find.byType(Text),
  );

  List<String?> pages(WidgetTester tester) => tester
      .widgetList<PostsPage>(find.byType(PostsPage, skipOffstage: false))
      .map((e) => e.params?.tags)
      .toList();

  for (final (String tags, String expected) in [
    ('', 'All posts'),
    ('fav:me', 'Favorites'),
    ('fav:tester', 'Favorites'),
    ('fav:tester tag_1', 'Search'),
    ('fav:someone', 'Search'),
    ('tag_1', 'Search'),
  ]) {
    displayTest('the search "$tags" is titled $expected', (tester) async {
      await show(tester, tags);

      expect(tester.widget<Text>(title()).data, expected);
    });
  }

  displayTest('a search saved as a follow takes its name and icon', (
    tester,
  ) async {
    await client.follows.create(
      tags: 'tag_1 tag_22',
      type: FollowType.bookmark,
      title: 'Saved pair',
    );

    await show(tester, 'tag_1 tag_22');

    expect(tester.widget<Text>(title()).data, 'Saved pair');
    expect(
      find.descendant(
        of: find.byType(PostSearchTitle),
        matching: find.byIcon(Icons.bookmark),
      ),
      findsOneWidget,
    );
  });

  displayTest('the header shows a chip per term and the hidden count last', (
    tester,
  ) async {
    await show(tester, 'tag_1 tag_22');

    final Finder chips = find.descendant(
      of: find.byType(PostSearchHeader),
      matching: find.byWidgetPredicate(
        (e) => e is QueryChip || e is HiddenChip,
      ),
    );
    final List<Widget> found = tester.widgetList(chips).toList();
    expect(found.whereType<QueryChip>().map((e) => e.term), [
      'tag_1',
      'tag_22',
    ]);
    expect(found.last, isA<HiddenChip>());
    expect((found.last as HiddenChip).count, 2);
  });

  displayTest(
    'a tapped chip unfolds its actions in the scroll over dimmed results',
    (tester) async {
      await show(tester, 'tag_1 tag_22');

      await tester.tap(find.byType(QueryChip).first);
      await settle(tester);

      expect(
        tester.widget<PostTagPanel>(find.byType(PostTagPanel)).term,
        'tag_1',
      );
      expect(find.text('Remove'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(CustomScrollView),
          matching: find.byType(PostTagPanel),
        ),
        findsOneWidget,
      );
      expect(tester.widget<SliverDim>(find.byType(SliverDim)).dimmed, isTrue);
    },
  );

  displayTest('Remove opens the search without the term in a new page', (
    tester,
  ) async {
    await show(tester, 'tag_1 tag_22');
    await tester.tap(find.byType(QueryChip).first);
    await settle(tester);

    await tester.tap(find.text('Remove'));
    await settle(tester);

    expect(pages(tester), ['tag_1 tag_22', 'tag_22']);
  });

  displayTest('Exclude opens the search with the term negated in a new page', (
    tester,
  ) async {
    await show(tester, 'tag_1 tag_22');
    await tester.tap(find.byType(QueryChip).last);
    await settle(tester);

    await tester.tap(find.text('Exclude'));
    await settle(tester);

    expect(pages(tester), ['tag_1 tag_22', 'tag_1 -tag_22']);
  });

  displayTest('tapping below the unfolded actions folds them', (tester) async {
    await show(tester, 'tag_1 tag_22');
    await tester.tap(find.byType(QueryChip).first);
    await settle(tester);

    await tester.tapAt(
      tester.getBottomLeft(find.byType(Scaffold).first) - const Offset(-20, 20),
    );
    await settle(tester);

    expect(find.byType(PostTagPanel), findsNothing);
    expect(pages(tester), ['tag_1 tag_22']);
  });

  displayTest('back folds the unfolded actions before leaving', (tester) async {
    await show(tester, 'tag_1 tag_22');
    await tester.tap(find.byType(QueryChip).first);
    await settle(tester);

    await tester.binding.handlePopRoute();
    await settle(tester);

    expect(find.byType(PostTagPanel), findsNothing);
    expect(pages(tester), ['tag_1 tag_22']);
  });

  displayTest('your own favorites list the posts you favorited', (
    tester,
  ) async {
    final List<int> ids = loadFixtureList(
      'posts.json',
    ).map((e) => e['id']! as int).toList();
    fake.state.favorites.addAll([ids[0], ids[2]]);
    traits.value = traits.value.copyWith(denylist: []);

    await show(tester, 'fav:me');

    expect(
      tester.widgetList<PostTile>(find.byType(PostTile)).map((e) => e.post.id),
      [ids[0], ids[2]],
    );
  });
}
