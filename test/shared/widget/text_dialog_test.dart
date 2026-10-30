import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<List<String?>> open(WidgetTester tester) async {
    final List<String?> results = [];
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async => results.add(
              await showDialog<String>(
                context: context,
                builder: (context) => const TextInputDialog(
                  title: 'At least',
                  initial: '10',
                  actions: [('No limit', '')],
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
    return results;
  }

  testWidgets('a text dialog returns what was typed once it has closed', (
    tester,
  ) async {
    final List<String?> results = await open(tester);

    await tester.enterText(find.byType(TextField), '25');
    await tester.tap(find.text('Set'));
    await tester.pumpAndSettle();

    expect(results, ['25']);
    expect(find.byType(TextInputDialog), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a text dialog action returns its own result', (tester) async {
    final List<String?> results = await open(tester);

    await tester.tap(find.text('No limit'));
    await tester.pumpAndSettle();

    expect(results, ['']);
  });
}
