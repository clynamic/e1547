import 'package:e1547/post/post.dart';
import 'package:flutter_test/flutter_test.dart';

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
    test('holds at the start when the offset reaches past it', () {
      expect(seek(step - const Duration(seconds: 1), -step), Duration.zero);
    });

    test('holds at the end when the offset reaches past it', () {
      expect(
        seek(duration - step + const Duration(seconds: 1), step),
        duration,
      );
    });

    test('holds where it is when there is nowhere left to go', () {
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
}
