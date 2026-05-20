// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_user_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateUserBody _$CreateUserBodyFromJson(Map<String, dynamic> json) =>
    CreateUserBody(
      user: CreateUserBodyUser.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateUserBodyToJson(CreateUserBody instance) =>
    <String, dynamic>{'user': instance.user};
