// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_forum_topic_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateForumTopicBody _$CreateForumTopicBodyFromJson(
  Map<String, dynamic> json,
) => CreateForumTopicBody(
  forumTopic: CreateForumTopicBodyForumTopic.fromJson(
    json['forum_topic'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$CreateForumTopicBodyToJson(
  CreateForumTopicBody instance,
) => <String, dynamic>{'forum_topic': instance.forumTopic};
