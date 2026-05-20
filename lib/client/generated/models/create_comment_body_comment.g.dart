// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_comment_body_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCommentBodyComment _$CreateCommentBodyCommentFromJson(
  Map<String, dynamic> json,
) => CreateCommentBodyComment(
  body: json['body'] as String,
  postId: (json['post_id'] as num).toInt(),
  doNotBumpPost: json['do_not_bump_post'] as bool?,
  isSticky: json['is_sticky'] as bool?,
  isHidden: json['is_hidden'] as bool?,
);

Map<String, dynamic> _$CreateCommentBodyCommentToJson(
  CreateCommentBodyComment instance,
) => <String, dynamic>{
  'body': instance.body,
  'post_id': instance.postId,
  'do_not_bump_post': instance.doNotBumpPost,
  'is_sticky': instance.isSticky,
  'is_hidden': instance.isHidden,
};
