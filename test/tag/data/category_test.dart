import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('each category has its own hue, set apart for each brightness', () {
    for (final Brightness brightness in Brightness.values) {
      expect(
        {
          for (final TagCategory category in TagCategory.values)
            category.colorFor(brightness),
        },
        hasLength(TagCategory.values.length),
        reason: brightness.name,
      );
    }
    for (final TagCategory category in TagCategory.values) {
      expect(
        category.colorFor(Brightness.light),
        isNot(category.colorFor(Brightness.dark)),
        reason: category.name,
      );
    }
  });
}
