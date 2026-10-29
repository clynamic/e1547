import 'package:e1547/post/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/bed.dart';
import '../../_support/harness.dart';

void main() {
  setUpAll(initializeTestApp);

  late TestBed bed;

  setUp(() async {
    bed = await TestBed.start();
    bed.fake.state.tags.addAll([
      for (final (int index, String name) in ['riolu', 'rioichi'].indexed)
        {
          'id': index + 1,
          'name': name,
          'post_count': 100 - index,
          'category': 4,
        },
    ]);
  });

  tearDown(() => bed.dispose());

  displayTest('tag suggestions stay while the next ones load', (tester) async {
    final ValueNotifier<String> typed = ValueNotifier('rio');
    addTearDown(typed.dispose);
    await tester.runAsync(
      () => tester.pumpWidget(
        bed.app(
          Scaffold(
            body: ValueListenableBuilder<String>(
              valueListenable: typed,
              builder: (context, value, child) =>
                  PostSearchSuggestions(typed: value, onPick: (_) {}),
            ),
          ),
        ),
      ),
    );
    await bed.settle(tester);
    expect(find.text('riolu', findRichText: true), findsOneWidget);

    typed.value = 'riol';
    await tester.pump();

    expect(find.text('riolu', findRichText: true), findsOneWidget);

    await bed.settle(tester);

    expect(find.text('riolu', findRichText: true), findsOneWidget);
    expect(find.text('rioichi', findRichText: true), findsNothing);
  });
}
