// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum GetModActionsSearchAction {
  @JsonValue('artist_page_rename')
  artistPageRename('artist_page_rename'),
  @JsonValue('artist_page_lock')
  artistPageLock('artist_page_lock'),
  @JsonValue('artist_page_unlock')
  artistPageUnlock('artist_page_unlock'),
  @JsonValue('artist_user_linked')
  artistUserLinked('artist_user_linked'),
  @JsonValue('artist_user_unlinked')
  artistUserUnlinked('artist_user_unlinked'),
  @JsonValue('avoid_posting_create')
  avoidPostingCreate('avoid_posting_create'),
  @JsonValue('avoid_posting_update')
  avoidPostingUpdate('avoid_posting_update'),
  @JsonValue('avoid_posting_delete')
  avoidPostingDelete('avoid_posting_delete'),
  @JsonValue('avoid_posting_undelete')
  avoidPostingUndelete('avoid_posting_undelete'),
  @JsonValue('avoid_posting_destroy')
  avoidPostingDestroy('avoid_posting_destroy'),
  @JsonValue('blip_delete')
  blipDelete('blip_delete'),
  @JsonValue('blip_hide')
  blipHide('blip_hide'),
  @JsonValue('blip_unhide')
  blipUnhide('blip_unhide'),
  @JsonValue('blip_update')
  blipUpdate('blip_update'),
  @JsonValue('comment_delete')
  commentDelete('comment_delete'),
  @JsonValue('comment_hide')
  commentHide('comment_hide'),
  @JsonValue('comment_unhide')
  commentUnhide('comment_unhide'),
  @JsonValue('comment_update')
  commentUpdate('comment_update'),
  @JsonValue('forum_category_create')
  forumCategoryCreate('forum_category_create'),
  @JsonValue('forum_category_delete')
  forumCategoryDelete('forum_category_delete'),
  @JsonValue('forum_category_update')
  forumCategoryUpdate('forum_category_update'),
  @JsonValue('forum_post_delete')
  forumPostDelete('forum_post_delete'),
  @JsonValue('forum_post_hide')
  forumPostHide('forum_post_hide'),
  @JsonValue('forum_post_unhide')
  forumPostUnhide('forum_post_unhide'),
  @JsonValue('forum_post_update')
  forumPostUpdate('forum_post_update'),
  @JsonValue('forum_topic_delete')
  forumTopicDelete('forum_topic_delete'),
  @JsonValue('forum_topic_hide')
  forumTopicHide('forum_topic_hide'),
  @JsonValue('forum_topic_unhide')
  forumTopicUnhide('forum_topic_unhide'),
  @JsonValue('forum_topic_lock')
  forumTopicLock('forum_topic_lock'),
  @JsonValue('forum_topic_unlock')
  forumTopicUnlock('forum_topic_unlock'),
  @JsonValue('forum_topic_stick')
  forumTopicStick('forum_topic_stick'),
  @JsonValue('forum_topic_unstick')
  forumTopicUnstick('forum_topic_unstick'),
  @JsonValue('forum_topic_update')
  forumTopicUpdate('forum_topic_update'),
  @JsonValue('help_create')
  helpCreate('help_create'),
  @JsonValue('help_delete')
  helpDelete('help_delete'),
  @JsonValue('help_update')
  helpUpdate('help_update'),
  @JsonValue('ip_ban_create')
  ipBanCreate('ip_ban_create'),
  @JsonValue('ip_ban_delete')
  ipBanDelete('ip_ban_delete'),
  @JsonValue('mascot_create')
  mascotCreate('mascot_create'),
  @JsonValue('mascot_update')
  mascotUpdate('mascot_update'),
  @JsonValue('mascot_delete')
  mascotDelete('mascot_delete'),
  @JsonValue('pool_delete')
  poolDelete('pool_delete'),
  @JsonValue('report_reason_create')
  reportReasonCreate('report_reason_create'),
  @JsonValue('report_reason_delete')
  reportReasonDelete('report_reason_delete'),
  @JsonValue('report_reason_update')
  reportReasonUpdate('report_reason_update'),
  @JsonValue('set_update')
  setUpdate('set_update'),
  @JsonValue('set_delete')
  setDelete('set_delete'),
  @JsonValue('set_change_visibility')
  setChangeVisibility('set_change_visibility'),
  @JsonValue('tag_alias_create')
  tagAliasCreate('tag_alias_create'),
  @JsonValue('tag_alias_update')
  tagAliasUpdate('tag_alias_update'),
  @JsonValue('tag_implication_create')
  tagImplicationCreate('tag_implication_create'),
  @JsonValue('tag_implication_update')
  tagImplicationUpdate('tag_implication_update'),
  @JsonValue('ticket_claim')
  ticketClaim('ticket_claim'),
  @JsonValue('ticket_unclaim')
  ticketUnclaim('ticket_unclaim'),
  @JsonValue('ticket_update')
  ticketUpdate('ticket_update'),
  @JsonValue('upload_whitelist_create')
  uploadWhitelistCreate('upload_whitelist_create'),
  @JsonValue('upload_whitelist_update')
  uploadWhitelistUpdate('upload_whitelist_update'),
  @JsonValue('upload_whitelist_delete')
  uploadWhitelistDelete('upload_whitelist_delete'),
  @JsonValue('user_blacklist_changed')
  userBlacklistChanged('user_blacklist_changed'),
  @JsonValue('user_text_change')
  userTextChange('user_text_change'),
  @JsonValue('user_upload_limit_change')
  userUploadLimitChange('user_upload_limit_change'),
  @JsonValue('user_flags_change')
  userFlagsChange('user_flags_change'),
  @JsonValue('user_level_change')
  userLevelChange('user_level_change'),
  @JsonValue('user_name_change')
  userNameChange('user_name_change'),
  @JsonValue('user_delete')
  userDelete('user_delete'),
  @JsonValue('user_ban')
  userBan('user_ban'),
  @JsonValue('user_ban_update')
  userBanUpdate('user_ban_update'),
  @JsonValue('user_unban')
  userUnban('user_unban'),
  @JsonValue('user_feedback_create')
  userFeedbackCreate('user_feedback_create'),
  @JsonValue('user_feedback_update')
  userFeedbackUpdate('user_feedback_update'),
  @JsonValue('user_feedback_delete')
  userFeedbackDelete('user_feedback_delete'),
  @JsonValue('user_feedback_undelete')
  userFeedbackUndelete('user_feedback_undelete'),
  @JsonValue('user_feedback_destroy')
  userFeedbackDestroy('user_feedback_destroy'),
  @JsonValue('wiki_page_rename')
  wikiPageRename('wiki_page_rename'),
  @JsonValue('wiki_page_delete')
  wikiPageDelete('wiki_page_delete'),
  @JsonValue('wiki_page_lock')
  wikiPageLock('wiki_page_lock'),
  @JsonValue('wiki_page_unlock')
  wikiPageUnlock('wiki_page_unlock'),
  @JsonValue('mass_update')
  massUpdate('mass_update'),
  @JsonValue('nuke_tag')
  nukeTag('nuke_tag'),
  @JsonValue('takedown_delete')
  takedownDelete('takedown_delete'),
  @JsonValue('takedown_process')
  takedownProcess('takedown_process'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const GetModActionsSearchAction(this.json);

  factory GetModActionsSearchAction.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;

  @override
  String toString() => json?.toString() ?? super.toString();
  /// Returns all defined enum values excluding the $unknown value.
  static List<GetModActionsSearchAction> get $valuesDefined => values.where((value) => value != $unknown).toList();
}
