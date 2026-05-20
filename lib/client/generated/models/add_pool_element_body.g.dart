// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_pool_element_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddPoolElementBody _$AddPoolElementBodyFromJson(Map<String, dynamic> json) =>
    AddPoolElementBody(
      postId: (json['post_id'] as num).toInt(),
      poolId: (json['pool_id'] as num?)?.toInt(),
      poolName: json['pool_name'] as String?,
    );

Map<String, dynamic> _$AddPoolElementBodyToJson(AddPoolElementBody instance) =>
    <String, dynamic>{
      'pool_id': instance.poolId,
      'pool_name': instance.poolName,
      'post_id': instance.postId,
    };
