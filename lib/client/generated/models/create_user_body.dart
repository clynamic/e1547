// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'create_user_body_user.dart';

part 'create_user_body.g.dart';

@JsonSerializable()
class CreateUserBody {
  const CreateUserBody({
    required this.user,
  });
  
  factory CreateUserBody.fromJson(Map<String, Object?> json) => _$CreateUserBodyFromJson(json);
  
  final CreateUserBodyUser user;

  Map<String, Object?> toJson() => _$CreateUserBodyToJson(this);
}
