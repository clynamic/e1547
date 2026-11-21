import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/video.dart';

void main() {
  const duration = Duration(minutes: 1);
  const step = Duration(seconds: 10);

  Duration seek(Duration position, Duration offset, {Duration? total}) =>
      videoSeekTarget(
        position: position,
        duration: total ?? duration,
        offset: offset,
      );

  group('videoSeekTarget', () {
    test('holds at the start for an offset past it', () {
      expect(seek(step - const Duration(seconds: 1), -step), Duration.zero);
    });

    test('holds at the end for an offset past it', () {
      expect(
        seek(duration - step + const Duration(seconds: 1), step),
        duration,
      );
    });

    test('holds at either end for an offset past it', () {
      expect(seek(Duration.zero, -step), Duration.zero);
      expect(seek(duration, step), duration);
    });

    test('moves by the offset while both ends are clear', () {
      const middle = Duration(seconds: 30);
      expect(seek(middle, -step), middle - step);
      expect(seek(middle, step), middle + step);
    });

    test('moves forward while the duration is still unknown', () {
      expect(seek(step, step, total: Duration.zero), step * 2);
    });
  });

  group('videoTime', () {
    test('shows minutes and seconds below an hour', () {
      expect(videoTime(const Duration(minutes: 4, seconds: 5)), '04:05');
    });

    test('shows hours for an hour and longer', () {
      expect(
        videoTime(const Duration(hours: 1, minutes: 2, seconds: 3)),
        '1:02:03',
      );
    });
  });

  testWidgets('a video bar rebuilt with another player shows that player', (
    tester,
  ) async {
    final VideoService videos = fakeVideoService();
    final VideoPlayer first = VideoPlayer(platformPlayer: FakePlatformPlayer());
    final VideoPlayer second = VideoPlayer(
      platformPlayer: FakePlatformPlayer(),
    );
    addTearDown(() async {
      await first.dispose();
      await second.dispose();
      videos.dispose();
    });
    await second.seek(const Duration(seconds: 5));

    Widget bar(VideoPlayer player) => ChangeNotifierProvider.value(
      value: videos,
      child: MaterialApp(
        home: Scaffold(body: VideoBar(player: player)),
      ),
    );

    await tester.pumpWidget(bar(first));
    expect(find.text('00:05'), findsNothing);

    await tester.pumpWidget(bar(second));

    expect(find.text('00:05'), findsOneWidget);

    await first.seek(const Duration(seconds: 9));
    await tester.pump();

    expect(find.text('00:05'), findsOneWidget);

    await second.seek(const Duration(seconds: 7));
    await tester.pump();

    expect(find.text('00:07'), findsOneWidget);
  });
}
