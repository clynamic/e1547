// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'forum_topic.g.dart';

@JsonSerializable()
class ForumTopic {
  const ForumTopic({
    required this.id,
    required this.creatorId,
    required this.updaterId,
    required this.title,
    required this.responseCount,
    required this.isSticky,
    required this.isLocked,
    required this.isHidden,
    required this.createdAt,
    required this.updatedAt,
    required this.categoryId,
    this.creatorName,
    this.updaterName,
  });
  
  factory ForumTopic.fromJson(Map<String, Object?> json) => _$ForumTopicFromJson(json);
  
  /// The unique ID of the forum topic
  final int id;

  /// The ID of the user who created the topic
  @JsonKey(name: 'creator_id')
  final int creatorId;

  /// The ID of the user who last updated the topic
  @JsonKey(name: 'updater_id')
  final int updaterId;

  /// The topic title
  final String title;

  /// The number of responses in the topic
  @JsonKey(name: 'response_count')
  final int responseCount;

  /// Whether the topic is sticky
  @JsonKey(name: 'is_sticky')
  final bool isSticky;

  /// Whether the topic is locked
  @JsonKey(name: 'is_locked')
  final bool isLocked;

  /// Whether the topic is hidden
  @JsonKey(name: 'is_hidden')
  final bool isHidden;

  /// The time when the topic was created
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// The last time the topic was updated
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  /// The forum category ID
  @JsonKey(name: 'category_id')
  final int categoryId;

  /// The username of the topic creator
  @JsonKey(name: 'creator_name')
  final String? creatorName;

  /// The username of the last updater
  @JsonKey(name: 'updater_name')
  final String? updaterName;

  Map<String, Object?> toJson() => _$ForumTopicToJson(this);
}
