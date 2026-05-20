// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'create_post_flag_body_post_flag.dart';

part 'create_post_flag_body.g.dart';

@JsonSerializable()
class CreatePostFlagBody {
  const CreatePostFlagBody({
    required this.postFlag,
  });
  
  factory CreatePostFlagBody.fromJson(Map<String, Object?> json) => _$CreatePostFlagBodyFromJson(json);
  
  @JsonKey(name: 'post_flag')
  final CreatePostFlagBodyPostFlag postFlag;

  Map<String, Object?> toJson() => _$CreatePostFlagBodyToJson(this);
}
