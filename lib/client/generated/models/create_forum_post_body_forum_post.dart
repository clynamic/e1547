// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'create_forum_post_body_forum_post.g.dart';

@JsonSerializable()
class CreateForumPostBodyForumPost {
  const CreateForumPostBodyForumPost({
    required this.body,
    required this.topicId,
  });
  
  factory CreateForumPostBodyForumPost.fromJson(Map<String, Object?> json) => _$CreateForumPostBodyForumPostFromJson(json);
  
  /// The forum post body text
  final String body;

  /// The ID of the forum topic to post in
  @JsonKey(name: 'topic_id')
  final int topicId;

  Map<String, Object?> toJson() => _$CreateForumPostBodyForumPostToJson(this);
}
