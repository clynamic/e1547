// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_post_flag_body_post_flag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePostFlagBodyPostFlag _$CreatePostFlagBodyPostFlagFromJson(
  Map<String, dynamic> json,
) => CreatePostFlagBodyPostFlag(
  postId: (json['post_id'] as num).toInt(),
  reasonName: json['reason_name'] as String,
  parentId: (json['parent_id'] as num?)?.toInt(),
  note: json['note'] as String?,
);

Map<String, dynamic> _$CreatePostFlagBodyPostFlagToJson(
  CreatePostFlagBodyPostFlag instance,
) => <String, dynamic>{
  'post_id': instance.postId,
  'reason_name': instance.reasonName,
  'parent_id': instance.parentId,
  'note': instance.note,
};
