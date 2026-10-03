import 'package:e1547/l10n/app_localizations.dart';
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

  late VideoService videos;

  setUp(() {
    videos = VideoService();
  });

  tearDown(() => videos.dispose());

  Widget wrap(Widget child) => MultiProvider(
    providers: [ChangeNotifierProvider<VideoService>.value(value: videos)],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: Center(child: child)),
    ),
  );

  Future<void> pumpVideoGesture(
    WidgetTester tester, {
    required FakePlatformPlayer platform,
    bool forward = true,
  }) async {
    await tester.pumpWidget(
      wrap(
        SizedBox.expand(
          child: VideoGesture(
            forward: forward,
            player: VideoPlayer(platformPlayer: platform),
          ),
        ),
      ),
    );
  }

  Future<void> doubleTap(WidgetTester tester) async {
    await tester.tap(find.byType(VideoGesture));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.byType(VideoGesture));
    await tester.pump();
  }

  group('VideoGesture', () {
    testWidgets('seeks by ten seconds per double tap', (tester) async {
      final platform = FakePlatformPlayer()
        ..setDuration(duration)
        ..setPosition(step);
      await pumpVideoGesture(tester, platform: platform);

      await doubleTap(tester);
      await tester.pumpAndSettle(const Duration(milliseconds: 16));
      // let the combo reset timer elapse while the gesture is still mounted
      await tester.pump(const Duration(milliseconds: 500));

      expect(platform.seeks, [step * 2]);
    });

    testWidgets('does nothing when the offset cannot move the position', (
      tester,
    ) async {
      final platform = FakePlatformPlayer()
        ..setDuration(duration)
        ..setPosition(Duration.zero);
      await pumpVideoGesture(tester, platform: platform, forward: false);

      await doubleTap(tester);
      await tester.pumpAndSettle(const Duration(milliseconds: 16));
      // let any pending gesture recognizer timers elapse
      await tester.pump(const Duration(milliseconds: 500));

      expect(platform.seeks, isEmpty);
      expect(tester.takeException(), isNull);
    });

    testWidgets('releases its animation when unmounted mid-flight', (
      tester,
    ) async {
      final platform = FakePlatformPlayer()
        ..setDuration(duration)
        ..setPosition(step);
      await pumpVideoGesture(tester, platform: platform);

      await doubleTap(tester);
      // the forward animation is now running
      await tester.pump(const Duration(milliseconds: 50));

      await tester.pumpWidget(wrap(const SizedBox()));
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(platform.seeks, [step * 2]);
    });

    testWidgets('cancels its combo timer when unmounted after the animation', (
      tester,
    ) async {
      final platform = FakePlatformPlayer()
        ..setDuration(duration)
        ..setPosition(step);
      await pumpVideoGesture(tester, platform: platform);

      await doubleTap(tester);
      // the 400ms forward and reverse animations settle inside the 900ms
      // combo window, which leaves the combo timer armed
      await tester.pumpAndSettle(const Duration(milliseconds: 16));

      await tester.pumpWidget(wrap(const SizedBox()));
      await tester.pump(const Duration(seconds: 2));

      expect(tester.takeException(), isNull);
    });
  });

  group('VideoBar', () {
    Future<void> pumpVideoBar(
      WidgetTester tester, {
      required FakePlatformPlayer platform,
    }) async {
      await tester.pumpWidget(
        wrap(VideoBar(player: VideoPlayer(platformPlayer: platform))),
      );
      await tester.pump();
    }

    testWidgets('routes slider seeks to its player', (tester) async {
      final platform = FakePlatformPlayer()..setDuration(duration);
      await pumpVideoBar(tester, platform: platform);

      // the slider stays disabled until a position arrives
      platform.setPosition(step);
      await tester.pump();
      await tester.pump();

      await tester.drag(find.byType(Slider), const Offset(100, 0));
      await tester.pump();

      expect(platform.seeks, hasLength(1));
      expect(
        platform.seeks.single,
        allOf(greaterThanOrEqualTo(step), lessThanOrEqualTo(duration)),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('syncs with a replaced player in the same slot', (
      tester,
    ) async {
      final first = FakePlatformPlayer()
        ..setDuration(duration)
        ..setPosition(const Duration(seconds: 30));
      await pumpVideoBar(tester, platform: first);
      expect(find.text('00:30'), findsOneWidget);
      expect(find.text('01:00'), findsOneWidget);

      final second = FakePlatformPlayer()
        ..setDuration(const Duration(minutes: 2))
        ..setPosition(const Duration(seconds: 90));
      await pumpVideoBar(tester, platform: second);

      expect(find.text('01:30'), findsOneWidget);
      expect(find.text('02:00'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('ignores events from a replaced player', (tester) async {
      final first = FakePlatformPlayer()..setDuration(duration);
      final second = FakePlatformPlayer()
        ..setDuration(const Duration(minutes: 2))
        ..setPosition(const Duration(seconds: 90));
      await pumpVideoBar(tester, platform: first);
      await pumpVideoBar(tester, platform: second);

      // the old player keeps reporting positions
      first.setPosition(const Duration(seconds: 30));
      await tester.pump();
      await tester.pump();

      expect(find.text('00:30'), findsNothing);
      expect(find.text('01:30'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('resets its position when the player completes', (
      tester,
    ) async {
      final platform = FakePlatformPlayer()..setDuration(duration);
      await pumpVideoBar(tester, platform: platform);

      platform.setPosition(step);
      await tester.pump();
      await tester.pump();
      expect(find.text('00:10'), findsOneWidget);

      platform.complete();
      await tester.pump();
      await tester.pump();

      expect(find.text('00:00'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('tracks the buffered range of its player', (tester) async {
      final platform = FakePlatformPlayer()..setDuration(duration);
      await pumpVideoBar(tester, platform: platform);

      platform.setBuffer(step);
      await tester.pump();
      await tester.pump();

      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.secondaryTrackValue, step.inMilliseconds.toDouble());
      expect(tester.takeException(), isNull);
    });
  });
}
