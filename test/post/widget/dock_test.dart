import 'package:e1547/post/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('a query shows each tag with its prefix and spaces', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: QueryLine(query: 'riolu -human ~hi_res')),
      ),
    );

    expect(find.text('riolu', findRichText: true), findsOneWidget);
    expect(find.text('-human', findRichText: true), findsOneWidget);
    expect(find.text('~hi res', findRichText: true), findsOneWidget);
  });

  testWidgets('an empty query shows the search hint', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: QueryLine(query: '  ')),
      ),
    );

    expect(find.text('Search'), findsOneWidget);
  });

  Future<List<String>> openSheet(WidgetTester tester) async {
    final List<String> submitted = [];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (context) =>
                    PostSearchSheet(query: 'riolu', onSubmit: submitted.add),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return submitted;
  }

  testWidgets('the search mark submits the query and closes the sheet', (
    tester,
  ) async {
    final List<String> submitted = await openSheet(tester);

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    expect(submitted, ['riolu ']);
    expect(find.byType(PostSearchSheet), findsNothing);
  });

  testWidgets('the keyboard search action submits what was typed', (
    tester,
  ) async {
    final List<String> submitted = await openSheet(tester);

    await tester.enterText(find.byType(TextField), 'riolu solo');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(submitted, ['riolu solo']);
    expect(find.byType(PostSearchSheet), findsNothing);
  });
}
