import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QueryFieldController', () {
    late QueryFieldController controller;

    setUp(() => controller = QueryFieldController(query: 'riolu  -human'));

    tearDown(() => controller.dispose());

    void type(String value) =>
        controller.text.text = '${controller.text.text}$value';

    void erase() => controller.text.text = '';

    test('a query becomes one chip per term', () {
      expect(controller.terms, ['riolu', '-human']);
      expect(controller.query, 'riolu -human');
    });

    test('a space commits the typed text as a chip', () {
      type('solo');
      expect(controller.terms, ['riolu', '-human']);
      expect(controller.query, 'riolu -human solo');

      type(' ');

      expect(controller.terms, ['riolu', '-human', 'solo']);
      expect(controller.typed, '');
    });

    test('pasted text splits into chips and keeps the last word typed', () {
      type('solo rating:s aur');

      expect(controller.terms, ['riolu', '-human', 'solo', 'rating:s']);
      expect(controller.typed, 'aur');
    });

    test('backspace on an empty field selects the last chip, then removes', () {
      erase();
      expect(controller.selected, 1);
      expect(controller.terms, ['riolu', '-human']);

      erase();

      expect(controller.terms, ['riolu']);
      expect(controller.selected, isNull);
    });

    test('a term already in the query is not added again', () {
      type('riolu ');

      expect(controller.terms, ['riolu', '-human']);
    });

    test('a term with another prefix replaces the one in the query', () {
      controller.commit('human');

      expect(controller.terms, ['riolu', 'human']);
    });

    test('a committed suggestion with spaces adds each term', () {
      controller.commit('lucario solo');

      expect(controller.terms, ['riolu', '-human', 'lucario', 'solo']);
    });
  });

  testWidgets('a chip takes its stripe from the tag category', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: QueryChip(
            term: 'riolu',
            selected: false,
            onTap: () {},
            preview: TagPreview(
              name: 'riolu',
              category: TagCategory.species.id,
            ),
          ),
        ),
      ),
    );

    final Container stripe = tester.widget<Container>(
      find.descendant(
        of: find.byType(QueryChip),
        matching: find.byType(Container),
      ),
    );
    expect(stripe.color, TagCategory.species.color);
  });

  testWidgets('typed text sits level with the chips', (tester) async {
    final QueryFieldController controller = QueryFieldController(
      query: 'riolu',
    );
    addTearDown(controller.dispose);
    controller.text.text = '${controller.text.text}sol';
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(child: QueryField(controller: controller)),
        ),
      ),
    );

    expect(
      tester.getCenter(find.byType(EditableText)).dy,
      moreOrLessEquals(tester.getCenter(find.byType(QueryChip)).dy, epsilon: 1),
    );
  });
}
