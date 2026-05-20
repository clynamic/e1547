// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_forum_post_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateForumPostBody _$UpdateForumPostBodyFromJson(Map<String, dynamic> json) =>
    UpdateForumPostBody(
      forumPost: UpdateBlipBodyBlip.fromJson(
        json['forum_post'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$UpdateForumPostBodyToJson(
  UpdateForumPostBody instance,
) => <String, dynamic>{'forum_post': instance.forumPost};
