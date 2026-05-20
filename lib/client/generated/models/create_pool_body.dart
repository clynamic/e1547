// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'create_pool_body_pool.dart';

part 'create_pool_body.g.dart';

@JsonSerializable()
class CreatePoolBody {
  const CreatePoolBody({
    required this.pool,
  });
  
  factory CreatePoolBody.fromJson(Map<String, Object?> json) => _$CreatePoolBodyFromJson(json);
  
  final CreatePoolBodyPool pool;

  Map<String, Object?> toJson() => _$CreatePoolBodyToJson(this);
}
