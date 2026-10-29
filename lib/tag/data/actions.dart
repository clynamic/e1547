import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';

final List<String> wikiMetaTags = List.unmodifiable([
  'help:',
  'e621:',
  'howto:',
]);

/// Removes prefixes from tags.
String tagToRaw(String tags) => TagMap(
  tags,
).tags.map((e) => e.replaceFirst(RegExp(r'^[-~]'), '')).join(' ');

/// Removes underscored from tags, adds commas.
String tagToName(String tags) =>
    TagMap(tags).tags.map((e) => e.replaceAll('_', ' ')).join(', ');

/// Removes underscores and prefixes from tags
String tagToTitle(String tags) => tagToName(tagToRaw(tags));

enum TagCategory {
  general,
  species,
  character,
  copyright,
  meta,
  lore,
  artist,
  contributor,
  invalid;

  Color colorFor(Brightness brightness) => Color(switch (brightness) {
    Brightness.dark => switch (this) {
      general => 0xFF9CC9F0,
      species => 0xFFFF8A3D,
      character => 0xFF66CC6E,
      copyright => 0xFFE366F0,
      meta => 0xFFF5F5F5,
      lore => 0xFF2E9E4F,
      artist => 0xFFFFCA28,
      contributor => 0xFFA8A8A8,
      invalid => 0xFFFF4D6A,
    },
    Brightness.light => switch (this) {
      general => 0xFF4A9BE0,
      species => 0xFFFF7A1A,
      character => 0xFF2DB84A,
      copyright => 0xFFD63ADF,
      meta => 0xFF4A4A4A,
      lore => 0xFF1F8A46,
      artist => 0xFFF7B500,
      contributor => 0xFFA3A3A3,
      invalid => 0xFFF0384F,
    },
  });

  int get id {
    switch (this) {
      case general:
        return 0;
      case species:
        return 5;
      case character:
        return 4;
      case copyright:
        return 3;
      case meta:
        return 7;
      case lore:
        return 8;
      case artist:
        return 1;
      case contributor:
        return 2;
      case invalid:
        return 6;
    }
  }

  static List<String> get names => values.asNameMap().keys.toList();

  static TagCategory byId(int id) => values.firstWhere((e) => e.id == id);

  static TagCategory? byName(String name) =>
      values.asNameMap()[name.toLowerCase()];
}

List<String> filterArtists(List<String> artists) {
  List<String> excluded = [
    'epilepsy_warning',
    'conditional_dnp',
    'sound_warning',
    'avoid_posting',
  ];

  return List.from(artists)..removeWhere((artist) => excluded.contains(artist));
}
