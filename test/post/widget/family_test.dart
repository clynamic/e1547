import 'package:e1547/post/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/environment.dart';
import '../../_support/harness.dart';
import '../../_support/posts.dart';

void main() {
  setUpAll(initializeTestApp);

  late TestEnvironment env;

  setUp(() async => env = await TestEnvironment.start());

  tearDown(() => env.dispose());

  Future<void> showFamily(
    WidgetTester tester, {
    Set<int> deleted = const {},
  }) async {
    final Map<String, Object?> recorded = env.fake.state.posts.first;
    env.fake.state.posts.addAll([
      for (final int id in [31, 33, 32])
        {
          ...recorded,
          'id': id,
          'relationships': {
            ...(recorded['relationships']! as Map<String, Object?>),
            'parent_id': 30,
          },
          'flags': {
            ...(recorded['flags']! as Map<String, Object?>),
            'deleted': deleted.contains(id),
          },
        },
    ]);
    final Post parent = samplePost(
      id: 30,
      relationships: const Relationships(
        parentId: null,
        hasChildren: true,
        hasActiveChildren: true,
        children: [31, 32, 33],
      ),
    );
    env.client.posts.postCache.set(parent);
    await tester.runAsync(
      () => tester.pumpWidget(
        env.app(
          Scaffold(
            body: SingleChildScrollView(
              child: RelationshipDisplay(post: parent),
            ),
          ),
        ),
      ),
    );
    await env.settle(tester);
  }

  Future<void> openChild(WidgetTester tester, int id) async {
    await tester.tap(
      find.byWidgetPredicate((e) => e is PostRelationPreview && e.id == id),
    );
    await env.settle(tester, animating: true);
  }

  displayTest('a child opens among its siblings, oldest first', (tester) async {
    await showFamily(tester);

    await openChild(tester, 32);
    expect(shownPost(tester), 32);

    await tester.fling(find.byType(PostDetail), const Offset(600, 0), 2000);
    await env.settle(tester, animating: true);
    expect(shownPost(tester), 31);
  });

  displayTest('a child of a cached family opens without waiting', (
    tester,
  ) async {
    await showFamily(tester);

    await tester.tap(
      find.byWidgetPredicate((e) => e is PostRelationPreview && e.id == 32),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(skeletons(find.byType(PostDetail)), findsNothing);
    expect(shownPost(tester), 32);
    await env.settle(tester, animating: true);
  });

  displayTest('a child the search leaves out opens alone', (tester) async {
    await showFamily(tester, deleted: {32});

    await openChild(tester, 32);

    expect(find.byType(PostLoadingPage), findsOneWidget);
    expect(shownPost(tester), 32);
  });
}
