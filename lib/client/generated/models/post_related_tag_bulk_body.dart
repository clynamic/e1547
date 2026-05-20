// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'post_related_tag_bulk_body.g.dart';

@JsonSerializable()
class PostRelatedTagBulkBody {
  const PostRelatedTagBulkBody({
    this.query,
    this.categoryId,
  });
  
  factory PostRelatedTagBulkBody.fromJson(Map<String, Object?> json) => _$PostRelatedTagBulkBodyFromJson(json);
  
  /// The tag query for bulk related tag lookup
  final String? query;

  /// Filter by tag category ID
  @JsonKey(name: 'category_id')
  final int? categoryId;

  Map<String, Object?> toJson() => _$PostRelatedTagBulkBodyToJson(this);
}
