// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_comment_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateCommentBody _$UpdateCommentBodyFromJson(Map<String, dynamic> json) =>
    UpdateCommentBody(
      comment: UpdateCommentBodyComment.fromJson(
        json['comment'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$UpdateCommentBodyToJson(UpdateCommentBody instance) =>
    <String, dynamic>{'comment': instance.comment};
