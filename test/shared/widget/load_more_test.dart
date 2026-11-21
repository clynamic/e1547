import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> show(WidgetTester tester, HexagonState state) =>
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
    await show(tester, HexagonState.failed);
    const double s = 36 / 48;
    final Color error = ThemeData().colorScheme.error.withValues(alpha: 0.9);

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

  Future<void> showList(
    WidgetTester tester,
    PagingState<int, String> state, {
    VoidCallback? onRetry,
  }) => tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: PagedListView<int, String>(
          state: state,
          fetchNextPage: () {},
          builderDelegate: defaultPagedChildBuilderDelegate<String>(
            itemBuilder: (context, item, index) => Text(item),
            onRetry: onRetry,
            onError: const Text('Failed to load lines'),
            onEnd: const Text('No more lines'),
          ),
        ),
      ),
    ),
  );

  testWidgets('a list whose next page failed shows a retry under its items', (
    tester,
  ) async {
    int retries = 0;
    await showList(
      tester,
      PagingState<int, String>(
        pages: const [
          ['first'],
        ],
        keys: const [1],
        error: Exception('offline'),
      ),
      onRetry: () => retries++,
    );

    expect(find.text('first'), findsOneWidget);
    expect(find.text('Failed to load lines'), findsOneWidget);

    await tester.tap(find.text('Retry'));

    expect(retries, 1);
  });

  testWidgets('a list with no further pages shows its end under its items', (
    tester,
  ) async {
    await showList(
      tester,
      PagingState<int, String>(
        pages: const [
          ['first'],
        ],
        keys: const [1],
        hasNextPage: false,
      ),
    );

    expect(find.text('first'), findsOneWidget);
    expect(find.text('No more lines'), findsOneWidget);
  });
}
