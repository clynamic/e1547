import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> show(WidgetTester tester, LoadMoreState state) =>
      tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(child: LoadMoreFooter(state: state)),
          ),
        ),
      );

  Finder mark() => find.descendant(
    of: find.byType(LoadMoreFooter),
    matching: find.byType(CustomPaint),
  );

  testWidgets('a failed load draws the hexagon broken with a crack', (
    tester,
  ) async {
    await show(tester, LoadMoreState.failed);
    const double s = loadMoreSize / 48;
    final Color error = Colors.red.shade300.withValues(alpha: 0.9);

    expect(
      mark(),
      paints
        ..path(color: error, strokeWidth: 3 * s)
        ..path(color: error, strokeWidth: 3 * s)
        ..path(
          color: error,
          strokeWidth: 2.5 * s,
          includes: const [Offset(16.2 * s, 33.4 * s)],
          excludes: const [Offset(24 * s, 24 * s)],
        ),
    );
  });
}
