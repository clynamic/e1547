// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tag _$TagFromJson(Map<String, dynamic> json) => Tag(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  postCount: (json['post_count'] as num).toInt(),
  category: (json['category'] as num).toInt(),
  isLocked: json['is_locked'] as bool,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  relatedTags: json['related_tags'] as String?,
  relatedTagsUpdatedAt: json['related_tags_updated_at'] == null
      ? null
      : DateTime.parse(json['related_tags_updated_at'] as String),
);

Map<String, dynamic> _$TagToJson(Tag instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'post_count': instance.postCount,
  'category': instance.category,
  'related_tags': instance.relatedTags,
  'related_tags_updated_at': instance.relatedTagsUpdatedAt?.toIso8601String(),
  'is_locked': instance.isLocked,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
