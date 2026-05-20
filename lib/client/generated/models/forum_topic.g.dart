// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum_topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForumTopic _$ForumTopicFromJson(Map<String, dynamic> json) => ForumTopic(
  id: (json['id'] as num).toInt(),
  creatorId: (json['creator_id'] as num).toInt(),
  updaterId: (json['updater_id'] as num).toInt(),
  title: json['title'] as String,
  responseCount: (json['response_count'] as num).toInt(),
  isSticky: json['is_sticky'] as bool,
  isLocked: json['is_locked'] as bool,
  isHidden: json['is_hidden'] as bool,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  categoryId: (json['category_id'] as num).toInt(),
  creatorName: json['creator_name'] as String?,
  updaterName: json['updater_name'] as String?,
);

Map<String, dynamic> _$ForumTopicToJson(ForumTopic instance) =>
    <String, dynamic>{
      'id': instance.id,
      'creator_id': instance.creatorId,
      'updater_id': instance.updaterId,
      'title': instance.title,
      'response_count': instance.responseCount,
      'is_sticky': instance.isSticky,
      'is_locked': instance.isLocked,
      'is_hidden': instance.isHidden,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'category_id': instance.categoryId,
      'creator_name': instance.creatorName,
      'updater_name': instance.updaterName,
    };
