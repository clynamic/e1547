// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'update_forum_topic_body_forum_topic.dart';

part 'update_forum_topic_body.g.dart';

@JsonSerializable()
class UpdateForumTopicBody {
  const UpdateForumTopicBody({
    required this.forumTopic,
  });
  
  factory UpdateForumTopicBody.fromJson(Map<String, Object?> json) => _$UpdateForumTopicBodyFromJson(json);
  
  @JsonKey(name: 'forum_topic')
  final UpdateForumTopicBodyForumTopic forumTopic;

  Map<String, Object?> toJson() => _$UpdateForumTopicBodyToJson(this);
}
