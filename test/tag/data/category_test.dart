import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('categories take the e621 hues of the theme brightness', () {
    expect(
      TagCategory.species.colorFor(Brightness.dark),
      const Color(0xFFFF8A3D),
    );
    expect(
      TagCategory.species.colorFor(Brightness.light),
      const Color(0xFFFF7A1A),
    );
    expect(
      TagCategory.general.colorFor(Brightness.dark),
      const Color(0xFF9CC9F0),
    );
    expect(
      TagCategory.meta.colorFor(Brightness.light),
      const Color(0xFF4A4A4A),
    );
  });
}
