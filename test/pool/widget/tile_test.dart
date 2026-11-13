import 'package:e1547/pool/pool.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/environment.dart';
import '../../_support/harness.dart';

void main() {
  setUpAll(initializeTestApp);

  late TestEnvironment env;

  setUp(() async => env = await TestEnvironment.start());

  tearDown(() => env.dispose());

  Pool pool(int id) => Pool(
    id: id,
    name: id.isEven ? 'a_pool_with_a_name_long_enough_for_two_lines' : 'pool',
    createdAt: DateTime(2000),
    updatedAt: DateTime(2000),
    description: '',
    postIds: const [],
    postCount: 3,
    active: true,
  );

  Future<List<double>> coverHeights(
    WidgetTester tester,
    GridQuilt stagger,
  ) async {
    await tester.pumpWidget(
      env.app(
        Scaffold(
          body: TileLayout(
            stagger: stagger,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final int id in [1, 2])
                  SizedBox(width: 120, child: PoolTile(pool: pool(id))),
              ],
            ),
          ),
        ),
      ),
    );
    return [
      for (final Element cover in find.byType(PoolCover).evaluate())
        cover.size!.height,
    ];
  }

  displayTest('pool covers share one height in a grid of fixed tiles', (
    tester,
  ) async {
    final List<double> heights = await coverHeights(tester, GridQuilt.square);

    expect(heights, [144, 144]);
  });

  displayTest('pool covers take their own height in a staggered grid', (
    tester,
  ) async {
    final List<double> heights = await coverHeights(tester, GridQuilt.vertical);

    expect(heights.first, isNot(heights.last));
  });

  displayTest('pools with short and long names are as tall as each other in '
      'a grid of fixed tiles', (tester) async {
    await coverHeights(tester, GridQuilt.square);

    final List<double> counts = [
      for (final Element count in find.text('3 posts').evaluate())
        tester.getBottomLeft(find.byWidget(count.widget)).dy,
    ];
    expect(counts.first, counts.last);
    expect(find.textContaining('two lines'), findsOneWidget);
  });
}
