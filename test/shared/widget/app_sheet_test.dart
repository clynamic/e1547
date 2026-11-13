import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

import '../../_support/gestures.dart';

void main() {
  Future<void> open(
    WidgetTester tester, {
    WidgetBuilder? builder,
    ThemeData? theme,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => showAppSheet<void>(
              context,
              builder:
                  builder ??
                  (context) => SizedBox(
                    height: 400,
                    child: ListView(
                      children: [
                        for (int i = 0; i < 40; i++)
                          SizedBox(height: 48, child: Text('line $i')),
                      ],
                    ),
                  ),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  double screenHeight(WidgetTester tester) =>
      tester.view.physicalSize.height / tester.view.devicePixelRatio;

  Future<void> dragDown(
    WidgetTester tester,
    String line,
    double distance,
  ) async {
    final TestGesture finger = await dragSlowly(
      tester,
      tester.getCenter(find.text(line)),
      const Offset(0, 10),
      steps: (distance / 10).ceil(),
      pace: const Duration(milliseconds: 16),
    );
    await finger.up();
    await tester.pumpAndSettle();
  }

  testWidgets('a long drag down from the top of its list closes the sheet', (
    tester,
  ) async {
    await open(tester);

    await dragDown(tester, 'line 2', 350);

    expect(find.text('line 2'), findsNothing);
  });

  testWidgets('a fling down from the top of its list closes the sheet', (
    tester,
  ) async {
    await open(tester);

    await tester.fling(find.text('line 2'), const Offset(0, 80), 900);
    await tester.pumpAndSettle();

    expect(find.text('line 2'), findsNothing);
  });

  testWidgets('a slow drag down past halfway closes the sheet while the '
      'finger still moves', (tester) async {
    await open(tester);

    await dragDown(tester, 'line 2', 260);

    expect(find.text('line 2'), findsNothing);
  });

  testWidgets('a slow drag down short of halfway springs the sheet back', (
    tester,
  ) async {
    await open(tester);
    final double top = tester.getTopLeft(find.text('line 0')).dy;

    await dragDown(tester, 'line 2', 170);

    expect(tester.getTopLeft(find.text('line 0')).dy, top);
  });

  testWidgets('a short drag down from the top springs the sheet back', (
    tester,
  ) async {
    await open(tester);
    final double top = tester.getTopLeft(find.text('line 0')).dy;

    await tester.timedDrag(
      find.text('line 2'),
      const Offset(0, 60),
      const Duration(milliseconds: 600),
    );
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(find.text('line 0')).dy, top);
  });

  testWidgets('a scrolled list scrolls back before the sheet moves', (
    tester,
  ) async {
    await open(tester);
    await tester.drag(find.text('line 4'), const Offset(0, -200));
    await tester.pumpAndSettle();
    final double before = tester.getTopLeft(find.text('line 8')).dy;

    await tester.timedDrag(
      find.text('line 8'),
      const Offset(0, 120),
      const Duration(milliseconds: 600),
    );
    await tester.pumpAndSettle();

    expect(
      tester.getTopLeft(find.text('line 8')).dy - before,
      greaterThan(100),
    );
  });

  testWidgets('a drag that starts below the top stops there, sheet open', (
    tester,
  ) async {
    await open(tester);
    final double top = tester.getTopLeft(find.text('line 0')).dy;
    await tester.drag(find.text('line 4'), const Offset(0, -200));
    await tester.pumpAndSettle();

    await tester.timedDrag(
      find.text('line 8'),
      const Offset(0, 500),
      const Duration(milliseconds: 600),
    );
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(find.text('line 0')).dy, top);
  });

  testWidgets('the sheet stays narrow and centred on a wide screen', (
    tester,
  ) async {
    tester.view.physicalSize = Size(
      1200 * tester.view.devicePixelRatio,
      800 * tester.view.devicePixelRatio,
    );
    addTearDown(tester.view.resetPhysicalSize);
    await open(
      tester,
      builder: (context) => const SizedBox(height: 100, child: Text('narrow')),
    );

    final Rect sheet = tester.getRect(find.byType(Sheet));
    expect(sheet.width, 600);
    expect(sheet.center.dx, 600);
  });

  testWidgets('an open keyboard lifts the sheet above it', (tester) async {
    tester.view.viewInsets = FakeViewPadding(
      bottom: 250 * tester.view.devicePixelRatio,
    );
    addTearDown(tester.view.resetViewInsets);
    await open(
      tester,
      builder: (context) =>
          const SizedBox(height: 100, child: Text('above the keys')),
    );

    expect(
      tester.getBottomLeft(find.text('above the keys')).dy,
      closeTo(screenHeight(tester) - 250, 1),
    );
  });

  testWidgets('a drag down puts the keyboard away so the sheet can close', (
    tester,
  ) async {
    tester.view.viewInsets = FakeViewPadding(
      bottom: 250 * tester.view.devicePixelRatio,
    );
    addTearDown(tester.view.resetViewInsets);
    await open(
      tester,
      builder: (context) => const SizedBox(
        height: 300,
        child: Column(children: [Text('typing'), TextField(autofocus: true)]),
      ),
    );
    bool typing() => find
        .byType(EditableText)
        .evaluate()
        .any((e) => (e.widget as EditableText).focusNode.hasFocus);
    expect(typing(), isTrue);

    await dragDown(tester, 'typing', 100);
    expect(typing(), isFalse);
    expect(find.text('typing'), findsOneWidget);

    tester.view.resetViewInsets();
    await tester.pumpAndSettle();
    await dragDown(tester, 'typing', 250);

    expect(find.text('typing'), findsNothing);
  });

  testWidgets('the sheet writes in the text style of the app theme', (
    tester,
  ) async {
    final ThemeData theme = ThemeData(brightness: Brightness.dark);
    await open(
      tester,
      theme: theme,
      builder: (context) => const Text('themed'),
    );

    final TextStyle style = tester
        .widget<RichText>(
          find.descendant(
            of: find.text('themed'),
            matching: find.byType(RichText),
          ),
        )
        .text
        .style!;
    expect(style.color, theme.textTheme.bodyMedium!.color);
    expect(style.fontFamily, theme.textTheme.bodyMedium!.fontFamily);
  });
}
