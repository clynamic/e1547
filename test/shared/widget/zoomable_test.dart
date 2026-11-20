import 'package:e1547/shared/shared.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/gestures.dart';

void main() {
  late ZoomController zoom;
  late List<Offset> spare;
  late Velocity? ended;

  Future<void> pump(
    WidgetTester tester, {
    Size content = const Size(1600, 800),
  }) async {
    zoom = ZoomController();
    addTearDown(zoom.dispose);
    spare = [];
    ended = null;
    await tester.pumpWidget(
      MaterialApp(
        home: Zoomable(
          controller: zoom,
          content: content,
          onSpare: spare.add,
          onSpareEnd: (velocity) => ended = velocity,
          child: Container(color: Colors.red),
        ),
      ),
    );
  }

  double horizontal() => spare.fold<double>(0, (sum, e) => sum + e.dx);
  double vertical() => spare.fold<double>(0, (sum, e) => sum + e.dy);

  Offset under(Offset point) => zoom.transformation.toScene(point);

  testWidgets('passes a vertical drag on at rest scale', (tester) async {
    await pump(tester);

    await tester.drag(find.byType(Zoomable), const Offset(0, 120));
    await tester.pumpAndSettle();

    expect(vertical(), closeTo(100, 2));
    expect(horizontal(), 0);
    expect(ended, isNotNull);
  });

  testWidgets('a drag that begins away from an edge stays a pan', (
    tester,
  ) async {
    await pump(tester);
    zoom.transformation.value = Matrix4.identity()
      ..translateByDouble(-400, -300, 0, 1)
      ..scaleByDouble(2, 2, 1, 1);
    await tester.pump();

    await tester.drag(find.byType(Zoomable), const Offset(500, 600));
    await tester.pumpAndSettle();

    expect(spare, isEmpty);
    expect(zoom.transformation.value.getTranslation().y, -200);
  });

  testWidgets('a zoomed image keeps a vertical drag at its edge', (
    tester,
  ) async {
    await pump(tester);
    zoom.transformation.value = Matrix4.identity()..scaleByDouble(2, 2, 1, 1);
    await tester.pump();

    await tester.drag(find.byType(Zoomable), const Offset(0, 300));
    await tester.pumpAndSettle();

    expect(spare, isEmpty);
  });

  testWidgets('scrolling the mouse wheel zooms in', (tester) async {
    await pump(tester);
    final Offset centre = tester.getCenter(find.byType(Zoomable));
    final TestPointer mouse = TestPointer(1, PointerDeviceKind.mouse);
    mouse.hover(centre);
    for (int turn = 0; turn < 5; turn++) {
      await tester.sendEventToBinding(mouse.scroll(const Offset(0, -120)));
      await tester.pump();
    }

    expect(zoom.scale, greaterThan(1));
  });

  testWidgets('a zoom too small to count still passes a drag on', (
    tester,
  ) async {
    await pump(tester);
    zoom.transformation.value = Matrix4.identity()
      ..scaleByDouble(1.05, 1.05, 1, 1);
    await tester.pump();
    expect(zoom.isZoomed, isFalse);

    await tester.drag(find.byType(Zoomable), const Offset(0, 400));
    await tester.pumpAndSettle();

    expect(vertical(), greaterThan(300));
  });

  testWidgets('a double tap after a free zoom returns to rest', (tester) async {
    await pump(tester);
    zoom.transformation.value = Matrix4.identity()
      ..translateByDouble(-100, -100, 0, 1)
      ..scaleByDouble(3.3, 3.3, 1, 1);
    await tester.pump();

    await doubleTap(tester, const Offset(400, 300));

    expect(zoom.transformation.value, Matrix4.identity());
  });

  testWidgets('a double tap zooms in on the tapped point', (tester) async {
    await pump(tester);

    await doubleTap(tester, const Offset(300, 200));

    expect(zoom.scale, closeTo(2.5, 0.001));
    expect(under(const Offset(300, 200)).dx, closeTo(300, 1));
    expect(under(const Offset(300, 200)).dy, closeTo(200, 1));
  });

  testWidgets('a double tap near an edge is clamped to the image', (
    tester,
  ) async {
    await pump(tester);

    await doubleTap(tester, const Offset(40, 120));

    expect(zoom.scale, closeTo(2.5, 0.001));
    expect(under(const Offset(40, 120)).dx, closeTo(40, 1));
    expect(
      zoom.transformation.value.getTranslation().y,
      closeTo(-100 * 2.5, 0.01),
    );
  });

  testWidgets('a double tap on the letterbox zooms the image centre', (
    tester,
  ) async {
    await pump(tester);

    await doubleTap(tester, const Offset(300, 40));

    expect(zoom.scale, closeTo(2.5, 0.001));
    expect(under(const Offset(400, 300)).dx, closeTo(400, 1));
    expect(under(const Offset(400, 300)).dy, closeTo(300, 1));
  });

  testWidgets('a second double tap returns to the fitted image', (
    tester,
  ) async {
    await pump(tester);
    await doubleTap(tester, const Offset(300, 200));
    expect(zoom.isZoomed, isTrue);

    await doubleTap(tester, const Offset(500, 400));

    expect(zoom.transformation.value, Matrix4.identity());
  });

  testWidgets('a double tap fills the screen when the step would not', (
    tester,
  ) async {
    await pump(tester, content: const Size(4000, 800));

    await doubleTap(tester, const Offset(400, 300));

    expect(zoom.scale, closeTo(3.75, 0.001));
  });

  late PageController pages;

  Future<void> pumpPages(
    WidgetTester tester, {
    Size content = const Size(1600, 800),
  }) async {
    zoom = ZoomController();
    addTearDown(zoom.dispose);
    pages = PageController(initialPage: 1);
    addTearDown(pages.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: PageView(
          controller: pages,
          children: [
            const Text('before'),
            Zoomable(
              controller: zoom,
              content: content,
              child: Container(color: Colors.red),
            ),
            const Text('after'),
          ],
        ),
      ),
    );
  }

  Future<TestGesture> swipe(WidgetTester tester, List<Offset> moves) async {
    final TestGesture finger = await tester.startGesture(
      const Offset(400, 300),
    );
    for (final Offset move in moves) {
      final int steps = (move.distance / 5).ceil();
      for (int step = 0; step < steps; step++) {
        await finger.moveBy(move / steps.toDouble());
        await tester.pump(const Duration(milliseconds: 16));
      }
    }
    return finger;
  }

  Future<void> zoomTo(WidgetTester tester, double shiftX) async {
    zoom.transformation.value = Matrix4.identity()
      ..translateByDouble(shiftX, 0, 0, 1)
      ..scaleByDouble(2, 2, 1, 1);
    await tester.pump();
  }

  double shiftX() => zoom.transformation.value.getTranslation().x;

  testWidgets(
    'a zoomed image at its edge hands an outward swipe to the pages',
    (tester) async {
      await pumpPages(tester);
      await zoomTo(tester, -800);

      final TestGesture finger = await swipe(tester, [const Offset(-500, 0)]);
      expect(pages.page, greaterThan(1.5));
      expect(shiftX(), -800);
      await finger.up();
      await tester.pumpAndSettle();

      expect(pages.page, 2);
    },
  );

  testWidgets(
    'a swipe that starts inward stays on the image after a reversal',
    (tester) async {
      await pumpPages(tester);
      await zoomTo(tester, -800);

      final TestGesture finger = await swipe(tester, [
        const Offset(100, 0),
        const Offset(-400, 0),
      ]);
      expect(pages.page, 1);
      expect(shiftX(), -800);
      await finger.up();
      await tester.pumpAndSettle();

      expect(pages.page, 1);
    },
  );

  testWidgets('a zoomed image away from its edges keeps every swipe', (
    tester,
  ) async {
    await pumpPages(tester);
    await zoomTo(tester, -400);

    final TestGesture finger = await swipe(tester, [const Offset(-300, 0)]);
    expect(pages.page, 1);
    expect(shiftX(), lessThan(-600));
    await finger.up();
    await tester.pumpAndSettle();

    expect(pages.page, 1);
  });

  testWidgets('a mostly vertical move at the edge stays on the image', (
    tester,
  ) async {
    await pumpPages(tester);
    await zoomTo(tester, -800);

    final TestGesture finger = await swipe(tester, [const Offset(-60, -200)]);
    expect(pages.page, 1);
    await finger.up();
    await tester.pumpAndSettle();

    expect(pages.page, 1);
  });

  testWidgets('a zoomed image stops at its own edges', (tester) async {
    await pump(tester);
    zoom.transformation.value = Matrix4.identity()
      ..translateByDouble(-400, -300, 0, 1)
      ..scaleByDouble(2, 2, 1, 1);
    await tester.pump();

    await tester.drag(find.byType(Zoomable), const Offset(0, 300));
    await tester.pumpAndSettle();
    expect(zoom.transformation.value.getTranslation().y, -200);

    await tester.drag(find.byType(Zoomable), const Offset(0, -600));
    await tester.pumpAndSettle();
    expect(zoom.transformation.value.getTranslation().y, -400);
  });

  testWidgets('an image narrower than the screen stays centred', (
    tester,
  ) async {
    await pump(tester, content: const Size(800, 1600));
    zoom.transformation.value = Matrix4.identity()
      ..translateByDouble(0, -150, 0, 1)
      ..scaleByDouble(1.5, 1.5, 1, 1);
    await tester.pump();

    await tester.drag(find.byType(Zoomable), const Offset(-200, -100));
    await tester.pumpAndSettle();

    expect(zoom.transformation.value.getTranslation().x, closeTo(-200, 0.01));
    expect(zoom.transformation.value.getTranslation().y, lessThan(-150));
  });

  testWidgets('a second finger settles the pull instead of releasing it', (
    tester,
  ) async {
    int cancelled = 0;
    zoom = ZoomController();
    addTearDown(zoom.dispose);
    spare = [];
    ended = null;
    await tester.pumpWidget(
      MaterialApp(
        home: Zoomable(
          controller: zoom,
          content: const Size(1600, 800),
          onSpare: spare.add,
          onSpareEnd: (velocity) => ended = velocity,
          onSpareCancel: () => cancelled++,
          child: Container(color: Colors.red),
        ),
      ),
    );

    final TestGesture first = await dragSlowly(
      tester,
      const Offset(400, 300),
      const Offset(0, 15),
      steps: 10,
      pace: const Duration(milliseconds: 16),
    );
    expect(vertical(), greaterThan(100));
    final TestGesture second = await tester.startGesture(
      const Offset(300, 300),
    );
    await tester.pump();

    expect(cancelled, 1);
    expect(ended, isNull);
    await first.up();
    await second.up();
    await tester.pumpAndSettle();
  });

  Future<void> pinch(
    WidgetTester tester,
    double from,
    double to, {
    Offset centre = const Offset(400, 300),
  }) async {
    final TestGesture left = await tester.startGesture(
      centre - Offset(from / 2, 0),
    );
    final TestGesture right = await tester.startGesture(
      centre + Offset(from / 2, 0),
    );
    for (int step = 1; step <= 10; step++) {
      final double gap = from + (to - from) * step / 10;
      await left.moveTo(centre - Offset(gap / 2, 0));
      await right.moveTo(centre + Offset(gap / 2, 0));
      await tester.pump(const Duration(milliseconds: 16));
    }
    await left.up();
    await right.up();
    await tester.pumpAndSettle();
  }

  testWidgets('a pinch from rest zooms around the fingers', (tester) async {
    await pump(tester);

    await pinch(tester, 200, 400, centre: const Offset(300, 300));

    expect(zoom.scale, greaterThan(1.5));
    expect(under(const Offset(300, 300)).dx, closeTo(300, 10));
    expect(under(const Offset(300, 300)).dy, closeTo(300, 10));
  });

  testWidgets('a pinch back in returns the image to its fitted place', (
    tester,
  ) async {
    await pump(tester);
    await pinch(tester, 200, 400);
    expect(zoom.isZoomed, isTrue);

    await pinch(tester, 400, 200);

    expect(zoom.scale, closeTo(1, 0.01));
    expect(zoom.transformation.value.getTranslation().x, closeTo(0, 0.01));
    expect(zoom.transformation.value.getTranslation().y, closeTo(0, 0.01));
  });

  testWidgets('a pinch on a letterboxed image is not pushed to cover it', (
    tester,
  ) async {
    await pump(tester, content: const Size(800, 1600));

    await pinch(tester, 200, 260);

    expect(zoom.scale, inExclusiveRange(1.05, 1.4));
  });
  Future<(TestGesture, TestGesture)> squeeze(
    WidgetTester tester, {
    required Offset left,
    required Offset right,
    Offset moveLeft = Offset.zero,
    Offset moveRight = Offset.zero,
  }) async {
    final TestGesture first = await tester.startGesture(left);
    final TestGesture second = await tester.startGesture(right);
    const int steps = 40;
    const Duration pace = Duration(milliseconds: 16);
    Duration at = Duration.zero;
    for (int step = 0; step < steps; step++) {
      at += pace;
      await first.moveBy(moveLeft / steps.toDouble(), timeStamp: at);
      await second.moveBy(moveRight / steps.toDouble(), timeStamp: at);
      await tester.pump(pace);
    }
    return (first, second);
  }

  testWidgets('every swipe at rest moves the pages', (tester) async {
    await pumpPages(tester);

    final TestGesture short = await swipe(tester, [const Offset(-200, 0)]);
    expect(pages.page, greaterThan(1.1));
    await short.up();
    await tester.pumpAndSettle();
    expect(pages.page, 1);

    final TestGesture finger = await swipe(tester, [const Offset(-500, 0)]);
    expect(pages.page, greaterThan(1.5));
    await finger.up();
    await tester.pumpAndSettle();

    expect(pages.page, 2);
  });

  testWidgets('a pinch at rest beside the screen edge zooms the image', (
    tester,
  ) async {
    await pumpPages(tester);

    final (TestGesture still, TestGesture moving) = await squeeze(
      tester,
      left: const Offset(780, 300),
      right: const Offset(500, 300),
      moveRight: const Offset(-200, 0),
    );

    expect(pages.page, 1);
    expect(zoom.scale, closeTo(480 / 280, 0.05));
    await still.up();
    await moving.up();
    await tester.pumpAndSettle();
  });

  testWidgets('a pinch on a zoomed image at its edge zooms the image', (
    tester,
  ) async {
    await pumpPages(tester);
    await zoomTo(tester, -800);

    final (TestGesture left, TestGesture right) = await squeeze(
      tester,
      left: const Offset(300, 300),
      right: const Offset(500, 300),
      moveLeft: const Offset(-100, 0),
      moveRight: const Offset(100, 0),
    );

    expect(pages.page, 1);
    expect(zoom.scale, closeTo(4, 0.1));
    await left.up();
    await right.up();
    await tester.pumpAndSettle();
  });

  testWidgets(
    'a wobbly double tap after a pan returns a zoomed image to rest',
    (tester) async {
      await pumpPages(tester);
      await zoomTo(tester, -400);
      final TestGesture pan = await swipe(tester, [const Offset(-100, 0)]);
      await pan.up();
      await tester.pumpAndSettle();
      expect(shiftX(), lessThan(-450));

      for (int tap = 0; tap < 2; tap++) {
        final TestGesture finger = await tester.startGesture(
          const Offset(400, 300),
        );
        await finger.moveBy(const Offset(8, 0));
        await finger.up();
        await tester.pump(const Duration(milliseconds: 50));
      }
      await tester.pumpAndSettle();

      expect(zoom.transformation.value, Matrix4.identity());
    },
  );

  testWidgets('a flung zoomed image drifts past where the finger let go', (
    tester,
  ) async {
    await pump(tester);
    zoom.transformation.value = Matrix4.identity()
      ..translateByDouble(-400, -300, 0, 1)
      ..scaleByDouble(2, 2, 1, 1);
    await tester.pump();

    await tester.fling(find.byType(Zoomable), const Offset(100, 0), 1000);
    await tester.pumpAndSettle();

    expect(shiftX(), greaterThan(-250));
  });

  testWidgets('a quick pinch keeps zooming after the fingers lift', (
    tester,
  ) async {
    await pump(tester);

    final (TestGesture left, TestGesture right) = await squeeze(
      tester,
      left: const Offset(300, 300),
      right: const Offset(500, 300),
      moveLeft: const Offset(-200, 0),
      moveRight: const Offset(200, 0),
    );
    final double lifted = zoom.scale;
    await left.up();
    await right.up();
    await tester.pumpAndSettle();

    expect(zoom.scale, greaterThan(lifted + 0.01));
  });

  testWidgets('a trackpad scroll pans a zoomed image', (tester) async {
    await pump(tester);
    zoom.transformation.value = Matrix4.identity()
      ..translateByDouble(-400, -300, 0, 1)
      ..scaleByDouble(2, 2, 1, 1);
    await tester.pump();

    final TestPointer trackpad = TestPointer(1, PointerDeviceKind.trackpad);
    trackpad.hover(const Offset(400, 300));
    await tester.sendEventToBinding(trackpad.scroll(const Offset(30, 50)));
    await tester.pump();

    expect(zoom.scale, 2);
    expect(shiftX(), closeTo(-430, 0.01));
    expect(zoom.transformation.value.getTranslation().y, closeTo(-350, 0.01));
  });
  testWidgets('a zoomed image narrower than the screen hands sideways swipes '
      'to the pages', (tester) async {
    await pumpPages(tester, content: const Size(800, 1600));
    zoom.transformation.value = Matrix4.identity()
      ..translateByDouble(-200, -150, 0, 1)
      ..scaleByDouble(1.5, 1.5, 1, 1);
    await tester.pump();

    final TestGesture finger = await swipe(tester, [const Offset(-500, 0)]);
    expect(pages.page, greaterThan(1.5));
    await finger.up();
    await tester.pumpAndSettle();

    expect(pages.page, 2);
  });

  testWidgets('a pinch stops at the deepest zoom', (tester) async {
    await pump(tester);

    final (TestGesture left, TestGesture right) = await squeeze(
      tester,
      left: const Offset(375, 300),
      right: const Offset(425, 300),
      moveLeft: const Offset(-375, 0),
      moveRight: const Offset(375, 0),
    );

    expect(zoom.scale, closeTo(1.5 * 6, 0.001));
    await left.up();
    await right.up();
    await tester.pumpAndSettle();
  });

  testWidgets('a pinch in at rest keeps the image at its fitted size', (
    tester,
  ) async {
    await pump(tester);

    final (TestGesture left, TestGesture right) = await squeeze(
      tester,
      left: const Offset(200, 300),
      right: const Offset(600, 300),
      moveLeft: const Offset(150, 0),
      moveRight: const Offset(-150, 0),
    );

    expect(zoom.scale, 1);
    await left.up();
    await right.up();
    await tester.pumpAndSettle();
  });

  testWidgets('a trackpad pinch inside the pages zooms the image', (
    tester,
  ) async {
    await pumpPages(tester);

    final TestGesture trackpad = await tester.createGesture(
      kind: PointerDeviceKind.trackpad,
    );
    await trackpad.panZoomStart(const Offset(400, 300));
    for (int step = 1; step <= 10; step++) {
      await trackpad.panZoomUpdate(
        const Offset(400, 300),
        scale: 1 + step / 10,
      );
      await tester.pump(const Duration(milliseconds: 16));
    }

    expect(pages.page, 1);
    expect(zoom.scale, greaterThan(1.5));
    await trackpad.panZoomEnd();
    await tester.pumpAndSettle();
  });
}
