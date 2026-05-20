// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum PostEventAction {
  @JsonValue('deleted')
  deleted('deleted'),
  @JsonValue('undeleted')
  undeleted('undeleted'),
  @JsonValue('approved')
  approved('approved'),
  @JsonValue('unapproved')
  unapproved('unapproved'),
  @JsonValue('flag_created')
  flagCreated('flag_created'),
  @JsonValue('flag_removed')
  flagRemoved('flag_removed'),
  @JsonValue('favorites_moved')
  favoritesMoved('favorites_moved'),
  @JsonValue('favorites_received')
  favoritesReceived('favorites_received'),
  @JsonValue('rating_locked')
  ratingLocked('rating_locked'),
  @JsonValue('rating_unlocked')
  ratingUnlocked('rating_unlocked'),
  @JsonValue('status_locked')
  statusLocked('status_locked'),
  @JsonValue('status_unlocked')
  statusUnlocked('status_unlocked'),
  @JsonValue('note_locked')
  noteLocked('note_locked'),
  @JsonValue('note_unlocked')
  noteUnlocked('note_unlocked'),
  @JsonValue('comment_locked')
  commentLocked('comment_locked'),
  @JsonValue('comment_unlocked')
  commentUnlocked('comment_unlocked'),
  @JsonValue('comment_disabled')
  commentDisabled('comment_disabled'),
  @JsonValue('comment_enabled')
  commentEnabled('comment_enabled'),
  @JsonValue('replacement_accepted')
  replacementAccepted('replacement_accepted'),
  @JsonValue('replacement_rejected')
  replacementRejected('replacement_rejected'),
  @JsonValue('replacement_promoted')
  replacementPromoted('replacement_promoted'),
  @JsonValue('replacement_deleted')
  replacementDeleted('replacement_deleted'),
  @JsonValue('expunged')
  expunged('expunged'),
  @JsonValue('changed_bg_color')
  changedBgColor('changed_bg_color'),
  @JsonValue('replacement_penalty_changed')
  replacementPenaltyChanged('replacement_penalty_changed'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const PostEventAction(this.json);

  factory PostEventAction.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;

  @override
  String toString() => json?.toString() ?? super.toString();
  /// Returns all defined enum values excluding the $unknown value.
  static List<PostEventAction> get $valuesDefined => values.where((value) => value != $unknown).toList();
}
