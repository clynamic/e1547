// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForumPost _$ForumPostFromJson(Map<String, dynamic> json) => ForumPost(
  id: (json['id'] as num).toInt(),
  topicId: (json['topic_id'] as num).toInt(),
  creatorId: (json['creator_id'] as num).toInt(),
  updaterId: (json['updater_id'] as num).toInt(),
  body: json['body'] as String,
  isHidden: json['is_hidden'] as bool,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  warningType: (json['warning_type'] as num?)?.toInt(),
  warningUserId: (json['warning_user_id'] as num?)?.toInt(),
  creatorName: json['creator_name'] as String?,
  updaterName: json['updater_name'] as String?,
);

Map<String, dynamic> _$ForumPostToJson(ForumPost instance) => <String, dynamic>{
  'id': instance.id,
  'topic_id': instance.topicId,
  'creator_id': instance.creatorId,
  'updater_id': instance.updaterId,
  'body': instance.body,
  'is_hidden': instance.isHidden,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'warning_type': instance.warningType,
  'warning_user_id': instance.warningUserId,
  'creator_name': instance.creatorName,
  'updater_name': instance.updaterName,
};
