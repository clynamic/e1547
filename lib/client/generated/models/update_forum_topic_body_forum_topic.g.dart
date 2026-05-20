// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_forum_topic_body_forum_topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateForumTopicBodyForumTopic _$UpdateForumTopicBodyForumTopicFromJson(
  Map<String, dynamic> json,
) => UpdateForumTopicBodyForumTopic(
  title: json['title'] as String?,
  categoryId: (json['category_id'] as num?)?.toInt(),
  originalPostAttributes: json['original_post_attributes'] == null
      ? null
      : UpdateForumTopicBodyForumTopicOriginalPostAttributes.fromJson(
          json['original_post_attributes'] as Map<String, dynamic>,
        ),
  isSticky: json['is_sticky'] as bool?,
  isLocked: json['is_locked'] as bool?,
);

Map<String, dynamic> _$UpdateForumTopicBodyForumTopicToJson(
  UpdateForumTopicBodyForumTopic instance,
) => <String, dynamic>{
  'title': instance.title,
  'category_id': instance.categoryId,
  'original_post_attributes': instance.originalPostAttributes,
  'is_sticky': instance.isSticky,
  'is_locked': instance.isLocked,
};
