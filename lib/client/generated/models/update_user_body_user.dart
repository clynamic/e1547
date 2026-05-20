// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'update_user_body_user.g.dart';

@JsonSerializable()
class UpdateUserBodyUser {
  const UpdateUserBodyUser({
    this.commentThreshold,
    this.defaultImageSize,
    this.favoriteTags,
    this.blacklistedTags,
    this.timeZone,
    this.perPage,
    this.customStyle,
    this.descriptionCollapsedInitially,
    this.hideComments,
    this.receiveEmailNotifications,
    this.enableKeyboardNavigation,
    this.enablePrivacyMode,
    this.disableUserDmails,
    this.blacklistUsers,
    this.showPostStatistics,
    this.styleUsernames,
    this.showHiddenComments,
    this.enableAutoComplete,
    this.enableSafeMode,
    this.disableResponsiveMode,
    this.profileAbout,
    this.profileArtinfo,
    this.avatarId,
    this.password,
    this.oldPassword,
    this.passwordConfirmation,
  });
  
  factory UpdateUserBodyUser.fromJson(Map<String, Object?> json) => _$UpdateUserBodyUserFromJson(json);
  
  /// Score threshold below which comments are hidden
  @JsonKey(name: 'comment_threshold')
  final int? commentThreshold;

  /// Default image display size
  @JsonKey(name: 'default_image_size')
  final String? defaultImageSize;

  /// User's favorite tags
  @JsonKey(name: 'favorite_tags')
  final String? favoriteTags;

  /// Tags to blacklist
  @JsonKey(name: 'blacklisted_tags')
  final String? blacklistedTags;

  /// User's time zone
  @JsonKey(name: 'time_zone')
  final String? timeZone;

  /// Number of items per page
  @JsonKey(name: 'per_page')
  final int? perPage;

  /// Custom CSS style
  @JsonKey(name: 'custom_style')
  final String? customStyle;

  /// Whether post descriptions are collapsed by default
  @JsonKey(name: 'description_collapsed_initially')
  final bool? descriptionCollapsedInitially;

  /// Whether to hide comments by default
  @JsonKey(name: 'hide_comments')
  final bool? hideComments;

  /// Whether to receive email notifications
  @JsonKey(name: 'receive_email_notifications')
  final bool? receiveEmailNotifications;

  /// Whether keyboard navigation is enabled
  @JsonKey(name: 'enable_keyboard_navigation')
  final bool? enableKeyboardNavigation;

  /// Whether privacy mode is enabled
  @JsonKey(name: 'enable_privacy_mode')
  final bool? enablePrivacyMode;

  /// Whether to disable user DMails
  @JsonKey(name: 'disable_user_dmails')
  final bool? disableUserDmails;

  /// Whether to blacklist users
  @JsonKey(name: 'blacklist_users')
  final bool? blacklistUsers;

  /// Whether to show post statistics
  @JsonKey(name: 'show_post_statistics')
  final bool? showPostStatistics;

  /// Whether to style usernames by level
  @JsonKey(name: 'style_usernames')
  final bool? styleUsernames;

  /// Whether to show hidden comments
  @JsonKey(name: 'show_hidden_comments')
  final bool? showHiddenComments;

  /// Whether auto-complete is enabled
  @JsonKey(name: 'enable_auto_complete')
  final bool? enableAutoComplete;

  /// Whether safe mode is enabled
  @JsonKey(name: 'enable_safe_mode')
  final bool? enableSafeMode;

  /// Whether responsive mode is disabled
  @JsonKey(name: 'disable_responsive_mode')
  final bool? disableResponsiveMode;

  /// User's about me text
  @JsonKey(name: 'profile_about')
  final String? profileAbout;

  /// User's artist info text
  @JsonKey(name: 'profile_artinfo')
  final String? profileArtinfo;

  /// Post ID to use as avatar
  @JsonKey(name: 'avatar_id')
  final int? avatarId;

  /// New password
  final String? password;

  /// Current password (required when changing password)
  @JsonKey(name: 'old_password')
  final String? oldPassword;

  /// New password confirmation
  @JsonKey(name: 'password_confirmation')
  final String? passwordConfirmation;

  Map<String, Object?> toJson() => _$UpdateUserBodyUserToJson(this);
}
