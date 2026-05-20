// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

/// A detailed representation of a user.
@JsonSerializable()
class UserProfile {
  const UserProfile({
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
    this.wikiPageVersionCount,
    this.artistVersionCount,
    this.poolVersionCount,
    this.forumPostCount,
    this.commentCount,
    this.flagCount,
    this.favoriteCount,
    this.positiveFeedbackCount,
    this.neutralFeedbackCount,
    this.negativeFeedbackCount,
    this.uploadLimit,
    this.profileAbout,
    this.profileArtinfo,
    this.avatarId,
    this.isVerified,
  });
  
  factory UserProfile.fromJson(Map<String, Object?> json) => _$UserProfileFromJson(json);
  
  /// Number of wiki page versions created by the user
  @JsonKey(name: 'wiki_page_version_count')
  final int? wikiPageVersionCount;

  /// Number of artist versions created by the user
  @JsonKey(name: 'artist_version_count')
  final int? artistVersionCount;

  /// Number of pool versions created by the user
  @JsonKey(name: 'pool_version_count')
  final int? poolVersionCount;

  /// Number of forum posts created by the user
  @JsonKey(name: 'forum_post_count')
  final int? forumPostCount;

  /// Number of comments made by the user
  @JsonKey(name: 'comment_count')
  final int? commentCount;

  /// Number of flags made by the user
  @JsonKey(name: 'flag_count')
  final int? flagCount;

  /// Number of favorites added by the user
  @JsonKey(name: 'favorite_count')
  final int? favoriteCount;

  /// Number of positive feedbacks received by the user
  @JsonKey(name: 'positive_feedback_count')
  final int? positiveFeedbackCount;

  /// Number of neutral feedbacks received by the user
  @JsonKey(name: 'neutral_feedback_count')
  final int? neutralFeedbackCount;

  /// Number of negative feedbacks received by the user
  @JsonKey(name: 'negative_feedback_count')
  final int? negativeFeedbackCount;

  /// The user's current upload limit
  @JsonKey(name: 'upload_limit')
  final int? uploadLimit;

  /// The user's "About" profile section
  @JsonKey(name: 'profile_about')
  final String? profileAbout;

  /// The user's art information profile section
  @JsonKey(name: 'profile_artinfo')
  final String? profileArtinfo;

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

  Map<String, Object?> toJson() => _$UserProfileToJson(this);
}
