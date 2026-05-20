// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_favorites_id_json_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteFavoritesIdJsonResponse _$DeleteFavoritesIdJsonResponseFromJson(
  Map<String, dynamic> json,
) => DeleteFavoritesIdJsonResponse(
  postId: (json['post_id'] as num?)?.toInt(),
  favoriteCount: (json['favorite_count'] as num?)?.toInt(),
);

Map<String, dynamic> _$DeleteFavoritesIdJsonResponseToJson(
  DeleteFavoritesIdJsonResponse instance,
) => <String, dynamic>{
  'post_id': instance.postId,
  'favorite_count': instance.favoriteCount,
};
