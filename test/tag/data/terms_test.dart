import 'package:e1547/tag/tag.dart';
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

    test('a pasted group stays one term', () {
      type('( ~type:mp4 ~type:webm ) solo ');

      expect(controller.terms, [
        'riolu',
        '-human',
        '( ~type:mp4 ~type:webm )',
        'solo',
      ]);
    });

    test('a committed suggestion with spaces adds each term', () {
      controller.commit('lucario solo');

      expect(controller.terms, ['riolu', '-human', 'lucario', 'solo']);
    });
  });
}
