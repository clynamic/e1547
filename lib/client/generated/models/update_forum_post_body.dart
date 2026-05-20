// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'update_blip_body_blip.dart';

part 'update_forum_post_body.g.dart';

@JsonSerializable()
class UpdateForumPostBody {
  const UpdateForumPostBody({
    required this.forumPost,
  });
  
  factory UpdateForumPostBody.fromJson(Map<String, Object?> json) => _$UpdateForumPostBodyFromJson(json);
  
  @JsonKey(name: 'forum_post')
  final UpdateBlipBodyBlip forumPost;

  Map<String, Object?> toJson() => _$UpdateForumPostBodyToJson(this);
}
