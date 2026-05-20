// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  name: json['name'] as String,
  level: (json['level'] as num).toInt(),
  baseUploadLimit: (json['base_upload_limit'] as num).toInt(),
  postUploadCount: (json['post_upload_count'] as num).toInt(),
  postUpdateCount: (json['post_update_count'] as num).toInt(),
  noteUpdateCount: (json['note_update_count'] as num).toInt(),
  isBanned: json['is_banned'] as bool,
  canApprovePosts: json['can_approve_posts'] as bool,
  canUploadFree: json['can_upload_free'] as bool,
  levelString: json['level_string'] as String,
  avatarId: (json['avatar_id'] as num?)?.toInt(),
  isVerified: json['is_verified'] as bool?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'created_at': instance.createdAt.toIso8601String(),
  'name': instance.name,
  'level': instance.level,
  'base_upload_limit': instance.baseUploadLimit,
  'post_upload_count': instance.postUploadCount,
  'post_update_count': instance.postUpdateCount,
  'note_update_count': instance.noteUpdateCount,
  'is_banned': instance.isBanned,
  'can_approve_posts': instance.canApprovePosts,
  'can_upload_free': instance.canUploadFree,
  'level_string': instance.levelString,
  'avatar_id': instance.avatarId,
  'is_verified': instance.isVerified,
};
