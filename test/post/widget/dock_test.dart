import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/history/history.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notified_preferences/notified_preferences.dart';
import 'package:provider/provider.dart';
import 'package:relative_time/relative_time.dart';

import '../../_support/fake_e621.dart';
import '../../_support/harness.dart';
import '../../_support/images.dart';
import '../../_support/posts.dart';

void main() {
  group('QueryLine', () {
    testWidgets('a query shows each tag with its prefix and spaces', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: QueryLine(query: 'riolu -human ~hi_res')),
        ),
      );

      expect(find.text('riolu', findRichText: true), findsOneWidget);
      expect(find.text('-human', findRichText: true), findsOneWidget);
      expect(find.text('~hi res', findRichText: true), findsOneWidget);
    });

    testWidgets('an empty query shows the search hint', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: QueryLine(query: '  ')),
        ),
      );

      expect(find.text('Search'), findsOneWidget);
    });
  });

  group('PostSearchSheet', () {
    late FakeE621 fake;
    late Client client;
    late ValueNotifier<Traits> traits;
    late AppDatabase sqlite;

    setUpAll(initializeTestApp);

    setUp(() async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('flutter_keyboard_visibility'),
            (call) async => null,
          );
      SharedPreferences.setMockInitialValues({});
      sqlite = AppDatabase(NativeDatabase.memory());
      fake = await FakeE621.start();
      fake.state.tags.addAll([
        for (final (int index, String name) in [
          'riolu',
          'solo',
          'aura',
        ].indexed)
          {
            'id': index + 1,
            'name': name,
            'category': TagCategory.species.id,
            'post_count': 9800,
          },
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
      final Identity identity = await IdentityRepository(
        sqlite,
      ).add(IdentityRequest(host: fake.url));
      client = Client(
        identity: identity,
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

    Future<List<String>> openSheet(
      WidgetTester tester, {
      List<Post> posts = const [],
      ValueChanged<Pool>? onOpenPool,
    }) async {
      final List<String> submitted = [];
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<Client>.value(value: client),
            Provider<BaseCacheManager>.value(
              value: const NoImageCacheManager(),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              DefaultMaterialLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
              RelativeTimeLocalizations.delegate,
            ],
            home: Scaffold(
              body: Builder(
                builder: (context) => TextButton(
                  onPressed: () => showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => PostSearchSheet(
                      query: 'riolu',
                      posts: posts,
                      onSubmit: submitted.add,
                      onAllRecent: () {},
                      onOpenPool: onOpenPool,
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
      return submitted;
    }

    Future<void> search(String tags, DateTime at) => client.histories.add(
      HistoryRequest(
        visitedAt: at,
        link: Uri(path: '/posts', queryParameters: {'tags': tags}).toString(),
        category: HistoryCategory.searches,
        type: HistoryType.posts,
      ),
    );

    displayTest('the search mark submits the query and closes the sheet', (
      tester,
    ) async {
      final List<String> submitted = await openSheet(tester);

      await tester.tap(find.byIcon(Icons.search));
      await settle(tester);

      expect(submitted, ['riolu']);
      expect(find.byType(PostSearchSheet), findsNothing);
    });

    displayTest('the keyboard search action submits what was typed', (
      tester,
    ) async {
      final List<String> submitted = await openSheet(tester);

      await tester.enterText(find.byType(TextField), 'solo');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await settle(tester);

      expect(submitted, ['riolu solo']);
    });

    displayTest('Recent lists each search once, newest nearest the field', (
      tester,
    ) async {
      await tester.runAsync(() async {
        await search('lucario', DateTime(2026, 10));
        await search('riolu_solo', DateTime(2026, 10, 2));
        await search('lucario', DateTime(2026, 10, 3));
      });
      await openSheet(tester);

      final Finder older = find.text('riolu solo', findRichText: true);
      final Finder newer = find.text('lucario', findRichText: true);
      expect(older, findsOneWidget);
      expect(newer, findsOneWidget);
      expect(
        tester.getTopLeft(newer).dy,
        greaterThan(tester.getTopLeft(older).dy),
      );
    });

    displayTest('Recent shows the five newest and links to the rest', (
      tester,
    ) async {
      await tester.runAsync(() async {
        for (int i = 1; i <= 7; i++) {
          await search('tag_$i', DateTime(2026, 10, i));
        }
      });
      await openSheet(tester);

      expect(find.text('All searches in History'), findsOneWidget);
      expect(find.byType(SheetEntry), findsNWidgets(5));
      expect(find.text('tag 7', findRichText: true), findsOneWidget);
      expect(find.text('tag 2', findRichText: true), findsNothing);
    });

    displayTest('the query field spans the sheet', (tester) async {
      await openSheet(tester);

      expect(
        tester.getSize(find.byType(QueryField)).width,
        tester.getSize(find.byType(PostSearchSheet)).width - 24,
      );
    });

    displayTest('a tapped recent search is submitted', (tester) async {
      await tester.runAsync(() => search('lucario', DateTime(2026, 10)));
      final List<String> submitted = await openSheet(tester);

      await tester.tap(find.text('lucario', findRichText: true));
      await settle(tester);

      expect(submitted, ['lucario']);
    });

    displayTest('Saved lists follows and submits the one tapped', (
      tester,
    ) async {
      await tester.runAsync(
        () => client.follows.create(
          tags: 'pool:21837',
          type: FollowType.bookmark,
          title: 'Duncan and Eddie',
        ),
      );
      final List<String> submitted = await openSheet(tester);

      await tester.tap(find.text('Saved'));
      await settle(tester);
      await tester.tap(find.text('Duncan and Eddie'));
      await settle(tester);

      expect(submitted, ['pool:21837']);
    });

    displayTest('In results adds a tapped tag and excludes a held one', (
      tester,
    ) async {
      final List<String> submitted = await openSheet(
        tester,
        posts: [
          samplePost(
            tags: const {
              'general': ['solo', 'aura'],
            },
          ),
          samplePost(
            id: 2,
            tags: const {
              'general': ['solo'],
            },
          ),
        ],
      );

      await tester.tap(find.text('In results'));
      await settle(tester);
      await tester.tap(find.text('solo'));
      await settle(tester);
      await tester.longPress(find.text('aura'));
      await settle(tester);
      await tester.tap(find.byIcon(Icons.search));
      await settle(tester);

      expect(submitted, ['riolu solo -aura']);
    });

    displayTest('typing shows matching tags in place of the tabs', (
      tester,
    ) async {
      await openSheet(tester);

      await tester.enterText(find.byType(TextField), 'tag_3');
      await settle(tester);

      expect(find.text('tag 37', findRichText: true), findsOneWidget);
      expect(find.text('Recent'), findsNothing);
    });

    displayTest('a suggestion keeps the exclusion being typed', (tester) async {
      final List<String> submitted = await openSheet(tester);

      await tester.enterText(find.byType(TextField), '-tag_3');
      await settle(tester);
      await tester.tap(find.text('-tag 37', findRichText: true));
      await settle(tester);
      await tester.tap(find.byIcon(Icons.search));
      await settle(tester);

      expect(submitted, ['riolu -tag_37']);
    });

    displayTest('rating offers its values in words', (tester) async {
      await openSheet(tester);

      await tester.enterText(find.byType(TextField), 'rating:');
      await settle(tester);

      expect(find.text('Safe'), findsOneWidget);
      expect(find.text('Questionable'), findsOneWidget);
      expect(find.text('Explicit'), findsOneWidget);
    });

    displayTest('a tapped chip offers Exclude and turns into Include', (
      tester,
    ) async {
      final List<String> submitted = await openSheet(tester);

      await tester.tap(find.widgetWithText(QueryChip, 'riolu'));
      await settle(tester);
      await tester.tap(find.text('Exclude'));
      await settle(tester);

      expect(find.text('Include'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.search));
      await settle(tester);

      expect(submitted, ['-riolu']);
    });

    displayTest('Remove takes the chip out of the query', (tester) async {
      final List<String> submitted = await openSheet(tester);

      await tester.tap(find.widgetWithText(QueryChip, 'riolu'));
      await settle(tester);
      await tester.tap(find.text('Remove'));
      await settle(tester);
      await tester.tap(find.byIcon(Icons.search));
      await settle(tester);

      expect(submitted, ['']);
    });

    displayTest('a tag without posts offers close matches to replace it', (
      tester,
    ) async {
      final List<String> submitted = await openSheet(tester);

      await tester.enterText(find.byType(TextField), 'tag_3 ');
      await settle(tester);

      expect(
        find.text('tag 3 has no posts. Did you mean one of these?'),
        findsOneWidget,
      );

      await tester.tap(find.text('tag 37', findRichText: true));
      await settle(tester);
      await tester.tap(find.byIcon(Icons.search));
      await settle(tester);

      expect(submitted, ['riolu tag_37']);
    });

    displayTest('the add button opens the filter catalog over the lists', (
      tester,
    ) async {
      await tester.runAsync(() => search('lucario', DateTime(2026, 10)));
      await openSheet(tester);
      expect(find.text('lucario', findRichText: true), findsOneWidget);

      await tester.tap(find.text('Filters'));
      await settle(tester);

      expect(find.byType(MetaCatalog), findsOneWidget);
      expect(find.text('lucario', findRichText: true), findsNothing);
    });

    displayTest('a narrow sheet shows the filter chip as an icon', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(300, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await openSheet(tester);

      expect(find.text('Filters'), findsNothing);
      expect(find.byTooltip('Filters'), findsOneWidget);
    });

    displayTest('a metatag chip opens its builder', (tester) async {
      await openSheet(tester);
      await tester.enterText(find.byType(TextField), 'order:score ');
      await settle(tester);

      await tester.tap(find.widgetWithText(QueryChip, 'by score'));
      await settle(tester);

      expect(find.byType(OrderBuilder), findsOneWidget);
      expect(find.byType(QueryChipActions), findsNothing);
    });

    displayTest('focusing the field closes the filters', (tester) async {
      await openSheet(tester);
      await tester.tap(find.text('Filters'));
      await settle(tester);

      await tester.tap(find.byType(TextField));
      await settle(tester);

      expect(find.byType(MetaPanel), findsNothing);
      expect(tester.testTextInput.isVisible, isTrue);
    });

    displayTest('a chip takes the colour of its tag category', (tester) async {
      await openSheet(tester);
      await tester.tap(find.text('In results'));
      await settle(tester);

      await tester.enterText(find.byType(TextField), 'tag_37 ');
      await settle(tester);

      final Container stripe = tester.widget<Container>(
        find.descendant(
          of: find.widgetWithText(QueryChip, 'tag 37'),
          matching: find.byType(Container),
        ),
      );
      expect(stripe.color, TagCategory.species.colorFor(Brightness.light));
    });

    displayTest('recent searches read their tags as text with a mark', (
      tester,
    ) async {
      await tester.runAsync(() => search('riolu rating:s', DateTime(2026, 10)));
      await openSheet(tester);

      final Finder entry = find.byType(SheetEntry);
      expect(
        find.descendant(of: entry, matching: find.byType(QueryChip)),
        findsNothing,
      );
      Color? mark(String token) {
        final Container box = tester.widget<Container>(
          find.descendant(
            of: find.widgetWithText(QueryToken, token),
            matching: find.byType(Container),
          ),
        );
        return (box.decoration! as BoxDecoration).color;
      }

      expect(mark('riolu'), TagCategory.species.colorFor(Brightness.light));
      expect(mark('rating:s'), Colors.grey);
    });

    Future<PostParamsController> openFromPage(WidgetTester tester) async {
      final PostParamsController params = PostParamsController(
        initial: const PostParams(tags: 'riolu'),
      );
      addTearDown(params.dispose);
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
            localizationsDelegates: const [
              DefaultMaterialLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
              RelativeTimeLocalizations.delegate,
            ],
            home: FilterControllerProvider(
              create: (_) => PostFilter(client),
              child: ChangeNotifierProvider.value(
                value: params,
                child: Builder(
                  builder: (context) => Scaffold(
                    body: TextButton(
                      onPressed: () => showPostSearchSheet(context),
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
      await settle(tester);
      return params;
    }

    displayTest('a changed search opens a new page above the old one', (
      tester,
    ) async {
      final PostParamsController params = await openFromPage(tester);

      await tester.enterText(find.byType(TextField), 'solo ');
      await settle(tester);
      await tester.tap(find.byIcon(Icons.search).last);
      await settle(tester);

      expect(
        tester.widget<PostsPage>(find.byType(PostsPage).last).params?.tags,
        'riolu solo',
      );
      expect(params.value.tags, 'riolu');
    });

    displayTest('committing the same search stays on the page', (tester) async {
      await openFromPage(tester);

      await tester.tap(find.byIcon(Icons.search).last);
      await settle(tester);

      expect(find.byType(PostsPage), findsNothing);
      expect(find.text('open'), findsOneWidget);
    });

    void addPools() => fake.state.pools
      ..clear()
      ..addAll([
        for (final (int index, String name) in [
          'river_story',
          'river_sketches',
        ].indexed)
          {
            'id': 40 + index,
            'name': name,
            'created_at': '2026-09-01T12:00:00.000-04:00',
            'updated_at': '2026-10-23T12:00:00.000-04:00',
            'creator_id': 1,
            'description': '',
            'is_active': true,
            'category': 'series',
            'post_ids': [1, 2, 3],
            'post_count': 3,
          },
      ]);

    displayTest('a pool chip names its pool', (tester) async {
      addPools();
      await openSheet(tester);

      await tester.enterText(find.byType(TextField), 'pool:41 ');
      await settle(tester);

      expect(find.widgetWithText(QueryChip, 'river sketches'), findsOneWidget);
    });

    displayTest('typing pool: suggests pools and writes the picked id', (
      tester,
    ) async {
      addPools();
      final List<String> submitted = await openSheet(tester);

      await tester.enterText(find.byType(TextField), 'pool:sketch');
      await settle(tester);
      expect(find.text('river story'), findsNothing);
      await tester.tap(find.text('river sketches'));
      await settle(tester);
      await tester.tap(find.byIcon(Icons.search).last);
      await settle(tester);

      expect(submitted, ['riolu pool:41']);
    });

    displayTest('the pools builder picks a recently updated pool', (
      tester,
    ) async {
      addPools();
      final List<Pool> opened = [];
      await openSheet(tester, onOpenPool: opened.add);
      await tester.tap(find.text('Filters'));
      await settle(tester);
      await tester.tap(find.text('Pools & sets'));
      await settle(tester);

      await tester.tap(find.text('river story'));
      await settle(tester);

      expect(find.widgetWithText(QueryChip, 'river story'), findsOneWidget);
      await tester.tap(find.text('Open the pool as pages'));
      expect(opened.map((e) => e.id), [40]);
    });

    displayTest('the Filters button counts the filters in use', (tester) async {
      await openSheet(tester);
      await tester.enterText(find.byType(TextField), 'order:score rating:s ');
      await settle(tester);

      expect(
        find.descendant(
          of: find.widgetWithText(SheetButton, 'Filters'),
          matching: find.text('2'),
        ),
        findsOneWidget,
      );
    });

    displayTest('signed in, the sets builder picks one of your sets', (
      tester,
    ) async {
      fake.state.sets.add({
        'id': 5,
        'name': 'wallpapers',
        'shortname': 'wallpapers',
        'description': '',
        'is_public': false,
        'creator_id': 3044,
        'post_ids': [1],
        'post_count': 1,
        'created_at': '2026-09-01T12:00:00.000-04:00',
        'updated_at': '2026-10-23T12:00:00.000-04:00',
      });
      await tester.runAsync(() async {
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
      });
      final List<String> submitted = await openSheet(tester);
      await tester.tap(find.text('Filters'));
      await settle(tester);
      await tester.tap(find.text('Pools & sets'));
      await settle(tester);

      await tester.tap(find.text('Sets'));
      await settle(tester);
      await tester.tap(find.text('wallpapers'));
      await settle(tester);
      await tester.tap(find.byIcon(Icons.search).last);
      await settle(tester);

      expect(submitted, ['riolu set:wallpapers']);
    });
  });
}
