// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'create_forum_topic_body_forum_topic.dart';

part 'create_forum_topic_body.g.dart';

@JsonSerializable()
class CreateForumTopicBody {
  const CreateForumTopicBody({
    required this.forumTopic,
  });
  
  factory CreateForumTopicBody.fromJson(Map<String, Object?> json) => _$CreateForumTopicBodyFromJson(json);
  
  @JsonKey(name: 'forum_topic')
  final CreateForumTopicBodyForumTopic forumTopic;

  Map<String, Object?> toJson() => _$CreateForumTopicBodyToJson(this);
}
