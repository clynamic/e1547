// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// A simplified representation of a user with core attributes.
@JsonSerializable()
class User {
  const User({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.level,
    required this.baseUploadLimit,
    required this.postUploadCount,
    required this.postUpdateCount,
    required this.noteUpdateCount,
    required this.isBanned,
    required this.canApprovePosts,
    required this.canUploadFree,
    required this.levelString,
    this.avatarId,
    this.isVerified,
  });
  
  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
  
  /// The unique ID of the user
  final int id;

  /// The timestamp when the user account was created
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// The username of the user
  final String name;

  /// The user's access level (numerical)
  final int level;

  /// The base upload limit for the user
  @JsonKey(name: 'base_upload_limit')
  final int baseUploadLimit;

  /// Number of posts uploaded by the user
  @JsonKey(name: 'post_upload_count')
  final int postUploadCount;

  /// Number of post updates made by the user
  @JsonKey(name: 'post_update_count')
  final int postUpdateCount;

  /// Number of note updates made by the user
  @JsonKey(name: 'note_update_count')
  final int noteUpdateCount;

  /// Whether the user is banned
  @JsonKey(name: 'is_banned')
  final bool isBanned;

  /// Whether the user can approve posts
  @JsonKey(name: 'can_approve_posts')
  final bool canApprovePosts;

  /// Whether the user can upload without restrictions
  @JsonKey(name: 'can_upload_free')
  final bool canUploadFree;

  /// The user's access level (textual description)
  @JsonKey(name: 'level_string')
  final String levelString;

  /// The ID of the user's avatar image
  @JsonKey(name: 'avatar_id')
  final int? avatarId;

  /// Whether the user has verified their email
  @JsonKey(name: 'is_verified')
  final bool? isVerified;

  Map<String, Object?> toJson() => _$UserToJson(this);
}
