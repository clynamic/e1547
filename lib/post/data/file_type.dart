import 'package:e1547/tag/tag.dart';

/// The kind of media a post search is restricted to.
enum PostFileType {
  none,
  image,
  video;

  /// The single query token this type is encoded as, or null for [none].
  ///
  /// The tokens use e621's group syntax: the "or"-ed types inside one group
  /// make up a single tag, which keeps repeated metatag keys from being
  /// collapsed by the tag map.
  String? get token => switch (this) {
    PostFileType.none => null,
    PostFileType.image => '-( ~type:webm ~type:mp4 ~type:swf )',
    PostFileType.video => '( ~type:webm ~type:mp4 )',
  };

  /// The canonical name of this type, doubling as a localization key.
  String get label => switch (this) {
    PostFileType.none => 'All',
    PostFileType.image => 'Images',
    PostFileType.video => 'Videos',
  };
}

/// The file extensions e621's `type:` metatag accepts that this app can
/// display, and the category each belongs to.
///
/// Flash (`swf`) is absent on purpose: the app considers flash posts broken
/// and drops them from every listing, so a search for it would always come
/// back empty.
const Map<String, PostFileType> fileTypeAliases = {
  'jpg': PostFileType.image,
  'png': PostFileType.image,
  'gif': PostFileType.image,
  'webp': PostFileType.image,
  'webm': PostFileType.video,
  'mp4': PostFileType.video,
};

/// Returns the file type the [tags] search by.
///
/// A type group token is matched exactly. A plain `type:` tag—like the kind
/// an older query carries—is mapped to the category it belongs to. Anything
/// else, including negations and unknown values, reports no selection and
/// leaves the query as it is.
PostFileType fileTypeFromTags(TagMap tags) {
  for (final type in PostFileType.values) {
    final token = type.token;
    if (token != null && tags.tags.contains(token)) return type;
  }
  return fileTypeAliases[tags['type'] ?? ''] ?? PostFileType.none;
}

/// Replaces the file type of [tags] with [type], keeping every other token.
///
/// This replaces the whole family of type tags, including plain `type:` tags
/// an older query carried, once the user picks a category.
TagMap withFileType(TagMap tags, PostFileType type) {
  final kept = tags.tags.where((token) => !_isFileTypeToken(token)).toList();
  final token = type.token;
  if (token != null) kept.add(token);
  return TagMap(kept.join(' '));
}

/// Whether a token belongs to the family of file type metatags.
bool _isFileTypeToken(String token) =>
    token == PostFileType.image.token ||
    token == PostFileType.video.token ||
    token.startsWith('type:') ||
    token.startsWith('-type:') ||
    token.startsWith('~type:');

/// Whether [tags] restrict their search by file type in any form.
bool hasFileTypeTokens(TagMap tags) => tags.tags.any(_isFileTypeToken);
