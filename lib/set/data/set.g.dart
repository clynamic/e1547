// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostSet _$PostSetFromJson(Map<String, dynamic> json) => _PostSet(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  shortname: json['shortname'] as String,
  description: json['description'] as String,
  public: json['public'] as bool,
  creatorId: (json['creator_id'] as num).toInt(),
  postIds: (json['post_ids'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  postCount: (json['post_count'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$PostSetToJson(_PostSet instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'shortname': instance.shortname,
  'description': instance.description,
  'public': instance.public,
  'creator_id': instance.creatorId,
  'post_ids': instance.postIds,
  'post_count': instance.postCount,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
