import 'dart:convert';

import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/environment.dart';
import '../../_support/harness.dart';

void main() {
  setUpAll(initializeTestApp);

  late TestEnvironment env;
  late IdentityClient identities;
  late Identity other;
  late ValueNotifier<Client> client;

  setUp(() async {
    env = await TestEnvironment.start();
    identities = IdentityClient(database: env.sqlite);
    other = await identities.add(
      IdentityRequest(host: env.fake.url, username: 'tester'),
    );
    await identities.activate(other.id);
    client = ValueNotifier(env.client);
  });

  tearDown(() async {
    client.dispose();
    identities.dispose();
    await env.dispose();
  });

  Future<void> show(WidgetTester tester) async {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
    await tester.pumpWidget(
      ChangeNotifierProvider<IdentityClient>.value(
        value: identities,
        child: ValueListenableBuilder<Client>(
          valueListenable: client,
          builder: (context, value, _) => Provider<Client>.value(
            value: value,
            child: MaterialApp(
              navigatorKey: navigatorKey,
              routes: {
                '/': (context) => const Text('home'),
                '/subscriptions': (context) => const Text('subscriptions'),
              },
              builder: (context, child) => NotificationHandler(
                child: NotificationOpener(
                  navigatorKey: navigatorKey,
                  child: child!,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> tap(WidgetTester tester, int identity) async {
    await tester.runAsync(
      () => tester
          .state<NotificationHandlerState>(find.byType(NotificationHandler))
          .handle(
            NotificationResponse(
              notificationResponseType:
                  NotificationResponseType.selectedNotification,
              payload: json.encode(
                NotificationPayload(identity: identity, type: 'follow'),
              ),
            ),
          ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('opens the subscriptions of the account a notification is for', (
    tester,
  ) async {
    await show(tester);

    await tap(tester, env.client.identity.id);

    expect(identities.identity.id, env.client.identity.id);
    expect(find.text('subscriptions'), findsOneWidget);
  });

  testWidgets(
    'keeps the active account for a notification of a removed account',
    (tester) async {
      await show(tester);

      await tap(tester, other.id + 1);

      expect(identities.identity.id, other.id);
      expect(find.text('home'), findsOneWidget);
    },
  );

  testWidgets('schedules no frames while a notification account loads', (
    tester,
  ) async {
    client.value = Client(
      identity: other,
      traits: env.traits,
      storage: env.client.storage,
    );
    await show(tester);

    await tap(tester, env.client.identity.id);

    expect(tester.binding.hasScheduledFrame, isFalse);
    expect(find.text('home'), findsOneWidget);

    client.value = env.client;
    await tester.pumpAndSettle();

    expect(find.text('subscriptions'), findsOneWidget);
  });
}
