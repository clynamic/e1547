import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/posts.dart';

void main() {
  late SelectionLayoutData<Post> data;

  Future<void> pumpBar(
    WidgetTester tester, {
    required List<Post> posts,
    required Set<int> selected,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SelectionLayout<Post>(
            items: posts,
            keyOf: (post) => post.id,
            child: Builder(
              builder: (context) {
                data = SelectionLayout.of<Post>(context);
                return PostSelectionBar(selection: data);
              },
            ),
          ),
        ),
      ),
    );
    data.onChanged(posts.where((e) => selected.contains(e.id)).toSet());
    await tester.pump();
  }

  final List<Post> posts = [
    samplePost(isFavorited: true),
    samplePost(id: 2, isFavorited: true),
    samplePost(id: 3),
  ];

  testWidgets('the bar counts the selection and its favorites', (tester) async {
    await pumpBar(tester, posts: posts, selected: {1, 2, 3});

    expect(find.text('3 posts'), findsOneWidget);
    expect(find.text('2 of 3 favorited'), findsOneWidget);
    expect(
      tester.widget<Icon>(find.byIcon(Icons.favorite_border)).color,
      Colors.pinkAccent,
    );
  });

  testWidgets('a selection of favorites reads as all favorited', (
    tester,
  ) async {
    await pumpBar(tester, posts: posts, selected: {1, 2});

    expect(find.text('2 posts'), findsOneWidget);
    expect(find.text('All favorited'), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });

  testWidgets('a selection without favorites names only its size', (
    tester,
  ) async {
    await pumpBar(tester, posts: posts, selected: {3});

    expect(find.text('1 post'), findsOneWidget);
    expect(find.textContaining('favorited'), findsNothing);
    expect(
      tester.widget<Icon>(find.byIcon(Icons.favorite_border)).color,
      isNull,
    );
  });

  testWidgets('select all takes every post and close clears them', (
    tester,
  ) async {
    await pumpBar(tester, posts: posts, selected: {3});

    await tester.tap(find.byTooltip('Select all'));
    await tester.pump();
    expect(data.selections.map((e) => e.id), unorderedEquals([1, 2, 3]));

    await tester.tap(find.byTooltip('Close'));
    await tester.pump();
    expect(data.selections, isEmpty);
  });
}
