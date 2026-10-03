import 'dart:async';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../_support/harness.dart';

void main() {
  late AppDatabase sqlite;
  late IdentityClient client;
  late Directory tempDir;
  late GlobalKey<NavigatorState> navigatorKey;

  setUpAll(() async {
    await initializeTestApp();
  });

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('identity-login');
    // The production app runs its database in a background isolate, where
    // constraint violations arrive wrapped as DriftRemoteException; the
    // duplicate login path matches on exactly that shape. Isolate database
    // calls only complete in real time, so every read and write below is
    // wrapped in tester.runAsync.
    sqlite = AppDatabase(
      NativeDatabase.createInBackground(File('${tempDir.path}/app.db')),
    );
    client = IdentityClient(database: sqlite);
    navigatorKey = GlobalKey<NavigatorState>();
  });

  tearDown(() async {
    client.dispose();
    await sqlite.close();
    await tempDir.delete(recursive: true);
  });

  /// Pushes a [LoginLoadingDialog] and lets its login chain run.
  Future<void> pumpDialog(
    WidgetTester tester, {
    Identity? identity,
    required String host,
    String? username,
    String? apikey,
    bool activate = false,
    void Function(String?)? onError,
    void Function()? onDone,
  }) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<IdentityClient>.value(value: client),
          ],
          child: MaterialApp(
            navigatorKey: navigatorKey,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const Scaffold(body: SizedBox.shrink()),
          ),
        ),
      );
      unawaited(
        showDialog(
          context: navigatorKey.currentContext!,
          builder: (context) => LoginLoadingDialog(
            identity: identity,
            host: host,
            username: username,
            apikey: apikey,
            activate: activate,
            onError: onError,
            onDone: onDone,
          ),
        ),
      );
      await tester.pump();
      // The login chain runs isolate database roundtrips; they only
      // complete in real time.
      await Future<void>.delayed(const Duration(milliseconds: 500));
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
  }

  testWidgets('logging in as a guest is idempotent', (tester) async {
    String seededHost = '';
    int activeBefore = 0;
    await tester.runAsync(() async {
      final existing = await client.add(
        const IdentityRequest(host: 'e621.net'),
      );
      seededHost = existing.host;
      await client.activate(existing.id);
      activeBefore = client.identity.id;
    });

    var done = false;
    await pumpDialog(
      tester,
      host: 'e621.net',
      activate: true,
      onDone: () => done = true,
    );

    expect(done, isTrue);
    List<Identity> all = const [];
    await tester.runAsync(() async {
      all = await client.page(page: 1, limit: 9999);
    });
    // The duplicate guest login reuses the existing identity instead of
    // adding a second row for the same host.
    expect(
      all.where((e) => e.host == seededHost && e.username == null),
      hasLength(1),
    );
    expect(client.identity.id, activeBefore);
  });

  testWidgets('a duplicate login reports the duplicate reason', (tester) async {
    await tester.runAsync(() async {
      await client.add(
        const IdentityRequest(host: 'e621.net', username: 'bob'),
      );
    });

    String? error;
    await pumpDialog(
      tester,
      host: 'e621.net',
      username: 'bob',
      apikey: 'key',
      onError: (reason) => error = reason,
    );

    final l10n = AppLocalizations.of(
      tester.element(find.byType(Scaffold).first),
    );
    expect(error, l10n.identityDuplicate);
  });

  testWidgets('saving an edited identity keeps the omitted api key', (
    tester,
  ) async {
    final headers = {
      HttpHeaders.authorizationHeader: 'Basic Ym9iOmt5NXdvcmQ=', // bob:ky5word
    };
    late Identity existing;
    await tester.runAsync(() async {
      existing = await client.add(
        IdentityRequest(host: 'e621.net', username: 'bob', headers: headers),
      );
      await client.activate(existing.id);
    });

    var done = false;
    await pumpDialog(
      tester,
      identity: existing,
      host: 'e621.net',
      username: 'bob',
      // The form shows dashes instead of the saved api key; the login has
      // to recover the real credentials from the stored headers.
      apikey: OmittedPasswordTextInputFormatter.passwordOmitted,
      onDone: () => done = true,
    );

    expect(done, isTrue);
    Identity saved = existing;
    await tester.runAsync(() async {
      saved = await client.get(existing.id);
    });
    expect(
      saved.headers?[HttpHeaders.authorizationHeader],
      headers[HttpHeaders.authorizationHeader],
    );
  });
}
