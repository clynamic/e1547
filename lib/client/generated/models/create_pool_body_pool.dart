// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'pool_category.dart';

part 'create_pool_body_pool.g.dart';

@JsonSerializable()
class CreatePoolBodyPool {
  const CreatePoolBodyPool({
    required this.name,
    this.description,
    this.category,
    this.isActive,
    this.postIds,
  });
  
  factory CreatePoolBodyPool.fromJson(Map<String, Object?> json) => _$CreatePoolBodyPoolFromJson(json);
  
  final String name;
  final String? description;
  final PoolCategory? category;
  @JsonKey(name: 'is_active')
  final bool? isActive;
  @JsonKey(name: 'post_ids')
  final List<int>? postIds;

  Map<String, Object?> toJson() => _$CreatePoolBodyPoolToJson(this);
}
