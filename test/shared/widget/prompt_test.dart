import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> open(WidgetTester tester, {required bool pinned}) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => showSliverPrompt<void>(
              context,
              pinnedHeader: pinned,
              parentBuilder: (context, child) =>
                  Provider<String>.value(value: 'header', child: child),
              header: (context) =>
                  SizedBox(height: 60, child: Text(context.read<String>())),
              sliver: SliverList.builder(
                itemCount: 60,
                itemBuilder: (context, index) =>
                    SizedBox(height: 48, child: Text('line $index')),
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

  testWidgets('a prompt opens a sheet with its header above its content', (
    tester,
  ) async {
    await open(tester, pinned: false);

    expect(find.byType(SheetHandle), findsOneWidget);
    expect(
      tester.getBottomLeft(find.text('header')).dy,
      lessThanOrEqualTo(tester.getTopLeft(find.text('line 0')).dy),
    );
  });

  double sheetTop(WidgetTester tester) =>
      tester.getTopLeft(find.byType(SheetHandle)).dy;

  Future<void> expand(WidgetTester tester) async {
    await tester.drag(find.text('line 3'), Offset(0, -sheetTop(tester)));
    await tester.pumpAndSettle();
  }

  testWidgets(
    'a prompt sheet opens at 60% of the screen and a drag up opens it fully',
    (tester) async {
      await open(tester, pinned: true);
      final double screen = tester.getSize(find.byType(MaterialApp)).height;

      expect(sheetTop(tester), screen * 0.4);

      await expand(tester);

      expect(sheetTop(tester), 0);
      expect(find.text('line 0'), findsOneWidget);
    },
  );

  testWidgets('a pinned header stays while the content scrolls under it', (
    tester,
  ) async {
    await open(tester, pinned: true);
    await expand(tester);
    final double top = tester.getTopLeft(find.text('header')).dy;

    await tester.drag(find.text('line 3'), const Offset(0, -300));
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(find.text('header')).dy, top);
    expect(find.text('line 0'), findsNothing);
  });

  testWidgets('an unpinned header scrolls away with the content', (
    tester,
  ) async {
    await open(tester, pinned: false);
    await expand(tester);
    final double header = tester.getTopLeft(find.text('header')).dy;
    final double line = tester.getTopLeft(find.text('line 0')).dy;

    await tester.drag(find.text('line 3'), const Offset(0, -50));
    await tester.pumpAndSettle();

    final double moved = line - tester.getTopLeft(find.text('line 0')).dy;
    expect(moved, greaterThan(0));
    expect(header - tester.getTopLeft(find.text('header')).dy, moved);
  });
}
