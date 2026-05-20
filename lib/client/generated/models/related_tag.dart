// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'related_tag.g.dart';

/// Related tags for a given query.
@JsonSerializable()
class RelatedTag {
  const RelatedTag({
    this.query,
    this.category,
    this.tags,
    this.wikiPageTags,
  });
  
  factory RelatedTag.fromJson(Map<String, Object?> json) => _$RelatedTagFromJson(json);
  
  /// The query tag
  final String? query;

  /// The category ID filter
  final int? category;

  /// Array of related tag pairs
  final List<List<String>>? tags;

  /// Tags found on the wiki page
  @JsonKey(name: 'wiki_page_tags')
  final List<String>? wikiPageTags;

  Map<String, Object?> toJson() => _$RelatedTagToJson(this);
}
