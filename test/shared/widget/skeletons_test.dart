import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/harness.dart';

void main() {
  Future<void> show(WidgetTester tester, PagingState<int, String> state) =>
      tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverSkeletonPaging<String>(
                  state: state,
                  fetchNextPage: () {},
                  ghost: (index) => 'ghost $index',
                  builder: (context, state, fetchNextPage) => SliverList.list(
                    children: [
                      for (final String item in state.items ?? const [])
                        Text(item),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  testWidgets('a list loading its first page is built from ghost items', (
    tester,
  ) async {
    await show(tester, PagingState<int, String>(isLoading: true));

    expect(skeletons(find.text('ghost 0')), findsOneWidget);
    expect(skeletons(find.text('ghost 11')), findsOneWidget);
  });

  testWidgets('a loaded list is built from its own items', (tester) async {
    await show(
      tester,
      PagingState<int, String>(
        pages: const [
          ['real'],
        ],
        keys: const [1],
      ),
    );

    expect(find.text('real'), findsOneWidget);
    expect(skeletons(find.text('real')), findsNothing);
    expect(find.text('ghost 0'), findsNothing);
  });

  testWidgets('a list loading a later page keeps its own items', (
    tester,
  ) async {
    await show(
      tester,
      PagingState<int, String>(
        pages: const [
          ['real'],
        ],
        keys: const [1],
        isLoading: true,
      ),
    );

    expect(find.text('real'), findsOneWidget);
    expect(skeletons(find.text('real')), findsNothing);
  });
}
