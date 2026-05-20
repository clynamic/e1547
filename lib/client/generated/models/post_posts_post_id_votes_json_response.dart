// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'post_posts_post_id_votes_json_response.g.dart';

@JsonSerializable()
class PostPostsPostIdVotesJsonResponse {
  const PostPostsPostIdVotesJsonResponse({
    this.score,
    this.up,
    this.down,
    this.ourScore,
  });
  
  factory PostPostsPostIdVotesJsonResponse.fromJson(Map<String, Object?> json) => _$PostPostsPostIdVotesJsonResponseFromJson(json);
  
  /// The new total score of the post
  final int? score;

  /// The new upvote score of the post
  final int? up;

  /// The new downvote score of the post
  final int? down;

  /// The current user's vote score (0 if unvoted)
  @JsonKey(name: 'our_score')
  final int? ourScore;

  Map<String, Object?> toJson() => _$PostPostsPostIdVotesJsonResponseToJson(this);
}
