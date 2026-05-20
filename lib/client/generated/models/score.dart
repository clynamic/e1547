// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'score.g.dart';

@JsonSerializable()
class Score {
  const Score({
    required this.up,
    required this.down,
    required this.total,
  });
  
  factory Score.fromJson(Map<String, Object?> json) => _$ScoreFromJson(json);
  
  /// The number of upvotes on the post
  final int up;

  /// The number of downvotes on the post
  final int down;

  /// The total score (upvotes minus downvotes)
  final int total;

  Map<String, Object?> toJson() => _$ScoreToJson(this);
}
