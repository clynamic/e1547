// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_forum_topic_body_forum_topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateForumTopicBodyForumTopic _$CreateForumTopicBodyForumTopicFromJson(
  Map<String, dynamic> json,
) => CreateForumTopicBodyForumTopic(
  title: json['title'] as String,
  categoryId: (json['category_id'] as num).toInt(),
  originalPostAttributes: CreateStaffNoteBodyStaffNote.fromJson(
    json['original_post_attributes'] as Map<String, dynamic>,
  ),
  isSticky: json['is_sticky'] as bool?,
  isLocked: json['is_locked'] as bool?,
);

Map<String, dynamic> _$CreateForumTopicBodyForumTopicToJson(
  CreateForumTopicBodyForumTopic instance,
) => <String, dynamic>{
  'title': instance.title,
  'category_id': instance.categoryId,
  'original_post_attributes': instance.originalPostAttributes,
  'is_sticky': instance.isSticky,
  'is_locked': instance.isLocked,
};
