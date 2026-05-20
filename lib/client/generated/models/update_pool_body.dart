// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'update_pool_body_pool.dart';

part 'update_pool_body.g.dart';

@JsonSerializable()
class UpdatePoolBody {
  const UpdatePoolBody({
    required this.pool,
  });
  
  factory UpdatePoolBody.fromJson(Map<String, Object?> json) => _$UpdatePoolBodyFromJson(json);
  
  final UpdatePoolBodyPool pool;

  Map<String, Object?> toJson() => _$UpdatePoolBodyToJson(this);
}
