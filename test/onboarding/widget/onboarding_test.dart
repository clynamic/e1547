import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/onboarding/onboarding.dart';
import 'package:e1547/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notified_preferences/notified_preferences.dart';
import 'package:provider/provider.dart';
import 'package:relative_time/relative_time.dart';

import '../../_support/harness.dart';

void main() {
  late AppDatabase sqlite;
  late Settings settings;
  late IdentityClient identities;

  setUpAll(() => initializeTestApp());

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    settings = await Settings.getInstance();
    sqlite = AppDatabase(NativeDatabase.memory());
    identities = IdentityClient(database: sqlite);
    final identity = await identities.add(
      const IdentityRequest(host: 'e621.net'),
    );
    await identities.activate(identity.id);
  });

  tearDown(() async {
    identities.dispose();
    await sqlite.close();
  });

  Widget wrap(Widget child, {Locale locale = const Locale('en')}) =>
      MultiProvider(
        providers: [
          Provider<Settings>.value(value: settings),
          ChangeNotifierProvider<IdentityClient>.value(value: identities),
        ],
        child: MaterialApp(
          locale: locale,
          localizationsDelegates: const [
            ...AppLocalizations.localizationsDelegates,
            GlobalCupertinoLocalizations.delegate,
            RelativeTimeLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: child,
        ),
      );

  testWidgets('renders the language step as the first page', (tester) async {
    await tester.pumpWidget(wrap(const OnboardingScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Choose a language'), findsOneWidget);
    expect(find.text('System default'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('简体中文'), findsOneWidget);
    expect(find.text('繁體中文'), findsOneWidget);

    // the step is rendered in english, not any other locale
    expect(find.text('选择语言'), findsNothing);
    expect(find.text('選擇語言'), findsNothing);

    // without a stored language, the system default tile is checked
    expect(settings.language.value, isNull);
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('selecting languages updates the setting', (tester) async {
    await tester.pumpWidget(wrap(const OnboardingScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('简体中文'));
    await tester.pumpAndSettle();
    expect(settings.language.value, 'zh');
    expect(find.byIcon(Icons.check), findsOneWidget);

    await tester.tap(find.text('System default'));
    await tester.pumpAndSettle();
    expect(settings.language.value, isNull);
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('offers and selects the japanese and russian languages', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(const OnboardingScreen()));
    await tester.pumpAndSettle();

    // both the onboarding step and the settings language dialog
    // iterate appLanguages, so these options appear in both
    expect(find.text('日本語'), findsOneWidget);
    expect(find.text('Русский'), findsOneWidget);

    await tester.tap(find.text('日本語'));
    await tester.pumpAndSettle();
    expect(settings.language.value, 'ja');
    expect(find.byIcon(Icons.check), findsOneWidget);

    await tester.tap(find.text('Русский'));
    await tester.pumpAndSettle();
    expect(settings.language.value, 'ru');
    expect(find.byIcon(Icons.check), findsOneWidget);
  });
}
