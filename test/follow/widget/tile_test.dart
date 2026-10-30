import 'package:e1547/follow/follow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/bed.dart';
import '../../_support/harness.dart';

Follow sampleFollow({String? thumbnail, int? latest}) => Follow(
  id: 1,
  tags: 'canine',
  title: null,
  alias: null,
  type: FollowType.bookmark,
  latest: latest,
  unseen: 0,
  thumbnail: thumbnail,
  updated: null,
);

void main() {
  late TestBed bed;

  setUpAll(initializeTestApp);

  setUp(() async => bed = await TestBed.start());

  tearDown(() => bed.dispose());

  Future<void> show(WidgetTester tester, Follow follow) => tester.pumpWidget(
    bed.app(
      Scaffold(
        body: Center(
          child: SizedBox(width: 200, child: FollowTile(follow: follow)),
        ),
      ),
    ),
  );

  group('FollowTile', () {
    displayTest('shows a placeholder icon without a thumbnail', (tester) async {
      await show(tester, sampleFollow(latest: 10));

      expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
    });

    displayTest('shows the thumbnail when it has one', (tester) async {
      await show(tester, sampleFollow(latest: 10, thumbnail: '/preview/10'));

      expect(find.byIcon(Icons.image_not_supported_outlined), findsNothing);
      expect(find.byType(Hero), findsOneWidget);
    });
  });
}
