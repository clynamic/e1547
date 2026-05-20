// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_posts_id_json_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetPostsIdJsonResponse _$GetPostsIdJsonResponseFromJson(
  Map<String, dynamic> json,
) => GetPostsIdJsonResponse(
  post: json['post'] == null
      ? null
      : Post.fromJson(json['post'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GetPostsIdJsonResponseToJson(
  GetPostsIdJsonResponse instance,
) => <String, dynamic>{'post': instance.post};
