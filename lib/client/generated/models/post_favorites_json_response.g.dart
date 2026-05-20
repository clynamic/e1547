// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_favorites_json_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostFavoritesJsonResponse _$PostFavoritesJsonResponseFromJson(
  Map<String, dynamic> json,
) => PostFavoritesJsonResponse(
  postId: (json['post_id'] as num?)?.toInt(),
  favoriteCount: (json['favorite_count'] as num?)?.toInt(),
);

Map<String, dynamic> _$PostFavoritesJsonResponseToJson(
  PostFavoritesJsonResponse instance,
) => <String, dynamic>{
  'post_id': instance.postId,
  'favorite_count': instance.favoriteCount,
};
