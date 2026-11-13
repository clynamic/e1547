import 'package:e1547/follow/follow.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/environment.dart';
import '../../_support/harness.dart';
import '../../_support/posts.dart';

void main() {
  setUpAll(initializeTestApp);

  late TestEnvironment env;

  setUp(
    () async => env = await TestEnvironment.start(denylist: ['blocked_tag']),
  );

  tearDown(() => env.dispose());

  Finder markOf(String tag) => find.descendant(
    of: find.ancestor(of: find.text(tag), matching: find.byType(ColoredCard)),
    matching: find.byType(Icon),
  );

  IconData? shownMark(WidgetTester tester, String tag) =>
      tester.widget<Icon>(markOf(tag)).icon;

  displayTest('tags show the denylist or the type they are followed by', (
    tester,
  ) async {
    await tester.runAsync(() async {
      await env.client.follows.create(
        tags: 'notified_tag',
        type: FollowType.notify,
      );
      await env.client.follows.create(
        tags: 'updated_tag',
        type: FollowType.update,
      );
      await env.client.follows.create(
        tags: 'saved_tag',
        type: FollowType.bookmark,
      );
      await tester.pumpWidget(
        env.app(
          Scaffold(
            body: SingleChildScrollView(
              child: TagDisplay(
                post: samplePost(
                  tags: const {
                    'general': [
                      'blocked_tag',
                      'notified_tag',
                      'updated_tag',
                      'saved_tag',
                      'plain_tag',
                    ],
                  },
                ),
              ),
            ),
          ),
        ),
      );
    });
    await env.settle(tester);

    expect(shownMark(tester, 'blocked tag'), Icons.block);
    expect(shownMark(tester, 'notified tag'), Icons.notifications_active);
    expect(shownMark(tester, 'updated tag'), Icons.person_add);
    expect(shownMark(tester, 'saved tag'), Icons.bookmark);
    expect(markOf('plain tag'), findsNothing);
  });
}
