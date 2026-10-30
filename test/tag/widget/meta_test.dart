import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late QueryFieldController controller;

  setUp(() => controller = QueryFieldController(query: 'riolu'));
  tearDown(() => controller.dispose());

  Future<void> show(WidgetTester tester, MetaKind? kind, {String? me}) =>
      tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: MetaPanel(
                controller: controller,
                me: me,
                kind: kind,
                onPick: (_) {},
                onBack: () {},
              ),
            ),
          ),
        ),
      );

  testWidgets('the catalog lists every filter and picks the tapped one', (
    tester,
  ) async {
    MetaKind? picked;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: MetaCatalog(onPick: (kind) => picked = kind)),
      ),
    );

    for (final MetaKind kind in MetaKind.values) {
      await tester.ensureVisible(find.text(kind.label));
      await tester.tap(find.text(kind.label));
      expect(picked, kind);
    }
  });

  testWidgets('a date preset sets the date and a second tap clears it', (
    tester,
  ) async {
    await show(tester, MetaKind.date);

    await tester.tap(find.text('Past month'));
    await tester.pump();
    expect(controller.terms, ['riolu', 'date:month']);

    await tester.tap(find.text('Past month'));
    await tester.pump();
    expect(controller.terms, ['riolu']);
  });

  testWidgets('a count preset sets a lower bound for the chosen count', (
    tester,
  ) async {
    await show(tester, MetaKind.counts);

    await tester.tap(find.text('Favorites'));
    await tester.pump();
    await tester.tap(find.text('≥ 100'));
    await tester.pump();

    expect(controller.terms, ['riolu', 'favcount:>=100']);
  });

  testWidgets('an order replaces the previous one and turns around', (
    tester,
  ) async {
    controller.commit('order:favcount');
    await show(tester, MetaKind.order);

    await tester.tap(find.text('Score'));
    await tester.pump();
    await tester.tap(find.text('Lowest first'));
    await tester.pump();

    expect(controller.terms, ['riolu', 'order:score_asc']);

    await tester.tap(find.text('Newest'));
    await tester.pump();

    expect(controller.terms, ['riolu', 'order:id_asc']);
  });

  testWidgets('newest order removes the order term', (tester) async {
    controller.commit('order:score');
    await show(tester, MetaKind.order);

    await tester.tap(find.text('Newest'));
    await tester.pump();

    expect(controller.terms, ['riolu']);
  });

  testWidgets('a rating replaces the previous rating', (tester) async {
    controller.commit('rating:e');
    await show(tester, MetaKind.rating);

    await tester.tap(find.text('Safe'));
    await tester.pump();

    expect(controller.terms, ['riolu', 'rating:s']);
  });

  testWidgets('the panel header shows the raw terms of its builder', (
    tester,
  ) async {
    controller.commit('date:week score:>=10');
    await show(tester, MetaKind.date);

    expect(find.text('date:week'), findsOneWidget);
  });

  testWidgets('a metatag chip reads in words', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: QueryChip(term: 'score:>=100', selected: false, onTap: () {}),
        ),
      ),
    );

    expect(find.text('score ≥ 100', findRichText: true), findsOneWidget);
    expect(find.byIcon(MetaKind.counts.icon), findsOneWidget);
  });

  testWidgets('a file kind adds its types as one group and a second tap '
      'removes it', (tester) async {
    await show(tester, MetaKind.file);

    await tester.tap(find.text('Videos'));
    await tester.pump();
    expect(controller.terms, ['riolu', '( ~type:mp4 ~type:webm )']);

    await tester.tap(find.text('Videos'));
    await tester.pump();
    expect(controller.terms, ['riolu']);
  });

  testWidgets('a length sets the duration', (tester) async {
    await show(tester, MetaKind.file);

    await tester.tap(find.text('Under 30 s'));
    await tester.pump();

    expect(controller.terms, ['riolu', 'duration:<30']);
  });

  testWidgets('a shape sets the ratio and Any clears it', (tester) async {
    await show(tester, MetaKind.size);

    await tester.tap(find.text('Landscape'));
    await tester.pump();
    expect(controller.terms, ['riolu', 'ratio:>1']);

    await tester.tap(find.text('Any').at(1));
    await tester.pump();
    expect(controller.terms, ['riolu']);
  });

  testWidgets('people pairs a relation with the reader', (tester) async {
    await show(tester, MetaKind.people, me: 'tester');

    await tester.tap(find.text('Me'));
    await tester.pump();
    expect(controller.terms, ['riolu', 'fav:tester']);

    await tester.tap(find.text('Upvoted'));
    await tester.pump();
    expect(controller.terms, ['riolu', 'votedup:tester']);
  });

  testWidgets('people offers Me only to a signed in reader', (tester) async {
    await show(tester, MetaKind.people);

    expect(find.text('Me'), findsNothing);
    expect(find.text('Someone else'), findsOneWidget);
  });

  testWidgets('a property is set to yes, no or any', (tester) async {
    await show(tester, MetaKind.properties);
    final Finder row = find
        .ancestor(of: find.text('In a pool'), matching: find.byType(Row))
        .first;

    await tester.tap(find.descendant(of: row, matching: find.text('No')));
    await tester.pump();
    expect(controller.terms, ['riolu', 'inpool:false']);

    await tester.tap(find.descendant(of: row, matching: find.text('Any')));
    await tester.pump();
    expect(controller.terms, ['riolu']);
  });

  testWidgets('a status other than active is added', (tester) async {
    await show(tester, MetaKind.status);

    await tester.tap(find.text('Deleted'));
    await tester.pump();
    expect(controller.terms, ['riolu', 'status:deleted']);

    await tester.tap(find.text('Active'));
    await tester.pump();
    expect(controller.terms, ['riolu']);
  });
}
