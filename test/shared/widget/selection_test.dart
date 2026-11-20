import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

typedef Item = ({int id, int version});

void main() {
  late SelectionLayoutData<Item> selection;

  Widget layout(List<Item> items) => MaterialApp(
    home: SelectionLayout<Item>(
      items: items,
      keyOf: (item) => item.id,
      child: Builder(
        builder: (context) {
          selection = SelectionLayout.of<Item>(context);
          return const SizedBox();
        },
      ),
    ),
  );

  testWidgets('keeps an item selected when its updated version replaces it', (
    tester,
  ) async {
    await tester.pumpWidget(layout([(id: 1, version: 1), (id: 2, version: 1)]));
    selection.select((id: 1, version: 1));
    await tester.pump();

    await tester.pumpWidget(layout([(id: 1, version: 2), (id: 2, version: 1)]));

    expect(selection.selections, {(id: 1, version: 2)});
  });

  testWidgets('keeps one selection for an item listed twice', (tester) async {
    await tester.pumpWidget(layout([(id: 1, version: 1)]));
    selection.select((id: 1, version: 1));
    await tester.pump();

    await tester.pumpWidget(
      layout([(id: 1, version: 2), (id: 2, version: 1), (id: 1, version: 3)]),
    );

    expect(selection.selections, {(id: 1, version: 2)});
  });
}
