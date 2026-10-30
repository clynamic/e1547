import 'package:e1547/tag/tag.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('previews ask for plain tags once each, in lower case', () {
    expect(
      tagPreviewNames([
        'Wolf',
        '-fox',
        '~cat',
        'rating:s',
        '( ~wolf ~fox )',
        'wolf',
      ]),
      ['wolf', 'fox', 'cat'],
    );
  });

  test('a preview is found for a term in any case and with its prefix', () {
    final TagPreviews previews = TagPreviews([
      const TagPreview(name: 'wolf', postCount: 12),
    ]);

    expect(previews.of('-Wolf')?.postCount, 12);
  });
}
