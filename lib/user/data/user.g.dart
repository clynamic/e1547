// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  avatarId: (json['avatar_id'] as num?)?.toInt(),
  hasCroppedAvatar: json['has_cropped_avatar'] as bool? ?? false,
  about: json['about'] == null ? null : UserAbout.fromJson(json['about']),
  stats: json['stats'] == null ? null : UserStats.fromJson(json['stats']),
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'avatar_id': instance.avatarId,
  'has_cropped_avatar': instance.hasCroppedAvatar,
  'about': instance.about,
  'stats': instance.stats,
};

_PartialUser _$PartialUserFromJson(Map<String, dynamic> json) => _PartialUser(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  avatarId: (json['avatar_id'] as num?)?.toInt(),
  hasCroppedAvatar: json['has_cropped_avatar'] as bool? ?? false,
);

Map<String, dynamic> _$PartialUserToJson(_PartialUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar_id': instance.avatarId,
      'has_cropped_avatar': instance.hasCroppedAvatar,
    };

_UserAbout _$UserAboutFromJson(Map<String, dynamic> json) => _UserAbout(
  bio: json['bio'] as String?,
  comission: json['comission'] as String?,
);

Map<String, dynamic> _$UserAboutToJson(_UserAbout instance) =>
    <String, dynamic>{'bio': instance.bio, 'comission': instance.comission};

_UserStats _$UserStatsFromJson(Map<String, dynamic> json) => _UserStats(
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  levelString: json['level_string'] as String?,
  favoriteCount: (json['favorite_count'] as num?)?.toInt(),
  postUpdateCount: (json['post_update_count'] as num?)?.toInt(),
  postUploadCount: (json['post_upload_count'] as num?)?.toInt(),
  forumPostCount: (json['forum_post_count'] as num?)?.toInt(),
  commentCount: (json['comment_count'] as num?)?.toInt(),
  poolUpdateCount: (json['pool_update_count'] as num?)?.toInt(),
  artistUpdateCount: (json['artist_update_count'] as num?)?.toInt(),
  wikiUpdateCount: (json['wiki_update_count'] as num?)?.toInt(),
  noteUpdateCount: (json['note_update_count'] as num?)?.toInt(),
  uploadKarma: (json['upload_karma'] as num?)?.toInt(),
  uploadSlots: (json['upload_slots'] as num?)?.toInt(),
  positiveFeedbackCount: (json['positive_feedback_count'] as num?)?.toInt(),
  neutralFeedbackCount: (json['neutral_feedback_count'] as num?)?.toInt(),
  negativeFeedbackCount: (json['negative_feedback_count'] as num?)?.toInt(),
  canApprovePosts: json['can_approve_posts'] as bool? ?? false,
  canUploadFree: json['can_upload_free'] as bool? ?? false,
  isBanned: json['is_banned'] as bool? ?? false,
  isVerified: json['is_verified'] as bool? ?? true,
);

Map<String, dynamic> _$UserStatsToJson(_UserStats instance) =>
    <String, dynamic>{
      'created_at': instance.createdAt?.toIso8601String(),
      'level_string': instance.levelString,
      'favorite_count': instance.favoriteCount,
      'post_update_count': instance.postUpdateCount,
      'post_upload_count': instance.postUploadCount,
      'forum_post_count': instance.forumPostCount,
      'comment_count': instance.commentCount,
      'pool_update_count': instance.poolUpdateCount,
      'artist_update_count': instance.artistUpdateCount,
      'wiki_update_count': instance.wikiUpdateCount,
      'note_update_count': instance.noteUpdateCount,
      'upload_karma': instance.uploadKarma,
      'upload_slots': instance.uploadSlots,
      'positive_feedback_count': instance.positiveFeedbackCount,
      'neutral_feedback_count': instance.neutralFeedbackCount,
      'negative_feedback_count': instance.negativeFeedbackCount,
      'can_approve_posts': instance.canApprovePosts,
      'can_upload_free': instance.canUploadFree,
      'is_banned': instance.isBanned,
      'is_verified': instance.isVerified,
    };
