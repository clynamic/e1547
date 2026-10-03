import 'package:cached_query/cached_query.dart';
import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notified_preferences/notified_preferences.dart';
import 'package:provider/provider.dart';

import '../../_support/fake_e621.dart';
import '../../_support/harness.dart';

void main() {
  setUpAll(initializeTestApp);

  late FakeE621 fake;
  late AppDatabase sqlite;

  setUpAll(() => sqlite = AppDatabase(NativeDatabase.memory()));
  tearDownAll(() => sqlite.close());

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    fake = await FakeE621.start();
  });

  tearDown(() => fake.stop());

  /// Builds a real client around the fake server, like a filter page does.
  Future<Client> makeClient() async {
    final traits = ValueNotifier(
      const Traits(
        id: 1,
        userId: null,
        denylist: [],
        homeTags: '',
        avatar: null,
        perPage: null,
      ),
    );
    addTearDown(traits.dispose);
    return Client(
      identity: Identity(id: 1, host: fake.url, username: null, headers: null),
      traits: traits,
      storage: AppStorage(
        preferences: await SharedPreferences.getInstance(),
        temporaryFiles: '.',
        queryCache: CachedQuery.asNewInstance(),
        sqlite: sqlite,
      ),
    );
  }

  Widget wrap({required Client client, required Widget child}) => MultiProvider(
    providers: [Provider<Client>.value(value: client)],
    child: MaterialApp(
      locale: const Locale('zh'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: Center(child: child)),
    ),
  );

  testWidgets('the tag input suggests metatag values locally', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    final client = await makeClient();
    addTearDown(client.dispose);

    await tester.pumpWidget(
      wrap(
        client: client,
        child: TagInput(controller: controller, metatagSuggestions: true),
      ),
    );

    await tester.enterText(find.byType(TextField), 'order:ra');
    await tester.pump(const Duration(milliseconds: 400));
    // Let the suggestion box finish its entrance animation.
    await tester.pumpAndSettle();

    // The full metatag string is the main text of each suggestion...
    expect(find.text('order:rank'), findsOneWidget);
    expect(find.text('order:random'), findsOneWidget);
    // ...while the localized value teaches what it means.
    expect(find.text('排名'), findsOneWidget);
    expect(find.text('随机'), findsOneWidget);

    // Picking a suggestion replaces the tag being typed.
    await tester.tap(find.text('order:rank'));
    await tester.pump();

    expect(controller.text, 'order:rank ');
  });

  testWidgets('the tag input ignores suggestions once a tag is picked', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    final client = await makeClient();
    addTearDown(client.dispose);

    await tester.pumpWidget(
      wrap(
        client: client,
        child: TagInput(controller: controller, metatagSuggestions: true),
      ),
    );

    await tester.enterText(find.byType(TextField), 'order:ra');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    // Picking one suggestion empties the current tag, and the suggestion
    // list needs another debounce turn to catch up, so a second pick right
    // after targets an empty tag.
    await tester.tap(find.text('order:rank'));
    await tester.tap(find.text('order:random'));
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(controller.text, 'order:rank ');
  });

  testWidgets('the tag input ignores suggestions after a trailing space', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    final client = await makeClient();
    addTearDown(client.dispose);

    await tester.pumpWidget(
      wrap(
        client: client,
        child: TagInput(controller: controller, metatagSuggestions: true),
      ),
    );

    await tester.enterText(find.byType(TextField), 'order:ra');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    // A trailing space empties the current tag, and the suggestions of the
    // previous text stay around for another debounce turn.
    await tester.enterText(find.byType(TextField), 'order:ra ');
    await tester.pump(const Duration(milliseconds: 100));

    await tester.tap(find.text('order:rank'));
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(controller.text, 'order:ra ');
  });

  testWidgets('the tag input suggests the oldest order', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    final client = await makeClient();
    addTearDown(client.dispose);

    await tester.pumpWidget(
      wrap(
        client: client,
        child: TagInput(controller: controller, metatagSuggestions: true),
      ),
    );

    await tester.enterText(find.byType(TextField), 'order:id');
    await tester.pump(const Duration(milliseconds: 400));
    // Let the suggestion box finish its entrance animation.
    await tester.pumpAndSettle();

    expect(find.text('order:id_asc'), findsOneWidget);
    // The localized value teaches what the metatag means.
    expect(find.text('最旧优先'), findsOneWidget);

    // Picking the suggestion replaces the tag being typed.
    await tester.tap(find.text('order:id_asc'));
    await tester.pump();

    expect(controller.text, 'order:id_asc ');
  });

  testWidgets('the tag input keeps operators on metatag insert', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    final client = await makeClient();
    addTearDown(client.dispose);

    await tester.pumpWidget(
      wrap(
        client: client,
        child: TagInput(controller: controller, metatagSuggestions: true),
      ),
    );

    await tester.enterText(find.byType(TextField), '-rating:s');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(find.text('rating:s'), findsOneWidget);

    await tester.tap(find.text('rating:s'));
    await tester.pump();

    expect(controller.text, '-rating:s ');
  });

  testWidgets('the tag input hides metatag suggestions by default', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    final client = await makeClient();
    addTearDown(client.dispose);

    await tester.pumpWidget(
      wrap(
        client: client,
        child: TagInput(controller: controller),
      ),
    );

    await tester.enterText(find.byType(TextField), 'order:rank');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    // The only "order:rank" text is the input itself: the server's
    // autocomplete rejects colons, so no suggestions are shown.
    expect(find.text('order:rank'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
