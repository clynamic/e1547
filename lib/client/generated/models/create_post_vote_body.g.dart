// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_post_vote_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePostVoteBody _$CreatePostVoteBodyFromJson(Map<String, dynamic> json) =>
    CreatePostVoteBody(
      score: CreatePostVoteBodyScore.fromJson((json['score'] as num).toInt()),
      noUnvote: json['no_unvote'] as bool?,
    );

Map<String, dynamic> _$CreatePostVoteBodyToJson(CreatePostVoteBody instance) =>
    <String, dynamic>{
      'score': _$CreatePostVoteBodyScoreEnumMap[instance.score]!,
      'no_unvote': instance.noUnvote,
    };

const _$CreatePostVoteBodyScoreEnumMap = {
  CreatePostVoteBodyScore.value1: 1,
  CreatePostVoteBodyScore.valueMinus1: -1,
  CreatePostVoteBodyScore.$unknown: r'$unknown',
};
