// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'tag.g.dart';

@JsonSerializable()
class Tag {
  const Tag({
    required this.id,
    required this.name,
    required this.postCount,
    required this.category,
    required this.isLocked,
    required this.createdAt,
    required this.updatedAt,
    this.relatedTags,
    this.relatedTagsUpdatedAt,
  });
  
  factory Tag.fromJson(Map<String, Object?> json) => _$TagFromJson(json);
  
  /// The unique ID of the tag
  final int id;

  /// The name of the tag
  final String name;

  /// The number of posts with this tag
  @JsonKey(name: 'post_count')
  final int postCount;

  /// The category ID of the tag
  final int category;

  /// Space-separated related tags with counts
  @JsonKey(name: 'related_tags')
  final String? relatedTags;

  /// When related tags were last updated
  @JsonKey(name: 'related_tags_updated_at')
  final DateTime? relatedTagsUpdatedAt;

  /// Whether the tag category is locked
  @JsonKey(name: 'is_locked')
  final bool isLocked;

  /// When the tag was created
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// When the tag was last updated
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Map<String, Object?> toJson() => _$TagToJson(this);
}
