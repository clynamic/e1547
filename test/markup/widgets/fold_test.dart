import 'package:e1547/markup/markup.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  String describedIn(int lines) =>
      List.filled(lines, 'A line of the description.').join('\n');

  Future<void> show(WidgetTester tester, String text) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: DTextFold(text: text)),
        ),
      ),
    );
    await tester.pump();
  }

  double descriptionHeight(WidgetTester tester) =>
      tester.getSize(find.byType(HeightLimit)).height;

  testWidgets('a long text shows 15 lines and opens on Show more', (
    tester,
  ) async {
    await show(tester, describedIn(30));

    expect(descriptionHeight(tester), 22.0 * 15);

    await tester.tap(find.text('Show more'));
    await tester.pump();

    expect(descriptionHeight(tester), 22.0 * 30);
    expect(find.text('Show less'), findsOneWidget);
  });

  testWidgets('a text a fold would hide four lines of shows in full', (
    tester,
  ) async {
    await show(tester, describedIn(19));

    expect(descriptionHeight(tester), 22.0 * 19);
    expect(find.text('Show more'), findsNothing);
  });
}
