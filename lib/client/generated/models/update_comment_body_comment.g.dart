// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_comment_body_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateCommentBodyComment _$UpdateCommentBodyCommentFromJson(
  Map<String, dynamic> json,
) => UpdateCommentBodyComment(
  body: json['body'] as String?,
  isSticky: json['is_sticky'] as bool?,
  isHidden: json['is_hidden'] as bool?,
);

Map<String, dynamic> _$UpdateCommentBodyCommentToJson(
  UpdateCommentBodyComment instance,
) => <String, dynamic>{
  'body': instance.body,
  'is_sticky': instance.isSticky,
  'is_hidden': instance.isHidden,
};
