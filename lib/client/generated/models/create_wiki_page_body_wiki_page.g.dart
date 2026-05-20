// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_wiki_page_body_wiki_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateWikiPageBodyWikiPage _$CreateWikiPageBodyWikiPageFromJson(
  Map<String, dynamic> json,
) => CreateWikiPageBodyWikiPage(
  title: json['title'] as String,
  body: json['body'] as String,
  categoryId: (json['category_id'] as num?)?.toInt(),
  editReason: json['edit_reason'] as String?,
  parent: json['parent'] as String?,
  isLocked: json['is_locked'] as bool?,
  isDeleted: json['is_deleted'] as bool?,
);

Map<String, dynamic> _$CreateWikiPageBodyWikiPageToJson(
  CreateWikiPageBodyWikiPage instance,
) => <String, dynamic>{
  'title': instance.title,
  'body': instance.body,
  'category_id': instance.categoryId,
  'edit_reason': instance.editReason,
  'parent': instance.parent,
  'is_locked': instance.isLocked,
  'is_deleted': instance.isDeleted,
};
