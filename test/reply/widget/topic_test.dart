import 'package:e1547/client/client.dart';
import 'package:e1547/reply/reply.dart';
import 'package:e1547/topic/topic.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/environment.dart';
import '../../_support/fixtures.dart';
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

  displayTest('shows no reply button on a locked topic', (tester) async {
    Topic topic({required bool locked}) => E621Topic.fromJson({
      ...loadFixtureList('topics.json').first,
      'is_locked': locked,
    });

    await tester.pumpWidget(
      env.app(TopicRepliesPage(topic: topic(locked: false))),
    );
    await env.settle(tester);

    expect(find.byType(ReplyCreateFab), findsOneWidget);

    await tester.pumpWidget(
      env.app(TopicRepliesPage(topic: topic(locked: true))),
    );
    await env.settle(tester);

    expect(find.byType(ReplyCreateFab), findsNothing);
  });
}
