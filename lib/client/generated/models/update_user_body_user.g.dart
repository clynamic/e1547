// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_user_body_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateUserBodyUser _$UpdateUserBodyUserFromJson(Map<String, dynamic> json) =>
    UpdateUserBodyUser(
      commentThreshold: (json['comment_threshold'] as num?)?.toInt(),
      defaultImageSize: json['default_image_size'] as String?,
      favoriteTags: json['favorite_tags'] as String?,
      blacklistedTags: json['blacklisted_tags'] as String?,
      timeZone: json['time_zone'] as String?,
      perPage: (json['per_page'] as num?)?.toInt(),
      customStyle: json['custom_style'] as String?,
      descriptionCollapsedInitially:
          json['description_collapsed_initially'] as bool?,
      hideComments: json['hide_comments'] as bool?,
      receiveEmailNotifications: json['receive_email_notifications'] as bool?,
      enableKeyboardNavigation: json['enable_keyboard_navigation'] as bool?,
      enablePrivacyMode: json['enable_privacy_mode'] as bool?,
      disableUserDmails: json['disable_user_dmails'] as bool?,
      blacklistUsers: json['blacklist_users'] as bool?,
      showPostStatistics: json['show_post_statistics'] as bool?,
      styleUsernames: json['style_usernames'] as bool?,
      showHiddenComments: json['show_hidden_comments'] as bool?,
      enableAutoComplete: json['enable_auto_complete'] as bool?,
      enableSafeMode: json['enable_safe_mode'] as bool?,
      disableResponsiveMode: json['disable_responsive_mode'] as bool?,
      profileAbout: json['profile_about'] as String?,
      profileArtinfo: json['profile_artinfo'] as String?,
      avatarId: (json['avatar_id'] as num?)?.toInt(),
      password: json['password'] as String?,
      oldPassword: json['old_password'] as String?,
      passwordConfirmation: json['password_confirmation'] as String?,
    );

Map<String, dynamic> _$UpdateUserBodyUserToJson(UpdateUserBodyUser instance) =>
    <String, dynamic>{
      'comment_threshold': instance.commentThreshold,
      'default_image_size': instance.defaultImageSize,
      'favorite_tags': instance.favoriteTags,
      'blacklisted_tags': instance.blacklistedTags,
      'time_zone': instance.timeZone,
      'per_page': instance.perPage,
      'custom_style': instance.customStyle,
      'description_collapsed_initially': instance.descriptionCollapsedInitially,
      'hide_comments': instance.hideComments,
      'receive_email_notifications': instance.receiveEmailNotifications,
      'enable_keyboard_navigation': instance.enableKeyboardNavigation,
      'enable_privacy_mode': instance.enablePrivacyMode,
      'disable_user_dmails': instance.disableUserDmails,
      'blacklist_users': instance.blacklistUsers,
      'show_post_statistics': instance.showPostStatistics,
      'style_usernames': instance.styleUsernames,
      'show_hidden_comments': instance.showHiddenComments,
      'enable_auto_complete': instance.enableAutoComplete,
      'enable_safe_mode': instance.enableSafeMode,
      'disable_responsive_mode': instance.disableResponsiveMode,
      'profile_about': instance.profileAbout,
      'profile_artinfo': instance.profileArtinfo,
      'avatar_id': instance.avatarId,
      'password': instance.password,
      'old_password': instance.oldPassword,
      'password_confirmation': instance.passwordConfirmation,
    };
