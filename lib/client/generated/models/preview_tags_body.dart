// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'preview_tags_body.g.dart';

@JsonSerializable()
class PreviewTagsBody {
  const PreviewTagsBody({
    this.tags,
  });
  
  factory PreviewTagsBody.fromJson(Map<String, Object?> json) => _$PreviewTagsBodyFromJson(json);
  
  /// The tags string to preview
  final String? tags;

  Map<String, Object?> toJson() => _$PreviewTagsBodyToJson(this);
}
