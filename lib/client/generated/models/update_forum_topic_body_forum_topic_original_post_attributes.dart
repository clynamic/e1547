// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'update_forum_topic_body_forum_topic_original_post_attributes.g.dart';

@JsonSerializable()
class UpdateForumTopicBodyForumTopicOriginalPostAttributes {
  const UpdateForumTopicBodyForumTopicOriginalPostAttributes({
    this.id,
    this.body,
  });
  
  factory UpdateForumTopicBodyForumTopicOriginalPostAttributes.fromJson(Map<String, Object?> json) => _$UpdateForumTopicBodyForumTopicOriginalPostAttributesFromJson(json);
  
  /// The ID of the original post
  final int? id;

  /// The body text of the opening post
  final String? body;

  Map<String, Object?> toJson() => _$UpdateForumTopicBodyForumTopicOriginalPostAttributesToJson(this);
}
