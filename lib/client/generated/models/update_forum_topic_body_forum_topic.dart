// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'update_forum_topic_body_forum_topic_original_post_attributes.dart';

part 'update_forum_topic_body_forum_topic.g.dart';

@JsonSerializable()
class UpdateForumTopicBodyForumTopic {
  const UpdateForumTopicBodyForumTopic({
    this.title,
    this.categoryId,
    this.originalPostAttributes,
    this.isSticky,
    this.isLocked,
  });
  
  factory UpdateForumTopicBodyForumTopic.fromJson(Map<String, Object?> json) => _$UpdateForumTopicBodyForumTopicFromJson(json);
  
  /// The topic title
  final String? title;

  /// The forum category ID
  @JsonKey(name: 'category_id')
  final int? categoryId;
  @JsonKey(name: 'original_post_attributes')
  final UpdateForumTopicBodyForumTopicOriginalPostAttributes? originalPostAttributes;

  /// Whether the topic is sticky (moderator only)
  @JsonKey(name: 'is_sticky')
  final bool? isSticky;

  /// Whether the topic is locked (moderator only)
  @JsonKey(name: 'is_locked')
  final bool? isLocked;

  Map<String, Object?> toJson() => _$UpdateForumTopicBodyForumTopicToJson(this);
}
