// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_posts_post_id_votes_json_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostPostsPostIdVotesJsonResponse _$PostPostsPostIdVotesJsonResponseFromJson(
  Map<String, dynamic> json,
) => PostPostsPostIdVotesJsonResponse(
  score: (json['score'] as num?)?.toInt(),
  up: (json['up'] as num?)?.toInt(),
  down: (json['down'] as num?)?.toInt(),
  ourScore: (json['our_score'] as num?)?.toInt(),
);

Map<String, dynamic> _$PostPostsPostIdVotesJsonResponseToJson(
  PostPostsPostIdVotesJsonResponse instance,
) => <String, dynamic>{
  'score': instance.score,
  'up': instance.up,
  'down': instance.down,
  'our_score': instance.ourScore,
};
