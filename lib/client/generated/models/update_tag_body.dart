// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'update_tag_body_tag.dart';

part 'update_tag_body.g.dart';

@JsonSerializable()
class UpdateTagBody {
  const UpdateTagBody({
    required this.tag,
  });
  
  factory UpdateTagBody.fromJson(Map<String, Object?> json) => _$UpdateTagBodyFromJson(json);
  
  final UpdateTagBodyTag tag;

  Map<String, Object?> toJson() => _$UpdateTagBodyToJson(this);
}
