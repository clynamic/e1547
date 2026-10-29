import 'package:e1547/shared/shared.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late SelectionLayoutData<int> data;

  Future<void> pumpGrid(WidgetTester tester, {List<int>? items}) =>
      tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectionLayout<int>(
              items: items ?? List.generate(6, (i) => i),
              child: Builder(
                builder: (context) {
                  data = SelectionLayout.of<int>(context);
                  return GridView.count(
                    crossAxisCount: 3,
                    children: [
                      for (final int item in data.items)
                        TileSelectionOverlay<int>(
                          item: item,
                          marker: const Icon(Icons.favorite),
                          child: Center(child: Text('tile $item')),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

  Finder badge(int item) => find.descendant(
    of: find.widgetWithText(TileSelectionOverlay<int>, 'tile $item'),
    matching: find.byIcon(Icons.check),
  );

  double shown(WidgetTester tester, int item) => tester
      .widget<AnimatedOpacity>(
        find.descendant(
          of: find.widgetWithText(TileSelectionOverlay<int>, 'tile $item'),
          matching: find.byType(AnimatedOpacity),
        ),
      )
      .opacity;

  testWidgets('a hold selects a tile and marks it', (tester) async {
    await pumpGrid(tester);

    await tester.longPress(find.text('tile 1'));
    await tester.pumpAndSettle();

    expect(data.selections, {1});
    expect(badge(1), findsOneWidget);
    expect(shown(tester, 1), 1);
    expect(shown(tester, 0), 0);
  });

  testWidgets('while selecting, a tap toggles a tile', (tester) async {
    await pumpGrid(tester);
    await tester.longPress(find.text('tile 1'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('tile 2'));
    await tester.pump();
    await tester.tap(find.text('tile 1'));
    await tester.pump();

    expect(data.selections, {2});
  });

  testWidgets('a hold dragged across tiles selects each tile it passes', (
    tester,
  ) async {
    await pumpGrid(tester);

    final TestGesture gesture = await tester.startGesture(
      tester.getCenter(find.text('tile 0')),
    );
    await tester.pump(kLongPressTimeout + const Duration(milliseconds: 50));
    await gesture.moveTo(tester.getCenter(find.text('tile 1')));
    await tester.pump();
    await gesture.moveTo(tester.getCenter(find.text('tile 4')));
    await tester.pump();
    await gesture.up();
    await tester.pump();

    expect(data.selections, {0, 1, 4});
  });

  testWidgets('a hold dragged from a selected tile deselects what it passes', (
    tester,
  ) async {
    await pumpGrid(tester);
    data.onChanged({0, 1, 2});
    await tester.pump();

    final TestGesture gesture = await tester.startGesture(
      tester.getCenter(find.text('tile 0')),
    );
    await tester.pump(kLongPressTimeout + const Duration(milliseconds: 50));
    await gesture.moveTo(tester.getCenter(find.text('tile 1')));
    await tester.pump();
    await gesture.up();
    await tester.pump();

    expect(data.selections, {2});
  });

  testWidgets('a keyed selection follows its items when they are replaced', (
    tester,
  ) async {
    final List<({int id, bool liked})> first = [
      (id: 1, liked: false),
      (id: 2, liked: false),
    ];
    late SelectionLayoutData<({int id, bool liked})> records;
    Widget layout(List<({int id, bool liked})> items) => MaterialApp(
      home: SelectionLayout<({int id, bool liked})>(
        items: items,
        keyOf: (item) => item.id,
        child: Builder(
          builder: (context) {
            records = SelectionLayout.of(context);
            return const SizedBox();
          },
        ),
      ),
    );
    await tester.pumpWidget(layout(first));
    records.onChanged({first[1]});
    await tester.pump();

    await tester.pumpWidget(
      layout([(id: 1, liked: false), (id: 2, liked: true)]),
    );

    expect(records.selections, {(id: 2, liked: true)});
  });
}
