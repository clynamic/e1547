// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pool_version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PoolVersion _$PoolVersionFromJson(Map<String, dynamic> json) => PoolVersion(
  id: (json['id'] as num).toInt(),
  poolId: (json['pool_id'] as num).toInt(),
  postIds: (json['post_ids'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  addedPostIds: (json['added_post_ids'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  removedPostIds: (json['removed_post_ids'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  version: (json['version'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  updaterId: (json['updater_id'] as num?)?.toInt(),
  description: json['description'] as String?,
  descriptionChanged: json['description_changed'] as bool?,
  name: json['name'] as String?,
  nameChanged: json['name_changed'] as bool?,
  isActive: json['is_active'] as bool?,
  category: json['category'] as String?,
);

Map<String, dynamic> _$PoolVersionToJson(PoolVersion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pool_id': instance.poolId,
      'post_ids': instance.postIds,
      'added_post_ids': instance.addedPostIds,
      'removed_post_ids': instance.removedPostIds,
      'updater_id': instance.updaterId,
      'description': instance.description,
      'description_changed': instance.descriptionChanged,
      'name': instance.name,
      'name_changed': instance.nameChanged,
      'is_active': instance.isActive,
      'category': instance.category,
      'version': instance.version,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
