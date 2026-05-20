// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_user_body_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateUserBodyUser _$CreateUserBodyUserFromJson(Map<String, dynamic> json) =>
    CreateUserBodyUser(
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      passwordConfirmation: json['password_confirmation'] as String,
    );

Map<String, dynamic> _$CreateUserBodyUserToJson(CreateUserBodyUser instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'password_confirmation': instance.passwordConfirmation,
    };
