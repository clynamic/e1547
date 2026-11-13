import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('holding a card with no hold action reaches what is around it', (
    tester,
  ) async {
    int taps = 0;
    int holds = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GestureDetector(
            onLongPress: () => holds++,
            child: ColoredCard(onTap: () => taps++, child: const Text('tag')),
          ),
        ),
      ),
    );

    await tester.longPress(find.text('tag'));
    await tester.pump(const Duration(milliseconds: 200));

    expect(holds, 1);
    expect(taps, 0);
  });
}
