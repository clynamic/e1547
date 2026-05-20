// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_flag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostFlag _$PostFlagFromJson(Map<String, dynamic> json) => PostFlag(
  id: (json['id'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  postId: (json['post_id'] as num).toInt(),
  reason: json['reason'] as String,
  creatorId: (json['creator_id'] as num).toInt(),
  isResolved: json['is_resolved'] as bool,
  updatedAt: DateTime.parse(json['updated_at'] as String),
  isDeletion: json['is_deletion'] as bool,
  type: PostFlagType.fromJson(json['type'] as String),
  note: json['note'] as String?,
);

Map<String, dynamic> _$PostFlagToJson(PostFlag instance) => <String, dynamic>{
  'id': instance.id,
  'created_at': instance.createdAt.toIso8601String(),
  'post_id': instance.postId,
  'reason': instance.reason,
  'creator_id': instance.creatorId,
  'is_resolved': instance.isResolved,
  'updated_at': instance.updatedAt.toIso8601String(),
  'is_deletion': instance.isDeletion,
  'type': _$PostFlagTypeEnumMap[instance.type]!,
  'note': instance.note,
};

const _$PostFlagTypeEnumMap = {
  PostFlagType.flag: 'flag',
  PostFlagType.deletion: 'deletion',
  PostFlagType.$unknown: r'$unknown',
};
