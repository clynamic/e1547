import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/video.dart';

void main() {
  const Duration frame = Duration(milliseconds: 10);
  late VideoPlayer player;

  setUp(() => player = VideoPlayer(platformPlayer: FakePlatformPlayer()));

  tearDown(() => player.dispose());

  Future<void> doubleTapThenLeave(WidgetTester tester, Duration after) async {
    await tester.pumpWidget(
      MaterialApp(home: VideoGesture(forward: true, player: player)),
    );

    await tester.tap(find.byType(VideoGesture));
    await tester.pump(kDoubleTapMinTime);
    await tester.tap(find.byType(VideoGesture));
    for (Duration passed = Duration.zero; passed < after; passed += frame) {
      await tester.pump(frame);
    }

    expect(player.state.position, const Duration(seconds: 10));

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets(
    'stops its seek animation when it is removed from the tree',
    (tester) => doubleTapThenLeave(tester, const Duration(milliseconds: 100)),
  );

  testWidgets(
    'stops its seek count timer when it is removed from the tree',
    (tester) => doubleTapThenLeave(tester, const Duration(milliseconds: 880)),
  );
}
