// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'pool_category.dart';

part 'pool.g.dart';

@JsonSerializable()
class Pool {
  const Pool({
    required this.id,
    required this.name,
    required this.creatorId,
    required this.isActive,
    required this.postIds,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    this.creatorName,
    this.description,
    this.postCount,
  });
  
  factory Pool.fromJson(Map<String, Object?> json) => _$PoolFromJson(json);
  
  /// The unique ID of the pool
  final int id;

  /// The name of the pool
  final String name;

  /// The ID of the pool creator
  @JsonKey(name: 'creator_id')
  final int creatorId;

  /// The username of the pool creator
  @JsonKey(name: 'creator_name')
  final String? creatorName;

  /// The pool description
  final String? description;

  /// Whether the pool is active
  @JsonKey(name: 'is_active')
  final bool isActive;

  /// Ordered array of post IDs in the pool
  @JsonKey(name: 'post_ids')
  final List<int> postIds;

  /// The number of posts in the pool
  @JsonKey(name: 'post_count')
  final int? postCount;
  final PoolCategory category;

  /// When the pool was created
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// When the pool was last updated
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Map<String, Object?> toJson() => _$PoolToJson(this);
}
