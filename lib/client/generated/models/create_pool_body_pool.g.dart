// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_pool_body_pool.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePoolBodyPool _$CreatePoolBodyPoolFromJson(Map<String, dynamic> json) =>
    CreatePoolBodyPool(
      name: json['name'] as String,
      description: json['description'] as String?,
      category: json['category'] == null
          ? null
          : PoolCategory.fromJson(json['category'] as String),
      isActive: json['is_active'] as bool?,
      postIds: (json['post_ids'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$CreatePoolBodyPoolToJson(CreatePoolBodyPool instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'category': _$PoolCategoryEnumMap[instance.category],
      'is_active': instance.isActive,
      'post_ids': instance.postIds,
    };

const _$PoolCategoryEnumMap = {
  PoolCategory.series: 'series',
  PoolCategory.collection: 'collection',
  PoolCategory.$unknown: r'$unknown',
};
