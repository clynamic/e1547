// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'post_forum_posts_id_warning_json_response.g.dart';

@JsonSerializable()
class PostForumPostsIdWarningJsonResponse {
  const PostForumPostsIdWarningJsonResponse({
    this.html,
    this.posts,
  });
  
  factory PostForumPostsIdWarningJsonResponse.fromJson(Map<String, Object?> json) => _$PostForumPostsIdWarningJsonResponseFromJson(json);
  
  final String? html;
  final dynamic posts;

  Map<String, Object?> toJson() => _$PostForumPostsIdWarningJsonResponseToJson(this);
}
