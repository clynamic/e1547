// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wiki_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WikiPage _$WikiPageFromJson(Map<String, dynamic> json) => WikiPage(
  id: (json['id'] as num).toInt(),
  creatorId: (json['creator_id'] as num).toInt(),
  title: json['title'] as String,
  body: json['body'] as String,
  isLocked: json['is_locked'] as bool,
  isDeleted: json['is_deleted'] as bool,
  otherNames: (json['other_names'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  creatorName: json['creator_name'] as String?,
  updaterId: (json['updater_id'] as num?)?.toInt(),
  parent: json['parent'] as String?,
  categoryId: (json['category_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$WikiPageToJson(WikiPage instance) => <String, dynamic>{
  'id': instance.id,
  'creator_id': instance.creatorId,
  'creator_name': instance.creatorName,
  'title': instance.title,
  'body': instance.body,
  'is_locked': instance.isLocked,
  'is_deleted': instance.isDeleted,
  'other_names': instance.otherNames,
  'updater_id': instance.updaterId,
  'parent': instance.parent,
  'category_id': instance.categoryId,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
