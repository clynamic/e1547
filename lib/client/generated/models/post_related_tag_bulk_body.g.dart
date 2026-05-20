// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_related_tag_bulk_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostRelatedTagBulkBody _$PostRelatedTagBulkBodyFromJson(
  Map<String, dynamic> json,
) => PostRelatedTagBulkBody(
  query: json['query'] as String?,
  categoryId: (json['category_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$PostRelatedTagBulkBodyToJson(
  PostRelatedTagBulkBody instance,
) => <String, dynamic>{
  'query': instance.query,
  'category_id': instance.categoryId,
};
