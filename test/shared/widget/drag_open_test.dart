import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpDock(WidgetTester tester) => tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Align(
          alignment: Alignment.bottomCenter,
          child: Builder(
            builder: (context) => DragToOpen(
              open: (transition) => showModalBottomSheet<void>(
                context: context,
                transitionAnimationController: transition,
                builder: (context) =>
                    const SizedBox(height: 300, child: Text('sheet')),
              ),
              child: const SizedBox(height: 72, child: Text('dock')),
            ),
          ),
        ),
      ),
    ),
  );

  testWidgets('dragging the dock up opens the sheet', (tester) async {
    await pumpDock(tester);

    await tester.drag(find.text('dock'), const Offset(0, -300));
    await tester.pumpAndSettle();

    expect(find.text('sheet'), findsOneWidget);
  });

  testWidgets('a dragged-open sheet closes and leaves nothing behind', (
    tester,
  ) async {
    await pumpDock(tester);
    await tester.drag(find.text('dock'), const Offset(0, -300));
    await tester.pumpAndSettle();

    await tester.tapAt(const Offset(20, 20));
    await tester.pumpAndSettle();

    expect(find.text('sheet'), findsNothing);
    expect(find.byType(BottomSheet), findsNothing);
  });

  testWidgets('the dock lifts while it is dragged up', (tester) async {
    await pumpDock(tester);
    final double resting = tester.getTopLeft(find.text('dock')).dy;
    final TestGesture gesture = await tester.startGesture(
      tester.getCenter(find.text('dock')),
    );
    await gesture.moveBy(const Offset(0, -30));
    await gesture.moveBy(const Offset(0, -30));
    await tester.pump();

    expect(tester.getTopLeft(find.text('dock')).dy, lessThan(resting));
    expect(find.text('sheet'), findsNothing);
    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('a short slow drag opens nothing', (tester) async {
    await pumpDock(tester);
    final TestGesture gesture = await tester.startGesture(
      tester.getCenter(find.text('dock')),
    );
    await gesture.moveBy(const Offset(0, -30));
    await gesture.moveBy(const Offset(0, -20));
    await tester.pump(const Duration(milliseconds: 500));
    await gesture.up();
    await tester.pumpAndSettle();

    expect(find.text('sheet'), findsNothing);
  });

  testWidgets('a drag down on the dock opens nothing', (tester) async {
    await pumpDock(tester);

    await tester.drag(find.text('dock'), const Offset(0, 200));
    await tester.pumpAndSettle();

    expect(find.text('sheet'), findsNothing);
  });
}
