// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'relationships.g.dart';

@JsonSerializable()
class Relationships {
  const Relationships({
    required this.hasChildren,
    required this.hasActiveChildren,
    required this.children,
    this.parentId,
  });
  
  factory Relationships.fromJson(Map<String, Object?> json) => _$RelationshipsFromJson(json);
  
  /// The ID of the parent post, if applicable
  @JsonKey(name: 'parent_id')
  final int? parentId;

  /// Whether the post has any child posts
  @JsonKey(name: 'has_children')
  final bool hasChildren;

  /// Whether the post has any active child posts
  @JsonKey(name: 'has_active_children')
  final bool hasActiveChildren;

  /// An array of child post IDs
  final List<int> children;

  Map<String, Object?> toJson() => _$RelationshipsToJson(this);
}
