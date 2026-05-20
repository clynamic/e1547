// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'create_comment_body_comment.g.dart';

@JsonSerializable()
class CreateCommentBodyComment {
  const CreateCommentBodyComment({
    required this.body,
    required this.postId,
    this.doNotBumpPost,
    this.isSticky,
    this.isHidden,
  });
  
  factory CreateCommentBodyComment.fromJson(Map<String, Object?> json) => _$CreateCommentBodyCommentFromJson(json);
  
  /// The comment body text
  final String body;

  /// The ID of the post to comment on
  @JsonKey(name: 'post_id')
  final int postId;

  /// Whether to bump the post
  @JsonKey(name: 'do_not_bump_post')
  final bool? doNotBumpPost;

  /// Whether the comment is sticky (janitor only)
  @JsonKey(name: 'is_sticky')
  final bool? isSticky;

  /// Whether the comment is hidden (moderator only)
  @JsonKey(name: 'is_hidden')
  final bool? isHidden;

  Map<String, Object?> toJson() => _$CreateCommentBodyCommentToJson(this);
}
