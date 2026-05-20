// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'post_comments_id_warning_json_response.g.dart';

@JsonSerializable()
class PostCommentsIdWarningJsonResponse {
  const PostCommentsIdWarningJsonResponse({
    this.html,
    this.posts,
  });
  
  factory PostCommentsIdWarningJsonResponse.fromJson(Map<String, Object?> json) => _$PostCommentsIdWarningJsonResponseFromJson(json);
  
  final String? html;
  final dynamic posts;

  Map<String, Object?> toJson() => _$PostCommentsIdWarningJsonResponseToJson(this);
}
