// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'pool_version.g.dart';

@JsonSerializable()
class PoolVersion {
  const PoolVersion({
    required this.id,
    required this.poolId,
    required this.postIds,
    required this.addedPostIds,
    required this.removedPostIds,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    this.updaterId,
    this.description,
    this.descriptionChanged,
    this.name,
    this.nameChanged,
    this.isActive,
    this.category,
  });
  
  factory PoolVersion.fromJson(Map<String, Object?> json) => _$PoolVersionFromJson(json);
  
  /// The unique ID of the pool version
  final int id;

  /// The ID of the pool
  @JsonKey(name: 'pool_id')
  final int poolId;

  /// The full ordered list of post IDs at this version
  @JsonKey(name: 'post_ids')
  final List<int> postIds;

  /// Post IDs added in this version
  @JsonKey(name: 'added_post_ids')
  final List<int> addedPostIds;

  /// Post IDs removed in this version
  @JsonKey(name: 'removed_post_ids')
  final List<int> removedPostIds;

  /// The ID of the user who made this version
  @JsonKey(name: 'updater_id')
  final int? updaterId;

  /// The pool description at this version
  final String? description;

  /// Whether the description was changed in this version
  @JsonKey(name: 'description_changed')
  final bool? descriptionChanged;

  /// The pool name at this version
  final String? name;

  /// Whether the name was changed in this version
  @JsonKey(name: 'name_changed')
  final bool? nameChanged;

  /// Whether the pool was active at this version
  @JsonKey(name: 'is_active')
  final bool? isActive;

  /// The pool category at this version
  final String? category;

  /// The version number
  final int version;

  /// When this version was created
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// When this version was last updated
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Map<String, Object?> toJson() => _$PoolVersionToJson(this);
}
