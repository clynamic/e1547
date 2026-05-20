// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relationships.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Relationships _$RelationshipsFromJson(Map<String, dynamic> json) =>
    Relationships(
      hasChildren: json['has_children'] as bool,
      hasActiveChildren: json['has_active_children'] as bool,
      children: (json['children'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      parentId: (json['parent_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RelationshipsToJson(Relationships instance) =>
    <String, dynamic>{
      'parent_id': instance.parentId,
      'has_children': instance.hasChildren,
      'has_active_children': instance.hasActiveChildren,
      'children': instance.children,
    };
