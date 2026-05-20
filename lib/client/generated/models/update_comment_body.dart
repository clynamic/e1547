// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'update_comment_body_comment.dart';

part 'update_comment_body.g.dart';

@JsonSerializable()
class UpdateCommentBody {
  const UpdateCommentBody({
    required this.comment,
  });
  
  factory UpdateCommentBody.fromJson(Map<String, Object?> json) => _$UpdateCommentBodyFromJson(json);
  
  final UpdateCommentBodyComment comment;

  Map<String, Object?> toJson() => _$UpdateCommentBodyToJson(this);
}
