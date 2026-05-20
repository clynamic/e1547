// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'create_post_flag_body_post_flag.g.dart';

@JsonSerializable()
class CreatePostFlagBodyPostFlag {
  const CreatePostFlagBodyPostFlag({
    required this.postId,
    required this.reasonName,
    this.parentId,
    this.note,
  });
  
  factory CreatePostFlagBodyPostFlag.fromJson(Map<String, Object?> json) => _$CreatePostFlagBodyPostFlagFromJson(json);
  
  /// The ID of the post to flag
  @JsonKey(name: 'post_id')
  final int postId;

  /// The reason for flagging
  @JsonKey(name: 'reason_name')
  final String reasonName;

  /// The parent post ID (for inferior duplicates)
  @JsonKey(name: 'parent_id')
  final int? parentId;

  /// Additional explanation for the flag
  final String? note;

  Map<String, Object?> toJson() => _$CreatePostFlagBodyPostFlagToJson(this);
}
