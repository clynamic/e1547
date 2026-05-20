// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'related_tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RelatedTag _$RelatedTagFromJson(Map<String, dynamic> json) => RelatedTag(
  query: json['query'] as String?,
  category: (json['category'] as num?)?.toInt(),
  tags: (json['tags'] as List<dynamic>?)
      ?.map((e) => (e as List<dynamic>).map((e) => e as String).toList())
      .toList(),
  wikiPageTags: (json['wiki_page_tags'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$RelatedTagToJson(RelatedTag instance) =>
    <String, dynamic>{
      'query': instance.query,
      'category': instance.category,
      'tags': instance.tags,
      'wiki_page_tags': instance.wikiPageTags,
    };
