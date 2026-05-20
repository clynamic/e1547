// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'update_user_body_user.dart';

part 'update_user_body.g.dart';

@JsonSerializable()
class UpdateUserBody {
  const UpdateUserBody({
    required this.user,
  });
  
  factory UpdateUserBody.fromJson(Map<String, Object?> json) => _$UpdateUserBodyFromJson(json);
  
  final UpdateUserBodyUser user;

  Map<String, Object?> toJson() => _$UpdateUserBodyToJson(this);
}
