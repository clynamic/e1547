// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_forum_post_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateForumPostBody _$CreateForumPostBodyFromJson(Map<String, dynamic> json) =>
    CreateForumPostBody(
      forumPost: CreateForumPostBodyForumPost.fromJson(
        json['forum_post'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$CreateForumPostBodyToJson(
  CreateForumPostBody instance,
) => <String, dynamic>{'forum_post': instance.forumPost};
