import 'package:e1547/app/app.dart';
import 'package:e1547/post/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/bed.dart';
import '../../_support/harness.dart';
import '../../_support/posts.dart';

void main() {
  late TestBed bed;
  late PostFilter filter;

  setUpAll(initializeTestApp);

  setUp(() async {
    bed = await TestBed.start(denylist: ['gore', 'spider']);
    filter = PostFilter(bed.client)
      ..track('page', [
        samplePost(
          tags: const {
            'general': ['spider'],
          },
        ),
        samplePost(
          id: 2,
          tags: const {
            'general': ['spider', 'gore'],
          },
        ),
        samplePost(
          id: 3,
          tags: const {
            'general': ['solo'],
          },
        ),
      ]);
  });

  tearDown(() async {
    filter.dispose();
    await bed.dispose();
  });

  int edits = 0;

  Future<void> show(WidgetTester tester) async {
    edits = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: HiddenPostsSheet(
              filter: filter,
              onEditBlacklist: () => edits++,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder line(String entry) =>
      find.ancestor(of: find.text(entry), matching: find.byType(InkWell));

  testWidgets('a few lines fit the sheet to its content', (tester) async {
    await show(tester);

    final double screen =
        tester.view.physicalSize.height / tester.view.devicePixelRatio;
    expect(
      tester.getSize(find.byType(HiddenPostsSheet)).height,
      lessThan(screen - 120),
    );
  });

  testWidgets('many lines stop the sheet short of the top and scroll', (
    tester,
  ) async {
    bed.traits.value = bed.traits.value.copyWith(
      denylist: [for (int i = 0; i < 30; i++) 'tag_$i'],
    );
    filter.track('many', [
      for (int i = 0; i < 30; i++)
        samplePost(
          id: 100 + i,
          tags: {
            'general': ['tag_$i'],
          },
        ),
    ]);
    await show(tester);

    final double screen =
        tester.view.physicalSize.height / tester.view.devicePixelRatio;
    expect(tester.getSize(find.byType(HiddenPostsSheet)).height, screen - 120);
    final Finder last = find.text('tag 29');
    expect(last.hitTestable(), findsNothing);

    await tester.drag(find.byType(HiddenPostsSheet), const Offset(0, -2000));
    await tester.pumpAndSettle();

    expect(last.hitTestable(), findsOneWidget);
    expect(find.text('Use blacklist in this search'), findsOneWidget);
  });

  testWidgets('the sheet counts hidden posts and lists lines by hits', (
    tester,
  ) async {
    await show(tester);

    expect(find.text('2 of 3 posts hidden'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('spider')).dy,
      lessThan(tester.getTopLeft(find.text('gore')).dy),
    );
  });

  testWidgets('the sheet states the matched lines and links to the blacklist', (
    tester,
  ) async {
    await show(tester);

    expect(find.text('2 blacklist lines matched this search'), findsOneWidget);
    expect(find.text('Done'), findsNothing);
    await tester.tap(find.text('Edit blacklist'));
    expect(edits, 1);
  });

  testWidgets('switching a line off shows the posts only it hid', (
    tester,
  ) async {
    await show(tester);

    await tester.tap(
      find.descendant(of: line('spider'), matching: find.byType(Switch)),
    );
    await tester.pumpAndSettle();

    expect(filter.allowedEntries, ['spider']);
    expect(find.text('1 of 3 posts hidden'), findsOneWidget);
  });

  testWidgets('turning the blacklist off for the search shows every post', (
    tester,
  ) async {
    await show(tester);

    await tester.tap(find.text('Use blacklist in this search'));
    await tester.pumpAndSettle();

    expect(filter.denying, isFalse);
    expect(find.text('0 of 3 posts hidden'), findsOneWidget);
  });

  testWidgets('a line switched off keeps its count', (tester) async {
    filter.allowedEntries = ['gore'];
    await show(tester);

    expect(
      find.descendant(of: line('gore'), matching: find.text('1')),
      findsOneWidget,
    );
  });

  group('PostDock', () {
    int hidden = 0;

    Future<void> showDock(WidgetTester tester) async {
      hidden = 0;
      final PostParamsController params = PostParamsController();
      addTearDown(params.dispose);
      await tester.pumpWidget(
        bed.app(
          Scaffold(
            body: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: navBarDockHeight,
                child: PostDock(
                  params: params,
                  filter: filter,
                  onOpen: (_) async {},
                  onHidden: () => hidden++,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('the hidden count is the last chip and opens the sheet', (
      tester,
    ) async {
      await showDock(tester);

      final Finder chip = find.widgetWithText(HiddenChip, '2');
      expect(chip, findsOneWidget);
      expect(
        tester.getTopLeft(chip).dx,
        greaterThan(tester.getTopRight(find.text('Search')).dx),
      );
      await tester.tap(chip);
      expect(hidden, 1);
    });

    testWidgets('the search button fills the height of the dock row', (
      tester,
    ) async {
      await showDock(tester);

      final Rect button = tester.getRect(
        find
            .ancestor(
              of: find.byIcon(Icons.search),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      expect(button.size, const Size(44, navBarDockHeight - 12));
    });
  });
}
