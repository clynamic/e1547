// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_wiki_page_body_wiki_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateWikiPageBodyWikiPage _$UpdateWikiPageBodyWikiPageFromJson(
  Map<String, dynamic> json,
) => UpdateWikiPageBodyWikiPage(
  body: json['body'] as String?,
  categoryId: (json['category_id'] as num?)?.toInt(),
  editReason: json['edit_reason'] as String?,
  parent: json['parent'] as String?,
  title: json['title'] as String?,
  isLocked: json['is_locked'] as bool?,
  isDeleted: json['is_deleted'] as bool?,
);

Map<String, dynamic> _$UpdateWikiPageBodyWikiPageToJson(
  UpdateWikiPageBodyWikiPage instance,
) => <String, dynamic>{
  'body': instance.body,
  'category_id': instance.categoryId,
  'edit_reason': instance.editReason,
  'parent': instance.parent,
  'title': instance.title,
  'is_locked': instance.isLocked,
  'is_deleted': instance.isDeleted,
};
