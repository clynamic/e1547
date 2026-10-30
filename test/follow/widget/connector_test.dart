import 'package:e1547/follow/follow.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/bed.dart';
import '../../_support/harness.dart';

void main() {
  late TestBed bed;

  setUpAll(initializeTestApp);

  setUp(() async => bed = await TestBed.start(username: 'tester'));

  tearDown(() => bed.dispose());

  Future<Follow> seedFollow(WidgetTester tester, String tags) async {
    final follow = await tester.runAsync(() async {
      await bed.client.follows.create(tags: tags, type: FollowType.update);
      final follow = (await bed.client.follows.getByTags(tags: tags))!;
      await bed.client.follows.repository.replace(
        follow.copyWith(unseen: 3, latest: 1000),
      );
      return follow;
    });
    addTearDown(
      () => tester.runAsync(() => bed.client.follows.delete(follow!.id)),
    );
    return follow!;
  }

  Future<void> visit(WidgetTester tester, String tags) async {
    final filter = PostFilter(bed.client);
    addTearDown(filter.dispose);
    await tester.runAsync(() async {
      await tester.pumpWidget(
        bed.app(
          FilterControllerProvider<PostFilter, Post>.value(
            value: filter,
            child: ChangeNotifierProvider(
              create: (_) =>
                  PostParamsController(initial: PostParams(tags: tags)),
              child: FollowSeenConnector(
                child: PostPageQueryBuilder(
                  builder: (context, state, query) => const SizedBox(),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await Future<void>.delayed(const Duration(milliseconds: 200));
    });
    await tester.pump();
  }

  displayTest('visiting a followed search marks it seen', (tester) async {
    final follow = await seedFollow(tester, 'tag_1');

    await visit(tester, 'tag_1');

    final updated = await tester.runAsync(
      () => bed.client.follows.get(id: follow.id),
    );
    expect(updated!.unseen, 0);
    expect(updated.latest, 1042);
    expect(updated.thumbnail, isNotNull);
  });

  displayTest('visiting a follow takes its latest from posts it shows', (
    tester,
  ) async {
    bed.traits.value = bed.traits.value.copyWith(denylist: ['tag_114']);
    final follow = await seedFollow(tester, 'tag_1');

    await visit(tester, 'tag_1');

    final updated = await tester.runAsync(
      () => bed.client.follows.get(id: follow.id),
    );
    expect(updated!.latest, 1021);
    expect(updated.thumbnail, bed.client.posts.postCache.get(1021)!.sample);
  });

  displayTest('visiting a search leaves other follows alone', (tester) async {
    final follow = await seedFollow(tester, 'tag_2');

    await visit(tester, 'tag_1');

    final updated = await tester.runAsync(
      () => bed.client.follows.get(id: follow.id),
    );
    expect(updated!.unseen, 3);
    expect(updated.latest, 1000);
  });
}
