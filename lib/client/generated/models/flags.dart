// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'flags.g.dart';

@JsonSerializable()
class Flags {
  const Flags({
    required this.pending,
    required this.flagged,
    required this.noteLocked,
    required this.statusLocked,
    required this.ratingLocked,
    required this.deleted,
  });
  
  factory Flags.fromJson(Map<String, Object?> json) => _$FlagsFromJson(json);
  
  /// Whether the post is pending approval
  final bool pending;

  /// Whether the post is flagged
  final bool flagged;

  /// Whether notes on the post are locked
  @JsonKey(name: 'note_locked')
  final bool noteLocked;

  /// Whether the status of the post is locked
  @JsonKey(name: 'status_locked')
  final bool statusLocked;

  /// Whether the rating of the post is locked
  @JsonKey(name: 'rating_locked')
  final bool ratingLocked;

  /// Whether the post is deleted
  final bool deleted;

  Map<String, Object?> toJson() => _$FlagsToJson(this);
}
