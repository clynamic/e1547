// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'create_comment_body_comment.dart';

part 'create_comment_body.g.dart';

@JsonSerializable()
class CreateCommentBody {
  const CreateCommentBody({
    required this.comment,
  });
  
  factory CreateCommentBody.fromJson(Map<String, Object?> json) => _$CreateCommentBodyFromJson(json);
  
  final CreateCommentBodyComment comment;

  Map<String, Object?> toJson() => _$CreateCommentBodyToJson(this);
}
