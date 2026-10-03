import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';

/// A suggestion the tag input offers.
///
/// Implementations provide the text that replaces the tag being typed.
@immutable
sealed class TagSuggestion {
  const TagSuggestion();

  /// The text that replaces the current tag when this suggestion is picked.
  String get insertText;
}

/// A tag name suggested by the server.
@immutable
class TagNameSuggestion extends TagSuggestion {
  const TagNameSuggestion(this.tag);

  /// The suggested tag.
  final Tag tag;

  @override
  String get insertText => tag.name;
}

/// A fixed value of a metatag, like `order:rank`.
@immutable
class MetatagValueSuggestion extends TagSuggestion {
  const MetatagValueSuggestion({
    required this.metatag,
    required this.value,
    required this.name,
  });

  /// The metatag this value belongs to, like `order`.
  final String metatag;

  /// The value of the metatag, like `rank`.
  final String value;

  /// The canonical display name of the value, like `Rank`.
  ///
  /// This doubles as a [localizedFilterName] key, so values that exist in the
  /// filter panel show up translated.
  final String name;

  @override
  String get insertText => '$metatag:$value';
}

/// The fixed values of the metatags the site's search supports.
///
/// Metatags with free-form values (like `user:`) and special values (like
/// `order:pool`) are absent on purpose: suggesting queries the server would
/// reject would teach users broken syntax.
///
/// Display names double as [localizedFilterName] keys and must match the
/// names the posts filter panel uses, with the file type extensions as the
/// exception: the panel offers them grouped into picture and video
/// categories, so they keep their raw names here.
const Map<String, List<(String, String)>> metatagValues = {
  'order': [
    ('new', 'New'),
    ('id_asc', 'Oldest'),
    ('score', 'Score'),
    ('favcount', 'Favorites'),
    ('rank', 'Rank'),
    ('random', 'Random'),
  ],
  'rating': [('s', 'Safe'), ('q', 'Questionable'), ('e', 'Explicit')],
  'status': [
    ('active', 'Active'),
    ('pending', 'Pending'),
    ('deleted', 'Deleted'),
    ('flagged', 'Flagged'),
    ('any', 'Any'),
  ],
  'date': [
    ('day', 'Last day'),
    ('week', 'Last week'),
    ('month', 'Last Month'),
    ('year', 'Last Year'),
  ],
  'type': [
    ('jpg', 'JPG'),
    ('png', 'PNG'),
    ('gif', 'GIF'),
    ('webp', 'WEBP'),
    ('webm', 'WEBM'),
    ('mp4', 'MP4'),
  ],
  'inpool': [('true', 'True'), ('false', 'False')],
  'ischild': [('true', 'True'), ('false', 'False')],
  'isparent': [('true', 'True'), ('false', 'False')],
};

/// Suggests fixed metatag values for the given [tag].
///
/// [tag] must be a single tag whose operator prefix (`-` or `~`) was already
/// stripped, like `order:ra`. Unless [tag] is a `metatag:value` prefix of a
/// metatag in [metatagValues], this returns nothing.
List<MetatagValueSuggestion> suggestMetatagValues(String tag) {
  final index = tag.indexOf(':');
  if (index < 0) return const [];
  final metatag = tag.substring(0, index);
  final prefix = tag.substring(index + 1);
  return [
    for (final (value, name)
        in metatagValues[metatag] ?? const <(String, String)>[])
      if (value.startsWith(prefix))
        MetatagValueSuggestion(metatag: metatag, value: value, name: name),
  ];
}
