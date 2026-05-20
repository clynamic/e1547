// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_vote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostVote _$PostVoteFromJson(Map<String, dynamic> json) => PostVote(
  id: (json['id'] as num).toInt(),
  postId: (json['post_id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  score: (json['score'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$PostVoteToJson(PostVote instance) => <String, dynamic>{
  'id': instance.id,
  'post_id': instance.postId,
  'user_id': instance.userId,
  'score': instance.score,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
