import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/history/history.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notified_preferences/notified_preferences.dart';
import 'package:provider/provider.dart';
import 'package:relative_time/relative_time.dart';

import '../../_support/fake_e621.dart';
import '../../_support/harness.dart';
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
        await tester.pump();
        await Future<void>.delayed(const Duration(milliseconds: 100));
      });
      await tester.pumpAndSettle();
    }

    Future<List<String>> openSheet(
      WidgetTester tester, {
      List<Post> posts = const [],
    }) async {
      final List<String> submitted = [];
      await tester.pumpWidget(
        Provider<Client>.value(
          value: client,
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

    String field(WidgetTester tester) =>
        tester.widget<TextField>(find.byType(TextField)).controller!.text;

    displayTest('the search mark submits the query and closes the sheet', (
      tester,
    ) async {
      final List<String> submitted = await openSheet(tester);

      await tester.tap(find.byIcon(Icons.search));
      await settle(tester);

      expect(submitted, ['riolu ']);
      expect(find.byType(PostSearchSheet), findsNothing);
    });

    displayTest('the keyboard search action submits what was typed', (
      tester,
    ) async {
      final List<String> submitted = await openSheet(tester);

      await tester.enterText(find.byType(TextField), 'riolu solo');
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
      await openSheet(
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
      await tester.longPress(find.text('aura'));
      await tester.pump();

      expect(field(tester), 'riolu solo -aura ');
    });
  });
}
