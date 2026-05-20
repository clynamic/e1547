// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'create_staff_note_body_staff_note.dart';

part 'create_forum_topic_body_forum_topic.g.dart';

@JsonSerializable()
class CreateForumTopicBodyForumTopic {
  const CreateForumTopicBodyForumTopic({
    required this.title,
    required this.categoryId,
    required this.originalPostAttributes,
    this.isSticky,
    this.isLocked,
  });
  
  factory CreateForumTopicBodyForumTopic.fromJson(Map<String, Object?> json) => _$CreateForumTopicBodyForumTopicFromJson(json);
  
  /// The topic title
  final String title;

  /// The forum category ID
  @JsonKey(name: 'category_id')
  final int categoryId;
  @JsonKey(name: 'original_post_attributes')
  final CreateStaffNoteBodyStaffNote originalPostAttributes;

  /// Whether the topic is sticky (moderator only)
  @JsonKey(name: 'is_sticky')
  final bool? isSticky;

  /// Whether the topic is locked (moderator only)
  @JsonKey(name: 'is_locked')
  final bool? isLocked;

  Map<String, Object?> toJson() => _$CreateForumTopicBodyForumTopicToJson(this);
}
