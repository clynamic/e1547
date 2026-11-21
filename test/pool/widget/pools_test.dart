import 'package:e1547/pool/pool.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/environment.dart';
import '../../_support/gestures.dart';
import '../../_support/harness.dart';

void main() {
  setUpAll(initializeTestApp);

  late TestEnvironment env;

  setUp(() async {
    env = await TestEnvironment.start();
    final Map<String, Object?> recorded = env.fake.state.pools.first;
    env.fake.state.pools
      ..clear()
      ..addAll([
        for (int i = 0; i < 30; i++)
          {...recorded, 'id': 500 + i, 'name': 'pool_$i', 'post_ids': <int>[]},
      ]);
  });

  tearDown(() => env.dispose());

  displayTest('a double tap on the bar scrolls the pool list to its top', (
    tester,
  ) async {
    await tester.runAsync(() => tester.pumpWidget(env.app(const PoolsPage())));
    await env.settle(tester, animating: true);
    final double top = tester.getTopLeft(find.byType(PoolTile).first).dy;

    await tester.drag(find.byType(PoolTile).first, const Offset(0, -600));
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.getTopLeft(find.byType(PoolTile).first).dy, isNot(top));

    await doubleTap(tester, tester.getCenter(find.byType(AppBar)));

    expect(tester.getTopLeft(find.byType(PoolTile).first).dy, top);
  });
}
