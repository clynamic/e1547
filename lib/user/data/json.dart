import 'package:deep_pick/deep_pick.dart';
import 'package:e1547/user/user.dart';

abstract final class E621User {
  static PartialUser partialFromJson(dynamic json) => pick(json).letOrThrow(
    (pick) => PartialUser(
      id: pick('id').asIntOrThrow(),
      name: pick('name').asStringOrThrow(),
      avatarId: pick('avatar_id').asIntOrNull(),
      hasCroppedAvatar: pick('has_cropped_avatar').asBoolOrFalse(),
    ),
  );

  static User fromJson(dynamic json) => pick(json).letOrThrow(
    (pick) => User(
      id: json['id'],
      name: json['name'],
      avatarId: json['avatar_id'],
      hasCroppedAvatar: json['has_cropped_avatar'] == true,
      about: UserAbout(
        bio: json['profile_about'],
        comission: json['profile_artinfo'],
      ),
      stats: UserStats(
        createdAt: pick('created_at').asDateTimeOrThrow(),
        levelString: pick('level_string').asStringOrThrow(),
        favoriteCount: pick('favorite_count').asIntOrThrow(),
        postUpdateCount: pick('post_update_count').asIntOrThrow(),
        postUploadCount: pick('post_upload_count').asIntOrThrow(),
        forumPostCount: pick('forum_post_count').asIntOrThrow(),
        commentCount: pick('comment_count').asIntOrThrow(),
        poolUpdateCount: pick('pool_version_count').asIntOrNull(),
        artistUpdateCount: pick('artist_version_count').asIntOrNull(),
        wikiUpdateCount: pick('wiki_page_version_count').asIntOrNull(),
        noteUpdateCount: pick('note_update_count').asIntOrNull(),
        uploadKarma: pick('upload_karma').asIntOrNull(),
        uploadSlots: pick('upload_slots').asIntOrNull(),
        positiveFeedbackCount: pick('positive_feedback_count').asIntOrNull(),
        neutralFeedbackCount: pick('neutral_feedback_count').asIntOrNull(),
        negativeFeedbackCount: pick('negative_feedback_count').asIntOrNull(),
        canApprovePosts: pick('can_approve_posts').asBoolOrFalse(),
        canUploadFree: pick('can_upload_free').asBoolOrFalse(),
        isBanned: pick('is_banned').asBoolOrFalse(),
        isVerified: pick('is_verified').asBoolOrTrue(),
      ),
    ),
  );
}
