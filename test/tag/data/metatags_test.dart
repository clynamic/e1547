import 'package:e1547/post/post.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('suggests every value of a bare metatag', () {
    final suggestions = suggestMetatagValues('order:');

    expect(suggestions.map((suggestion) => suggestion.insertText), [
      'order:new',
      'order:id_asc',
      'order:score',
      'order:favcount',
      'order:rank',
      'order:random',
    ]);
    expect(suggestions.map((suggestion) => suggestion.name), [
      'New',
      'Oldest',
      'Score',
      'Favorites',
      'Rank',
      'Random',
    ]);
  });

  test('suggests the oldest order by its id prefixes', () {
    for (final tag in ['order:id', 'order:id_a']) {
      final suggestions = suggestMetatagValues(tag);

      expect(suggestions, hasLength(1));
      expect(suggestions.single.insertText, 'order:id_asc');
      expect(suggestions.single.name, 'Oldest');
    }
  });

  test('suggests values by prefix', () {
    final suggestions = suggestMetatagValues('order:ra');

    expect(suggestions.map((suggestion) => suggestion.insertText), [
      'order:rank',
      'order:random',
    ]);
  });

  test('suggests exactly one value for an unambiguous prefix', () {
    final suggestions = suggestMetatagValues('rating:s');

    expect(suggestions, hasLength(1));
    expect(suggestions.single.insertText, 'rating:s');
    expect(suggestions.single.name, 'Safe');
  });

  test('suggests nothing for free-form metatags', () {
    expect(suggestMetatagValues('user:'), isEmpty);
    expect(suggestMetatagValues('fav:'), isEmpty);
  });

  test('suggests nothing without a colon', () {
    expect(suggestMetatagValues('wolf'), isEmpty);
    expect(suggestMetatagValues(''), isEmpty);
  });

  test('leaves operator prefixes to the caller', () {
    // The tag input strips operators before calling, so a raw prefixed tag
    // must not match the directory.
    expect(suggestMetatagValues('-order:ra'), isEmpty);
    expect(suggestMetatagValues('~rating:s'), isEmpty);
  });
  test('the file type catalog matches the filter categories', () {
    // Every extension the catalog offers belongs to a filter category,
    // and flash is dead in this app: it never lists flash posts.
    expect(
      metatagValues['type']!.map((entry) => entry.$1),
      unorderedEquals(fileTypeAliases.keys),
    );
    expect(
      metatagValues['type']!.map((entry) => entry.$1),
      isNot(contains('swf')),
    );
  });
}
