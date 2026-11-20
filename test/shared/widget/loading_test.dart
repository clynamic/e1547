import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> show(WidgetTester tester, {required bool loaded}) =>
      tester.pumpWidget(
        MaterialApp(
          home: LoadingPage(
            isLoading: !loaded,
            isEmpty: !loaded,
            onRetry: null,
            child: (context) => const Scaffold(body: Text('content')),
          ),
        ),
      );

  MaterialType wrapper(WidgetTester tester) => tester
      .widget<Material>(
        find
            .descendant(
              of: find.byType(LoadingPage),
              matching: find.byType(Material),
            )
            .first,
      )
      .type;

  testWidgets('a loaded page leaves the background to its content', (
    tester,
  ) async {
    await show(tester, loaded: true);

    expect(find.text('content'), findsOneWidget);
    expect(wrapper(tester), MaterialType.transparency);
  });

  testWidgets('a page still loading paints its own background', (tester) async {
    await show(tester, loaded: false);

    expect(find.byType(HexagonalLoadingIndicator), findsOneWidget);
    expect(wrapper(tester), MaterialType.canvas);
  });
}
