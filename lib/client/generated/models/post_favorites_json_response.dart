// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'post_favorites_json_response.g.dart';

@JsonSerializable()
class PostFavoritesJsonResponse {
  const PostFavoritesJsonResponse({
    this.postId,
    this.favoriteCount,
  });
  
  factory PostFavoritesJsonResponse.fromJson(Map<String, Object?> json) => _$PostFavoritesJsonResponseFromJson(json);
  
  /// The ID of the favorited post
  @JsonKey(name: 'post_id')
  final int? postId;

  /// The new favorite count for the post
  @JsonKey(name: 'favorite_count')
  final int? favoriteCount;

  Map<String, Object?> toJson() => _$PostFavoritesJsonResponseToJson(this);
}
