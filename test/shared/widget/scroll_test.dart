import 'package:e1547/shared/shared.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> show(WidgetTester tester) => tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 300,
            height: 100,
            child: ScrollEdgeFade(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 8,
                itemBuilder: (context, index) =>
                    SizedBox.square(dimension: 100, child: Text('$index')),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  testWidgets('scrolling hands the mask a new shader', (tester) async {
    await show(tester);
    await tester.pump();
    final before = tester.widget<ShaderMask>(find.byType(ShaderMask));

    // Past kTouchSlop, so that the row scrolls into the ramp.
    await tester.drag(find.text('1'), const Offset(-(kTouchSlop + 12), 0));
    await tester.pump();
    final after = tester.widget<ShaderMask>(find.byType(ShaderMask));

    // Equality, not identity: a tear-off yields a fresh object that still
    // compares equal, which is exactly what stops the mask from repainting.
    expect(after.shaderCallback, isNot(equals(before.shaderCallback)));
  });

  testWidgets('the child stops short of the masked bounds', (tester) async {
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.resetDevicePixelRatio);

    await show(tester);
    await tester.pump();

    final viewport = tester.getSize(find.byType(ListView)).width;

    expect(viewport, 300 - 2 * (1 / 2.625));
  });
}
