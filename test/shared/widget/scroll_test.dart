import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> show(
    WidgetTester tester, {
    required int items,
    void Function(int index)? onTap,
  }) => tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 300,
            height: 100,
            child: ScrollEdgeFade(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: items,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => onTap?.call(index),
                  child: SizedBox.square(dimension: 100, child: Text('$index')),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  testWidgets('a row that fits renders every item', (tester) async {
    await show(tester, items: 2);
    await tester.pump();

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('the fade leaves the row scrollable', (tester) async {
    await show(tester, items: 8);
    await tester.pump();

    expect(find.text('7'), findsNothing);

    await tester.drag(find.text('1'), const Offset(-500, 0));
    await tester.pump();

    expect(find.text('7'), findsOneWidget);
  });

  testWidgets('scrolling hands the mask a new shader', (tester) async {
    await show(tester, items: 8);
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

    await show(tester, items: 8);
    await tester.pump();

    final viewport = tester.getSize(find.byType(ListView)).width;

    expect(viewport, 300 - 2 * (1 / 2.625));
  });

  testWidgets('the fade lets taps through', (tester) async {
    final tapped = <int>[];
    await show(tester, items: 8, onTap: tapped.add);
    await tester.pump();

    await tester.tap(find.text('0'));
    await tester.pump();

    expect(tapped, [0]);
  });
}
