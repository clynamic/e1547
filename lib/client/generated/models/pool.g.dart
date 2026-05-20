// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pool.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pool _$PoolFromJson(Map<String, dynamic> json) => Pool(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  creatorId: (json['creator_id'] as num).toInt(),
  isActive: json['is_active'] as bool,
  postIds: (json['post_ids'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  category: PoolCategory.fromJson(json['category'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  creatorName: json['creator_name'] as String?,
  description: json['description'] as String?,
  postCount: (json['post_count'] as num?)?.toInt(),
);

Map<String, dynamic> _$PoolToJson(Pool instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'creator_id': instance.creatorId,
  'creator_name': instance.creatorName,
  'description': instance.description,
  'is_active': instance.isActive,
  'post_ids': instance.postIds,
  'post_count': instance.postCount,
  'category': _$PoolCategoryEnumMap[instance.category]!,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};

const _$PoolCategoryEnumMap = {
  PoolCategory.series: 'series',
  PoolCategory.collection: 'collection',
  PoolCategory.$unknown: r'$unknown',
};
