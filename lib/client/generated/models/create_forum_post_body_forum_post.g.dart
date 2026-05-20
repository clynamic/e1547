// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_forum_post_body_forum_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateForumPostBodyForumPost _$CreateForumPostBodyForumPostFromJson(
  Map<String, dynamic> json,
) => CreateForumPostBodyForumPost(
  body: json['body'] as String,
  topicId: (json['topic_id'] as num).toInt(),
);

Map<String, dynamic> _$CreateForumPostBodyForumPostToJson(
  CreateForumPostBodyForumPost instance,
) => <String, dynamic>{'body': instance.body, 'topic_id': instance.topicId};
