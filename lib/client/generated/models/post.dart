// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

import 'file.dart';
import 'flags.dart';
import 'post_rating.dart';
import 'preview.dart';
import 'relationships.dart';
import 'sample.dart';
import 'score.dart';
import 'tags.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  const Post({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.file,
    required this.preview,
    required this.sample,
    required this.score,
    required this.tags,
    required this.lockedTags,
    required this.changeSeq,
    required this.flags,
    required this.rating,
    required this.favCount,
    required this.sources,
    required this.pools,
    required this.relationships,
    required this.uploaderId,
    required this.description,
    required this.commentCount,
    required this.hasNotes,
    this.approverId,
    this.uploaderName,
    this.isFavorited,
    this.duration,
  });
  
  factory Post.fromJson(Map<String, Object?> json) => _$PostFromJson(json);
  
  /// The unique ID of the post
  final int id;

  /// The time when the post was created
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// The last time the post was updated
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final File file;
  final Preview preview;
  final Sample sample;
  final Score score;
  final Tags tags;

  /// An array of tags that are locked
  @JsonKey(name: 'locked_tags')
  final List<String> lockedTags;

  /// The sequence number of changes to the post
  @JsonKey(name: 'change_seq')
  final int changeSeq;
  final Flags flags;
  final PostRating rating;

  /// The number of times the post has been favorited
  @JsonKey(name: 'fav_count')
  final int favCount;

  /// An array of sources for the post
  final List<String> sources;

  /// An array of pool IDs associated with the post
  final List<int> pools;
  final Relationships relationships;

  /// The ID of the user who approved the post, if applicable
  @JsonKey(name: 'approver_id')
  final int? approverId;

  /// The ID of the user who uploaded the post
  @JsonKey(name: 'uploader_id')
  final int uploaderId;

  /// The username of the user who uploaded the post
  @JsonKey(name: 'uploader_name')
  final String? uploaderName;

  /// The description of the post
  final String description;

  /// The number of comments on the post
  @JsonKey(name: 'comment_count')
  final int commentCount;

  /// Whether the post is favorited by the current user
  @JsonKey(name: 'is_favorited')
  final bool? isFavorited;

  /// Whether the post has any notes attached
  @JsonKey(name: 'has_notes')
  final bool hasNotes;

  /// The duration of the post, if applicable
  final num? duration;

  Map<String, Object?> toJson() => _$PostToJson(this);
}
