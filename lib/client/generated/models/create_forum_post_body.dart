// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'create_forum_post_body_forum_post.dart';

part 'create_forum_post_body.g.dart';

@JsonSerializable()
class CreateForumPostBody {
  const CreateForumPostBody({
    required this.forumPost,
  });
  
  factory CreateForumPostBody.fromJson(Map<String, Object?> json) => _$CreateForumPostBodyFromJson(json);
  
  @JsonKey(name: 'forum_post')
  final CreateForumPostBodyForumPost forumPost;

  Map<String, Object?> toJson() => _$CreateForumPostBodyToJson(this);
}
