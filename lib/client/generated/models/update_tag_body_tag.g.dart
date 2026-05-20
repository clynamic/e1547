// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_tag_body_tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateTagBodyTag _$UpdateTagBodyTagFromJson(Map<String, dynamic> json) =>
    UpdateTagBodyTag(
      category: (json['category'] as num?)?.toInt(),
      isLocked: json['is_locked'] as bool?,
    );

Map<String, dynamic> _$UpdateTagBodyTagToJson(UpdateTagBodyTag instance) =>
    <String, dynamic>{
      'category': instance.category,
      'is_locked': instance.isLocked,
    };
