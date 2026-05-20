// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'post_flag_type.dart';

part 'post_flag.g.dart';

/// A post flag object representing a user's flag or deletion of a post.
@JsonSerializable()
class PostFlag {
  const PostFlag({
    required this.id,
    required this.createdAt,
    required this.postId,
    required this.reason,
    required this.creatorId,
    required this.isResolved,
    required this.updatedAt,
    required this.isDeletion,
    required this.type,
    this.note,
  });
  
  factory PostFlag.fromJson(Map<String, Object?> json) => _$PostFlagFromJson(json);
  
  /// The unique ID of the post flag
  final int id;

  /// The timestamp when the post flag was created
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// The ID of the post that the flag is related to
  @JsonKey(name: 'post_id')
  final int postId;

  /// The reason for the flag or deletion request
  final String reason;

  /// The ID of the user who created the flag or deletion request
  @JsonKey(name: 'creator_id')
  final int creatorId;

  /// Whether the flag has been resolved
  @JsonKey(name: 'is_resolved')
  final bool isResolved;

  /// The timestamp when the post flag was last updated
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  /// Whether the flag is a deletion request
  @JsonKey(name: 'is_deletion')
  final bool isDeletion;
  final PostFlagType type;

  /// Additional explanation regarding the flag
  final String? note;

  Map<String, Object?> toJson() => _$PostFlagToJson(this);
}
