import 'package:e1547/history/history.dart';
import 'package:e1547/reply/reply.dart';
import 'package:e1547/topic/topic.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/environment.dart';
import '../../_support/fixtures.dart';
import '../../_support/harness.dart';

void main() {
  setUpAll(initializeTestApp);

  late TestEnvironment env;

  setUp(() async => env = await TestEnvironment.start());

  tearDown(() => env.dispose());

  displayTest('a topic opened by number waits as its own page', (tester) async {
    final Map<String, Object?> recorded = loadFixtureList('topics.json').first;
    final int id = recorded['id']! as int;

    await tester.pumpWidget(env.app(TopicLoadingPage(id)));
    await tester.pump();

    expect(skeletons(find.byType(TopicRepliesPage)), findsOneWidget);
    expect(skeletons(find.byType(ReplyTile)), findsWidgets);

    await env.settle(tester);

    expect(skeletons(find.byType(TopicRepliesPage)), findsNothing);
    expect(find.text(recorded['title']! as String), findsOneWidget);
    expect(
      env.fake.requests
          .where((e) => e.path == '/forum_posts.json')
          .map((e) => e.query['search[topic_id]'])
          .toSet(),
      {'$id'},
    );
    final List<History>? history = await tester.runAsync(
      () => env.client.histories.page(),
    );
    expect(history?.map((e) => e.link), ['/forum_topics/$id']);
  });
}
