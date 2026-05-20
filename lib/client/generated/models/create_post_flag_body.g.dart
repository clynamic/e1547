// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_post_flag_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePostFlagBody _$CreatePostFlagBodyFromJson(Map<String, dynamic> json) =>
    CreatePostFlagBody(
      postFlag: CreatePostFlagBodyPostFlag.fromJson(
        json['post_flag'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$CreatePostFlagBodyToJson(CreatePostFlagBody instance) =>
    <String, dynamic>{'post_flag': instance.postFlag};
