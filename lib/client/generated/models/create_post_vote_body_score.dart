// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

/// The vote score (1 for upvote, -1 for downvote)
@JsonEnum()
enum CreatePostVoteBodyScore {
  @JsonValue(1)
  value1(1),
  @JsonValue(-1)
  valueMinus1(-1),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const CreatePostVoteBodyScore(this.json);

  factory CreatePostVoteBodyScore.fromJson(int json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final int? json;

  @override
  String toString() => json?.toString() ?? super.toString();
  /// Returns all defined enum values excluding the $unknown value.
  static List<CreatePostVoteBodyScore> get $valuesDefined => values.where((value) => value != $unknown).toList();
}
