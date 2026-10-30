import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';

final Color excludedTermColor = Colors.red.shade300;

final Color anyOfTermColor = Colors.orange.shade300;

Color? termPrefixColor(String prefix) => switch (prefix) {
  '-' => excludedTermColor,
  '~' => anyOfTermColor,
  _ => null,
};

Color tagMarkColor(
  ThemeData theme,
  String term, {
  TagPreview? preview,
  TagCategory? category,
}) {
  if (tagWithoutPrefix(term).contains(':') || preview?.postCount == 0) {
    return Colors.grey;
  }
  return (TagCategory.byId(preview?.category) ?? category)?.colorFor(
        theme.brightness,
      ) ??
      theme.colorScheme.onSurface.withValues(alpha: 0.38);
}
