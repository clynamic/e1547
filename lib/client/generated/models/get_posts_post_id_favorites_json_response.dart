// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'get_posts_post_id_favorites_json_response.g.dart';

@JsonSerializable()
class GetPostsPostIdFavoritesJsonResponse {
  const GetPostsPostIdFavoritesJsonResponse({
    this.id,
    this.name,
  });
  
  factory GetPostsPostIdFavoritesJsonResponse.fromJson(Map<String, Object?> json) => _$GetPostsPostIdFavoritesJsonResponseFromJson(json);
  
  /// The user ID
  final int? id;

  /// The username
  final String? name;

  Map<String, Object?> toJson() => _$GetPostsPostIdFavoritesJsonResponseToJson(this);
}
