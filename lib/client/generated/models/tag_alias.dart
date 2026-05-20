// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'tag_alias_status.dart';

part 'tag_alias.g.dart';

@JsonSerializable()
class TagAlias {
  const TagAlias({
    required this.id,
    required this.antecedentName,
    required this.consequentName,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.creatorId,
    this.reason,
    this.approverId,
    this.forumPostId,
    this.forumTopicId,
    this.postCount,
  });
  
  factory TagAlias.fromJson(Map<String, Object?> json) => _$TagAliasFromJson(json);
  
  /// The unique ID of the tag alias
  final int id;

  /// The name of the antecedent tag
  @JsonKey(name: 'antecedent_name')
  final String antecedentName;

  /// The name of the consequent tag
  @JsonKey(name: 'consequent_name')
  final String consequentName;
  final TagAliasStatus status;

  /// The timestamp when the tag alias was created
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// The timestamp when the tag alias was last updated
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  /// The reason for creating the tag alias
  final String? reason;

  /// The ID of the user who created the tag alias
  @JsonKey(name: 'creator_id')
  final int creatorId;

  /// The ID of the user who approved the tag alias, if applicable
  @JsonKey(name: 'approver_id')
  final int? approverId;

  /// The ID of the associated forum post
  @JsonKey(name: 'forum_post_id')
  final int? forumPostId;

  /// The ID of the associated forum topic
  @JsonKey(name: 'forum_topic_id')
  final int? forumTopicId;

  /// The number of posts associated with the tag alias
  @JsonKey(name: 'post_count')
  final int? postCount;

  Map<String, Object?> toJson() => _$TagAliasToJson(this);
}
