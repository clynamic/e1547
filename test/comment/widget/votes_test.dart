import 'package:e1547/client/client.dart';
import 'package:e1547/comment/comment.dart';
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

  final Comment comment = Comment(
    id: 999999,
    postId: 1,
    body: 'a comment',
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
    creatorId: 1,
    creatorName: 'tester',
    score: 0,
    vote: null,
    warning: null,
    hidden: false,
  );

  for (final (IconData icon, String verb) in [
    (Icons.arrow_upward, 'upvote'),
    (Icons.arrow_downward, 'downvote'),
  ]) {
    displayTest('a comment $verb the site refuses says so and stays off', (
      tester,
    ) async {
      await tester.pumpWidget(
        env.app(Scaffold(body: CommentVotes(comment: comment))),
      );
      await tester.tap(find.byIcon(icon));
      await env.settle(tester);

      expect(find.text('Failed to $verb comment #999999'), findsOneWidget);
      expect(tester.widget<Icon>(find.byIcon(icon)).color, isNull);
    });
  }
}
