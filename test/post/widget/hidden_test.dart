import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notified_preferences/notified_preferences.dart';

import '../../_support/fake_e621.dart';
import '../../_support/harness.dart';
import '../../_support/posts.dart';

void main() {
  late FakeE621 fake;
  late Client client;
  late ValueNotifier<Traits> traits;
  late AppDatabase sqlite;
  late PostFilter filter;

  setUpAll(initializeTestApp);

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    sqlite = AppDatabase(NativeDatabase.memory());
    fake = await FakeE621.start();
    traits = ValueNotifier(
      const Traits(
        id: 1,
        userId: null,
        denylist: ['spider', 'gore'],
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
        queryCache: CachedQuery.asNewInstance(),
        sqlite: sqlite,
      ),
    );
    filter = PostFilter(client)
      ..track('page', [
        samplePost(
          tags: const {
            'general': ['spider'],
          },
        ),
        samplePost(
          id: 2,
          tags: const {
            'general': ['spider', 'gore'],
          },
        ),
        samplePost(
          id: 3,
          tags: const {
            'general': ['solo'],
          },
        ),
      ]);
  });

  tearDown(() async {
    filter.dispose();
    traits.dispose();
    await fake.stop();
    await sqlite.close();
  });

  Future<void> show(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: HiddenPostsSheet(filter: filter, onEditBlacklist: () {}),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder line(String entry) =>
      find.ancestor(of: find.text(entry), matching: find.byType(InkWell));

  testWidgets('a few lines fit the sheet to its content', (tester) async {
    await show(tester);

    final double screen =
        tester.view.physicalSize.height / tester.view.devicePixelRatio;
    expect(
      tester.getSize(find.byType(HiddenPostsSheet)).height,
      lessThan(screen - 120),
    );
  });

  testWidgets('many lines stop the sheet short of the top and scroll', (
    tester,
  ) async {
    traits.value = traits.value.copyWith(
      denylist: [for (int i = 0; i < 30; i++) 'tag_$i'],
    );
    filter.track('many', [
      for (int i = 0; i < 30; i++)
        samplePost(
          id: 100 + i,
          tags: {
            'general': ['tag_$i'],
          },
        ),
    ]);
    await show(tester);

    final double screen =
        tester.view.physicalSize.height / tester.view.devicePixelRatio;
    expect(tester.getSize(find.byType(HiddenPostsSheet)).height, screen - 120);
    expect(find.text('Use blacklist in this search'), findsOneWidget);
  });

  testWidgets('the sheet counts hidden posts and lists lines by hits', (
    tester,
  ) async {
    await show(tester);

    expect(find.text('2 of 3 posts hidden'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('spider')).dy,
      lessThan(tester.getTopLeft(find.text('gore')).dy),
    );
  });

  testWidgets('switching a line off shows the posts only it hid', (
    tester,
  ) async {
    await show(tester);

    await tester.tap(
      find.descendant(of: line('spider'), matching: find.byType(Switch)),
    );
    await tester.pumpAndSettle();

    expect(filter.allowedEntries, ['spider']);
    expect(find.text('1 of 3 posts hidden'), findsOneWidget);
  });

  testWidgets('turning the blacklist off for the search shows every post', (
    tester,
  ) async {
    await show(tester);

    await tester.tap(find.text('Use blacklist in this search'));
    await tester.pumpAndSettle();

    expect(filter.denying, isFalse);
    expect(find.text('0 of 3 posts hidden'), findsOneWidget);
  });

  testWidgets('a line switched off keeps its count', (tester) async {
    filter.allowedEntries = ['gore'];
    await show(tester);

    expect(
      find.descendant(of: line('gore'), matching: find.text('1')),
      findsOneWidget,
    );
  });
}
