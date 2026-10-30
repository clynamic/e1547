import 'dart:async';

import 'package:e1547/follow/follow.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/bed.dart';
import '../../_support/harness.dart';

void main() {
  late TestBed bed;

  setUpAll(initializeTestApp);

  setUp(() async => bed = await TestBed.start(username: 'tester'));

  tearDown(() => bed.dispose());

  test('a sync brings follows with new posts into the unseen list', () async {
    await bed.client.follows.create(tags: 'tag_1', type: FollowType.update);
    final follow = (await bed.client.follows.getByTags(tags: 'tag_1'))!;
    addTearDown(() => bed.client.follows.delete(follow.id));
    await bed.client.follows.repository.replace(
      follow.copyWith(unseen: 0, latest: 1000),
    );

    final query = bed.client.follows.usePage(
      query: FollowsQuery(types: [FollowType.update], hasUnseen: true),
    );
    final lists = StreamController<List<int>>.broadcast();
    final subscription = query.stream.listen((state) {
      final pages = state.data?.pages;
      if (pages != null) lists.add(pages.expand((p) => p).toList());
    });
    addTearDown(subscription.cancel);
    addTearDown(lists.close);

    expect(await lists.stream.first, isEmpty);

    final refreshed = lists.stream.firstWhere((ids) => ids.isNotEmpty);
    await bed.client.followServer.sync(force: true);

    expect(await refreshed.timeout(const Duration(seconds: 2)), [follow.id]);
  });

  test('a cancelled sync ends and lets the next one run', () async {
    final first = bed.client.followServer.sync(force: true);
    final cancelled = bed.client.followServer.currentSync!..cancel();
    await first.timeout(const Duration(seconds: 2));

    final next = bed.client.followServer.sync(force: true);
    expect(bed.client.followServer.currentSync, isNot(same(cancelled)));
    await next.timeout(const Duration(seconds: 2));
  });
}
