// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  const Comment({
    required this.id,
    required this.postId,
    required this.creatorId,
    required this.body,
    required this.score,
    required this.createdAt,
    required this.updatedAt,
    required this.updaterId,
    required this.doNotBumpPost,
    required this.isHidden,
    required this.isSticky,
    this.warningType,
    this.warningUserId,
    this.creatorName,
    this.updaterName,
  });
  
  factory Comment.fromJson(Map<String, Object?> json) => _$CommentFromJson(json);
  
  /// The unique ID of the comment
  final int id;

  /// The ID of the post this comment belongs to
  @JsonKey(name: 'post_id')
  final int postId;

  /// The ID of the user who created the comment
  @JsonKey(name: 'creator_id')
  final int creatorId;

  /// The comment body text
  final String body;

  /// The comment score
  final int score;

  /// The time when the comment was created
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// The last time the comment was updated
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  /// The ID of the user who last updated the comment
  @JsonKey(name: 'updater_id')
  final int? updaterId;

  /// Whether the comment should not bump the post
  @JsonKey(name: 'do_not_bump_post')
  final bool doNotBumpPost;

  /// Whether the comment is hidden
  @JsonKey(name: 'is_hidden')
  final bool isHidden;

  /// Whether the comment is sticky
  @JsonKey(name: 'is_sticky')
  final bool isSticky;

  /// The type of warning applied to the comment
  @JsonKey(name: 'warning_type')
  final int? warningType;

  /// The ID of the user who applied the warning
  @JsonKey(name: 'warning_user_id')
  final int? warningUserId;

  /// The username of the comment creator
  @JsonKey(name: 'creator_name')
  final String? creatorName;

  /// The username of the last updater
  @JsonKey(name: 'updater_name')
  final String? updaterName;

  Map<String, Object?> toJson() => _$CommentToJson(this);
}
