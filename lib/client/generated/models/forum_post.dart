// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'forum_post.g.dart';

@JsonSerializable()
class ForumPost {
  const ForumPost({
    required this.id,
    required this.topicId,
    required this.creatorId,
    required this.updaterId,
    required this.body,
    required this.isHidden,
    required this.createdAt,
    required this.updatedAt,
    this.warningType,
    this.warningUserId,
    this.creatorName,
    this.updaterName,
  });
  
  factory ForumPost.fromJson(Map<String, Object?> json) => _$ForumPostFromJson(json);
  
  /// The unique ID of the forum post
  final int id;

  /// The ID of the forum topic this post belongs to
  @JsonKey(name: 'topic_id')
  final int topicId;

  /// The ID of the user who created the post
  @JsonKey(name: 'creator_id')
  final int creatorId;

  /// The ID of the user who last updated the post
  @JsonKey(name: 'updater_id')
  final int updaterId;

  /// The forum post body text
  final String body;

  /// Whether the forum post is hidden
  @JsonKey(name: 'is_hidden')
  final bool isHidden;

  /// The time when the forum post was created
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// The last time the forum post was updated
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  /// The type of warning applied to the post
  @JsonKey(name: 'warning_type')
  final int? warningType;

  /// The ID of the user who applied the warning
  @JsonKey(name: 'warning_user_id')
  final int? warningUserId;

  /// The username of the post creator
  @JsonKey(name: 'creator_name')
  final String? creatorName;

  /// The username of the last updater
  @JsonKey(name: 'updater_name')
  final String? updaterName;

  Map<String, Object?> toJson() => _$ForumPostToJson(this);
}
