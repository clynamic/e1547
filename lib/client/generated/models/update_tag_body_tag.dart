// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'update_tag_body_tag.g.dart';

@JsonSerializable()
class UpdateTagBodyTag {
  const UpdateTagBodyTag({
    this.category,
    this.isLocked,
  });
  
  factory UpdateTagBodyTag.fromJson(Map<String, Object?> json) => _$UpdateTagBodyTagFromJson(json);
  
  /// The category ID for the tag
  final int? category;

  /// Whether the tag is locked (admin only)
  @JsonKey(name: 'is_locked')
  final bool? isLocked;

  Map<String, Object?> toJson() => _$UpdateTagBodyTagToJson(this);
}
