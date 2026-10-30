import 'package:e1547/shared/shared.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('a value changing faster than the pause arrives once it pauses', (
    tester,
  ) async {
    final List<String> seen = [];
    Widget debounced(String value) => Directionality(
      textDirection: TextDirection.ltr,
      child: Debounced<String>(
        value: value,
        builder: (context, value) {
          seen.add(value);
          return Text(value);
        },
      ),
    );

    await tester.pumpWidget(debounced('a'));
    for (final String value in ['ab', 'abc']) {
      await tester.pump(typingPause ~/ 2);
      await tester.pumpWidget(debounced(value));
    }
    await tester.pump(typingPause ~/ 2);
    expect(find.text('a'), findsOneWidget);

    await tester.pump(typingPause ~/ 2);

    expect(find.text('abc'), findsOneWidget);
    expect(seen.toSet(), {'a', 'abc'});
  });
}
