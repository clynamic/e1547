import 'package:e1547/client/client.dart';
import 'package:e1547/markup/markup.dart';
import 'package:e1547/reply/reply.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/environment.dart';
import '../../_support/harness.dart';

void main() {
  setUpAll(initializeTestApp);

  late TestEnvironment env;

  setUp(
    () async => env = await TestEnvironment.start(
      credentials: const Credentials(username: 'tester', password: 'key'),
    ),
  );

  tearDown(() => env.dispose());

  displayTest(
    'a reply that fails to send shows an error and is not reported sent',
    (tester) async {
      await tester.pumpWidget(
        env.app(
          Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => writeReply(context: context, topicId: 999999),
                child: const Text('write'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('write'));
      await tester.pumpAndSettle();
      final DTextEditor editor = tester.widget(find.byType(DTextEditor));
      final String? error = await tester.runAsync<String?>(
        () async => editor.onSubmitted('a reply'),
      );
      await tester.pumpAndSettle();

      expect(error, 'Failed to send reply!');
      expect(find.text('Reply sent!'), findsNothing);
    },
  );
}
