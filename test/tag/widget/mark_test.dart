import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'a tag mark takes the category hue, and grey for metatags and unknown tags',
    () {
      final ThemeData theme = ThemeData.dark();
      final Color species = TagCategory.species.colorFor(Brightness.dark);
      final TagPreview known = TagPreview(
        name: 'riolu',
        category: TagCategory.species.id,
        postCount: 9800,
      );

      expect(tagMarkColor(theme, '-riolu', preview: known), species);
      expect(
        tagMarkColor(theme, 'riolu', category: TagCategory.species),
        species,
      );
      expect(tagMarkColor(theme, 'rating:s'), Colors.grey);
      expect(
        tagMarkColor(
          theme,
          'riolu',
          preview: const TagPreview(name: 'riolu', postCount: 0),
        ),
        Colors.grey,
      );
    },
  );
}
