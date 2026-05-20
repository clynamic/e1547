// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_comment_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCommentBody _$CreateCommentBodyFromJson(Map<String, dynamic> json) =>
    CreateCommentBody(
      comment: CreateCommentBodyComment.fromJson(
        json['comment'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$CreateCommentBodyToJson(CreateCommentBody instance) =>
    <String, dynamic>{'comment': instance.comment};
