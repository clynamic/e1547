import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/gestures.dart';

void main() {
  WidgetBuilder probe(
    void Function(DismissController) found,
  ) => (BuildContext context) {
    final DismissController controller = DismissController.maybeOf(context)!;
    found(controller);
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) =>
          Scaffold(body: Center(child: Text('${controller.offset.round()}'))),
    );
  };

  Future<NavigatorState> pumpBase(
    WidgetTester tester, {
    void Function(DismissController)? found,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        onGenerateRoute: (settings) => DismissRoute<void>(
          builder: probe(found ?? (e) {}),
          settings: settings,
        ),
      ),
    );
    await tester.pumpAndSettle();
    return tester.state(find.byType(Navigator));
  }

  Widget list() => ListView.builder(
    itemCount: 50,
    itemBuilder: (context, index) => const SizedBox(height: 100),
  );

  testWidgets('a drag on the only route moves nothing', (tester) async {
    late DismissController only;
    await pumpBase(tester, found: (e) => only = e);

    only.push(200);
    await tester.pump();

    expect(only.offset, 0);
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('drags once a route is beneath', (tester) async {
    late DismissController bottom;
    late DismissController top;
    final NavigatorState navigator = await pumpBase(
      tester,
      found: (e) => bottom = e,
    );
    navigator.push(DismissRoute<void>(builder: probe((e) => top = e)));
    await tester.pumpAndSettle();

    expect(bottom.route.dismissible, isFalse);

    top.push(200);
    await tester.pump();

    expect(top.offset, closeTo(200, 0.001));
    expect(top.exceeds(0), isTrue);
  });

  testWidgets('settles a drag that was never released', (tester) async {
    late DismissController top;
    final NavigatorState navigator = await pumpBase(tester);
    navigator.push(DismissRoute<void>(builder: probe((e) => top = e)));
    await tester.pumpAndSettle();

    top.push(60);
    await tester.pump();
    expect(top.isDragging, isTrue);

    top.settle();
    await tester.pumpAndSettle();

    expect(top.isDragging, isFalse);
    expect(top.offset, 0);
    expect(top.route.dragging, isFalse);
  });

  testWidgets('a drag after a stale one sets its own direction', (
    tester,
  ) async {
    late DismissController top;
    final NavigatorState navigator = await pumpBase(tester);
    navigator.push(DismissRoute<void>(builder: probe((e) => top = e)));
    await tester.pumpAndSettle();

    top.push(60);
    await tester.pump();
    top.route.drag.value = 0;
    await tester.pump();

    top.push(-40);
    await tester.pump();

    expect(top.route.direction, -1);
    expect(top.offset, closeTo(-40, 0.001));
  });

  testWidgets('a release followed by a fling pops one route', (tester) async {
    final NavigatorState navigator = await pumpBase(tester);
    final DismissRoute<void> middle = DismissRoute<void>(
      builder: probe((e) {}),
    );
    navigator.push(middle);
    await tester.pumpAndSettle();
    navigator.push(
      DismissRoute<void>(builder: (context) => ScrollToDismiss(child: list())),
    );
    await tester.pumpAndSettle();

    final TestGesture finger = await tester.startGesture(
      const Offset(400, 200),
    );
    Duration at = Duration.zero;
    for (int step = 0; step < 10; step++) {
      at += const Duration(milliseconds: 16);
      await finger.moveBy(const Offset(0, 30), timeStamp: at);
      await tester.pump(const Duration(milliseconds: 16));
    }
    for (int step = 0; step < 3; step++) {
      at += const Duration(milliseconds: 16);
      await finger.moveBy(const Offset(0, -1), timeStamp: at);
      await tester.pump(const Duration(milliseconds: 16));
    }
    await finger.up(timeStamp: at);
    await tester.pumpAndSettle();

    expect(middle.isCurrent, isTrue);
  });

  testWidgets('a drag back up undoes the pull', (tester) async {
    late DismissController top;
    final NavigatorState navigator = await pumpBase(tester);
    navigator.push(
      DismissRoute<void>(
        builder: (context) {
          top = DismissController.maybeOf(context)!;
          return ScrollToDismiss(child: list());
        },
      ),
    );
    await tester.pumpAndSettle();

    final TestGesture finger = await tester.startGesture(
      const Offset(400, 200),
    );
    for (int step = 0; step < 10; step++) {
      await finger.moveBy(const Offset(0, 30));
      await tester.pump();
    }
    final double pulled = top.offset;
    for (int step = 0; step < 3; step++) {
      await finger.moveBy(const Offset(0, -20));
      await tester.pump();
    }

    expect(top.offset, closeTo(pulled - 60, 0.001));
  }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

  testWidgets('a short pull leaves the route in place', (tester) async {
    final NavigatorState navigator = await pumpBase(tester);
    final DismissRoute<void> top = DismissRoute<void>(
      builder: (context) => ScrollToDismiss(child: list()),
    );
    navigator.push(top);
    await tester.pumpAndSettle();

    final TestGesture finger = await tester.startGesture(
      const Offset(400, 200),
    );
    Duration at = Duration.zero;
    for (int step = 0; step < 8; step++) {
      at += const Duration(milliseconds: 100);
      await finger.moveBy(const Offset(0, 10), timeStamp: at);
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(top.dragOffset, greaterThan(0));
    await finger.up(timeStamp: at);
    await tester.pumpAndSettle();

    expect(top.isCurrent, isTrue);
    expect(top.dragOffset, 0);
  });

  testWidgets('a drag that starts below the top stops there and stays', (
    tester,
  ) async {
    final NavigatorState navigator = await pumpBase(tester);
    final DismissRoute<void> top = DismissRoute<void>(
      builder: (context) => ScrollToDismiss(child: list()),
    );
    navigator.push(top);
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();

    final TestGesture finger = await tester.startGesture(
      const Offset(400, 200),
    );
    Duration at = Duration.zero;
    for (int step = 0; step < 12; step++) {
      at += const Duration(milliseconds: 16);
      await finger.moveBy(const Offset(0, 60), timeStamp: at);
      await tester.pump(const Duration(milliseconds: 16));
    }

    expect(top.dragOffset, 0);
    await finger.up(timeStamp: at);
    await tester.pumpAndSettle();

    expect(top.isCurrent, isTrue);
  });

  testWidgets('a vertical drag past the threshold pops the route', (
    tester,
  ) async {
    final NavigatorState navigator = await pumpBase(tester);
    final DismissRoute<void> top = DismissRoute<void>(
      builder: (context) =>
          const DragToDismiss(child: ColoredBox(color: Colors.black)),
    );
    navigator.push(top);
    await tester.pumpAndSettle();

    await tester.timedDrag(
      find.byType(DragToDismiss),
      const Offset(0, 200),
      const Duration(seconds: 2),
    );
    await tester.pumpAndSettle();

    expect(top.isActive, isFalse);
  });

  testWidgets('a vertical drag beside a small child still pops the route', (
    tester,
  ) async {
    final NavigatorState navigator = await pumpBase(tester);
    final DismissRoute<void> top = DismissRoute<void>(
      builder: (context) => const DragToDismiss(
        child: Center(child: SizedBox.square(dimension: 10)),
      ),
    );
    navigator.push(top);
    await tester.pumpAndSettle();

    await tester.timedDragFrom(
      const Offset(100, 100),
      const Offset(0, 200),
      const Duration(seconds: 2),
    );
    await tester.pumpAndSettle();

    expect(top.isActive, isFalse);
  });

  Future<TestGesture> pull(WidgetTester tester, Finder target) =>
      dragSlowly(tester, tester.getCenter(target), const Offset(0, 10));

  Future<void> back(WidgetTester tester, String method) =>
      tester.binding.defaultBinaryMessenger.handlePlatformMessage(
        'flutter/backgesture',
        const StandardMethodCodec().encodeMethodCall(
          MethodCall(
            method,
            method == 'commitBackGesture'
                ? null
                : <String, Object?>{
                    'touchOffset': <double>[5, 300],
                    'progress': 0.0,
                    'swipeEdge': 0,
                  },
          ),
        ),
        (ByteData? _) {},
      );

  testWidgets('a release while settling keeps the route', (tester) async {
    late DismissController top;
    final NavigatorState navigator = await pumpBase(tester);
    navigator.push(DismissRoute<void>(builder: probe((e) => top = e)));
    await tester.pumpAndSettle();

    top.push(200);
    await tester.pump();
    expect(top.exceeds(0), isTrue);
    top.settle();

    expect(top.release(0), isFalse);
  });

  testWidgets('a vertical drag the system cancels settles back', (
    tester,
  ) async {
    final NavigatorState navigator = await pumpBase(tester);
    final DismissRoute<void> top = DismissRoute<void>(
      builder: (context) =>
          const DragToDismiss(child: ColoredBox(color: Colors.black)),
    );
    navigator.push(top);
    await tester.pumpAndSettle();

    final TestGesture finger = await pull(tester, find.byType(DragToDismiss));
    expect(top.dragOffset, greaterThan(120));
    await finger.cancel();
    await tester.pumpAndSettle();

    expect(top.isCurrent, isTrue);
    expect(top.dragOffset, 0);
  });

  testWidgets('a pull the system cancels settles back', (tester) async {
    final NavigatorState navigator = await pumpBase(tester);
    final DismissRoute<void> top = DismissRoute<void>(
      builder: (context) => ScrollToDismiss(child: list()),
    );
    navigator.push(top);
    await tester.pumpAndSettle();

    final TestGesture finger = await pull(tester, find.byType(ScrollToDismiss));
    expect(top.dragOffset, greaterThan(120));
    await finger.cancel();
    await tester.pumpAndSettle();

    expect(top.isCurrent, isTrue);
    expect(top.dragOffset, 0);
  });

  testWidgets('a back gesture that takes over a drag pops one route', (
    tester,
  ) async {
    final NavigatorState navigator = await pumpBase(tester);
    final DismissRoute<void> middle = DismissRoute<void>(
      builder: probe((e) {}),
    );
    navigator.push(middle);
    await tester.pumpAndSettle();
    final DismissRoute<void> top = DismissRoute<void>(
      builder: (context) =>
          const DragToDismiss(child: ColoredBox(color: Colors.black)),
    );
    navigator.push(top);
    await tester.pumpAndSettle();

    final TestGesture finger = await pull(tester, find.byType(DragToDismiss));
    await back(tester, 'startBackGesture');
    await finger.cancel();
    await back(tester, 'commitBackGesture');
    await tester.pumpAndSettle();

    expect(top.isActive, isFalse);
    expect(middle.isCurrent, isTrue);
  });

  Future<DismissRoute<void>> swipeUpFrom(WidgetTester tester, double y) async {
    reserveBottomGestureArea(tester);
    final NavigatorState navigator = await pumpBase(tester);
    final DismissRoute<void> top = DismissRoute<void>(
      builder: (context) =>
          const DragToDismiss(child: ColoredBox(color: Colors.black)),
    );
    navigator.push(top);
    await tester.pumpAndSettle();

    final TestGesture finger = await dragSlowly(
      tester,
      Offset(400, y),
      const Offset(0, -10),
    );
    await finger.up();
    await tester.pumpAndSettle();
    return top;
  }

  testWidgets('a swipe from the system gesture area leaves the route alone', (
    tester,
  ) async {
    final DismissRoute<void> top = await swipeUpFrom(tester, 590);

    expect(top.isCurrent, isTrue);
  });

  testWidgets('a swipe from above the system gesture area pops the route', (
    tester,
  ) async {
    final DismissRoute<void> top = await swipeUpFrom(tester, 500);

    expect(top.isActive, isFalse);
  });

  testWidgets('a drop short of the threshold eases back', (tester) async {
    late DismissController top;
    final NavigatorState navigator = await pumpBase(tester);
    navigator.push(DismissRoute<void>(builder: probe((e) => top = e)));
    await tester.pumpAndSettle();

    top.push(100);
    await tester.pump();
    expect(top.release(0), isFalse);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 40));
    expect(top.offset, greaterThan(50));

    await tester.pumpAndSettle();
    expect(top.offset, 0);
    expect(top.route.isCurrent, isTrue);
  });

  testWidgets('a flick past the threshold keeps its speed', (tester) async {
    Future<double> travelled(double velocity) async {
      late DismissController top;
      final NavigatorState navigator = await pumpBase(tester);
      navigator.push(DismissRoute<void>(builder: probe((e) => top = e)));
      await tester.pumpAndSettle();
      top.push(200);
      await tester.pump();
      expect(top.release(velocity), isTrue);
      navigator.pop();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      final double offset = top.offset;
      await tester.pumpAndSettle();
      return offset;
    }

    final double dropped = await travelled(0);
    final double flicked = await travelled(3000);

    expect(flicked, greaterThan(dropped + 50));
  });

  testWidgets('a cancel after the pop keeps the page flying out', (
    tester,
  ) async {
    late DismissController top;
    final NavigatorState navigator = await pumpBase(tester);
    navigator.push(DismissRoute<void>(builder: probe((e) => top = e)));
    await tester.pumpAndSettle();

    top.push(200);
    await tester.pump();
    expect(top.release(0), isTrue);
    navigator.pop();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    final double flying = top.offset;
    expect(flying, greaterThan(200));
    top.settle();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(top.offset, greaterThanOrEqualTo(flying));
    await tester.pumpAndSettle();
    expect(top.route.isActive, isFalse);
    expect(navigator.canPop(), isFalse);
  });

  testWidgets('a drag during the opening transition moves nothing', (
    tester,
  ) async {
    late DismissController top;
    final NavigatorState navigator = await pumpBase(tester);
    navigator.push(DismissRoute<void>(builder: probe((e) => top = e)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    top.push(50);
    expect(top.offset, 0);

    await tester.pumpAndSettle();
    top.push(50);
    expect(top.offset, 50);
  });

  testWidgets('a flick short of the threshold pops the route', (tester) async {
    final NavigatorState navigator = await pumpBase(tester);
    final DismissRoute<void> top = DismissRoute<void>(
      builder: (context) => ScrollToDismiss(child: list()),
    );
    navigator.push(top);
    await tester.pumpAndSettle();

    final TestGesture finger = await dragSlowly(
      tester,
      const Offset(400, 200),
      const Offset(0, 15),
      steps: 6,
      pace: const Duration(milliseconds: 16),
    );
    await finger.up();
    await tester.pumpAndSettle();

    expect(top.isActive, isFalse);
  }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

  testWidgets('a pull shows the route beneath', (tester) async {
    late DismissController top;
    final NavigatorState navigator = await pumpBase(tester);
    navigator.push(
      DismissRoute<void>(builder: (context) => const Text('middle')),
    );
    await tester.pumpAndSettle();
    navigator.push(DismissRoute<void>(builder: probe((e) => top = e)));
    await tester.pumpAndSettle();
    expect(find.text('middle'), findsNothing);

    top.push(60);
    await tester.pump();
    expect(find.text('middle'), findsOneWidget);

    top.settle();
    await tester.pumpAndSettle();
    expect(find.text('middle'), findsNothing);
  });
}
