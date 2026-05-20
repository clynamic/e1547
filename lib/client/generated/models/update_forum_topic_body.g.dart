// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_forum_topic_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateForumTopicBody _$UpdateForumTopicBodyFromJson(
  Map<String, dynamic> json,
) => UpdateForumTopicBody(
  forumTopic: UpdateForumTopicBodyForumTopic.fromJson(
    json['forum_topic'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$UpdateForumTopicBodyToJson(
  UpdateForumTopicBody instance,
) => <String, dynamic>{'forum_topic': instance.forumTopic};
