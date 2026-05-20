// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'lock_post_votes_body.g.dart';

@JsonSerializable()
class LockPostVotesBody {
  const LockPostVotesBody({
    required this.ids,
  });
  
  factory LockPostVotesBody.fromJson(Map<String, Object?> json) => _$LockPostVotesBodyFromJson(json);
  
  /// Comma-separated list of post vote IDs to lock
  final String ids;

  Map<String, Object?> toJson() => _$LockPostVotesBodyToJson(this);
}
