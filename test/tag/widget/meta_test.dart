import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late QueryFieldController controller;

  setUp(() => controller = QueryFieldController(query: 'riolu'));
  tearDown(() => controller.dispose());

  Future<void> show(WidgetTester tester, MetaKind? kind) => tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: MetaPanel(
            controller: controller,
            kind: kind,
            onPick: (_) {},
            onBack: () {},
          ),
        ),
      ),
    ),
  );

  testWidgets('the catalog lists the filters that have builders', (
    tester,
  ) async {
    MetaKind? picked;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: MetaCatalog(onPick: (kind) => picked = kind)),
      ),
    );

    expect(find.text('Order'), findsOneWidget);
    expect(find.text('Pools & sets'), findsNothing);

    await tester.tap(find.text('Order'));

    expect(picked, MetaKind.order);
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
}
