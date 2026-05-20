// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
  id: (json['id'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  name: json['name'] as String,
  level: (json['level'] as num).toInt(),
  baseUploadLimit: (json['base_upload_limit'] as num).toInt(),
  postUploadCount: (json['post_upload_count'] as num).toInt(),
  postUpdateCount: (json['post_update_count'] as num).toInt(),
  noteUpdateCount: (json['note_update_count'] as num).toInt(),
  isBanned: json['is_banned'] as bool,
  canApprovePosts: json['can_approve_posts'] as bool,
  canUploadFree: json['can_upload_free'] as bool,
  levelString: json['level_string'] as String,
  wikiPageVersionCount: (json['wiki_page_version_count'] as num?)?.toInt(),
  artistVersionCount: (json['artist_version_count'] as num?)?.toInt(),
  poolVersionCount: (json['pool_version_count'] as num?)?.toInt(),
  forumPostCount: (json['forum_post_count'] as num?)?.toInt(),
  commentCount: (json['comment_count'] as num?)?.toInt(),
  flagCount: (json['flag_count'] as num?)?.toInt(),
  favoriteCount: (json['favorite_count'] as num?)?.toInt(),
  positiveFeedbackCount: (json['positive_feedback_count'] as num?)?.toInt(),
  neutralFeedbackCount: (json['neutral_feedback_count'] as num?)?.toInt(),
  negativeFeedbackCount: (json['negative_feedback_count'] as num?)?.toInt(),
  uploadLimit: (json['upload_limit'] as num?)?.toInt(),
  profileAbout: json['profile_about'] as String?,
  profileArtinfo: json['profile_artinfo'] as String?,
  avatarId: (json['avatar_id'] as num?)?.toInt(),
  isVerified: json['is_verified'] as bool?,
);

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'wiki_page_version_count': instance.wikiPageVersionCount,
      'artist_version_count': instance.artistVersionCount,
      'pool_version_count': instance.poolVersionCount,
      'forum_post_count': instance.forumPostCount,
      'comment_count': instance.commentCount,
      'flag_count': instance.flagCount,
      'favorite_count': instance.favoriteCount,
      'positive_feedback_count': instance.positiveFeedbackCount,
      'neutral_feedback_count': instance.neutralFeedbackCount,
      'negative_feedback_count': instance.negativeFeedbackCount,
      'upload_limit': instance.uploadLimit,
      'profile_about': instance.profileAbout,
      'profile_artinfo': instance.profileArtinfo,
      'id': instance.id,
      'created_at': instance.createdAt.toIso8601String(),
      'name': instance.name,
      'level': instance.level,
      'base_upload_limit': instance.baseUploadLimit,
      'post_upload_count': instance.postUploadCount,
      'post_update_count': instance.postUpdateCount,
      'note_update_count': instance.noteUpdateCount,
      'is_banned': instance.isBanned,
      'can_approve_posts': instance.canApprovePosts,
      'can_upload_free': instance.canUploadFree,
      'level_string': instance.levelString,
      'avatar_id': instance.avatarId,
      'is_verified': instance.isVerified,
    };
