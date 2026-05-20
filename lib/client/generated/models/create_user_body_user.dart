// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'create_user_body_user.g.dart';

@JsonSerializable()
class CreateUserBodyUser {
  const CreateUserBodyUser({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });
  
  factory CreateUserBodyUser.fromJson(Map<String, Object?> json) => _$CreateUserBodyUserFromJson(json);
  
  /// The desired username
  final String name;

  /// The user's email address
  final String email;

  /// The password for the account
  final String password;

  /// Password confirmation
  @JsonKey(name: 'password_confirmation')
  final String passwordConfirmation;

  Map<String, Object?> toJson() => _$CreateUserBodyUserToJson(this);
}
