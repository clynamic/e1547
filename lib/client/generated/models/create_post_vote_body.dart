// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'create_post_vote_body_score.dart';

part 'create_post_vote_body.g.dart';

@JsonSerializable()
class CreatePostVoteBody {
  const CreatePostVoteBody({
    required this.score,
    this.noUnvote,
  });
  
  factory CreatePostVoteBody.fromJson(Map<String, Object?> json) => _$CreatePostVoteBodyFromJson(json);
  
  final CreatePostVoteBodyScore score;

  /// If true, do not remove an existing identical vote
  @JsonKey(name: 'no_unvote')
  final bool? noUnvote;

  Map<String, Object?> toJson() => _$CreatePostVoteBodyToJson(this);
}
