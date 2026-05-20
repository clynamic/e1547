// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'post_vote.g.dart';

/// A vote on a post.
@JsonSerializable()
class PostVote {
  const PostVote({
    required this.id,
    required this.postId,
    required this.userId,
    required this.score,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory PostVote.fromJson(Map<String, Object?> json) => _$PostVoteFromJson(json);
  
  /// The unique ID of the vote
  final int id;

  /// The ID of the voted post
  @JsonKey(name: 'post_id')
  final int postId;

  /// The ID of the voting user
  @JsonKey(name: 'user_id')
  final int userId;

  /// The vote score (1, 0, or -1)
  final int score;

  /// When the vote was cast
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// When the vote was last updated
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Map<String, Object?> toJson() => _$PostVoteToJson(this);
}
