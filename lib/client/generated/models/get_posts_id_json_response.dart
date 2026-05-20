// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'post.dart';

part 'get_posts_id_json_response.g.dart';

@JsonSerializable()
class GetPostsIdJsonResponse {
  const GetPostsIdJsonResponse({
    this.post,
  });
  
  factory GetPostsIdJsonResponse.fromJson(Map<String, Object?> json) => _$GetPostsIdJsonResponseFromJson(json);
  
  final Post? post;

  Map<String, Object?> toJson() => _$GetPostsIdJsonResponseToJson(this);
}
