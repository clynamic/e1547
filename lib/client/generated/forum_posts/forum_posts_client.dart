// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/create_forum_post_body.dart';
import '../models/forum_post.dart';
import '../models/post_forum_posts_id_warning_json_response.dart';
import '../models/update_forum_post_body.dart';
import '../models/warning_blip_record_type.dart';

part 'forum_posts_client.g.dart';

@RestApi()
abstract class ForumPostsClient {
  factory ForumPostsClient(Dio dio, {String? baseUrl}) = _ForumPostsClient;

  /// Search forum posts.
  ///
  /// [page] - The page number for pagination.
  ///
  /// [limit] - The number of results per page.
  ///
  /// [searchId] - Filter by forum post ID.
  ///
  /// [searchCreatedAt] - Filter by creation date.
  ///
  /// [searchUpdatedAt] - Filter by update date.
  ///
  /// [searchCreatorName] - Filter by creator username.
  ///
  /// [searchCreatorId] - Filter by creator user ID.
  ///
  /// [searchTopicId] - Filter by forum topic ID.
  ///
  /// [searchTopicTitleMatches] - Filter by topic title text.
  ///
  /// [searchBodyMatches] - Filter by post body text.
  ///
  /// [searchTopicCategoryId] - Filter by topic category ID.
  ///
  /// [searchIsHidden] - Filter by hidden status.
  @GET('/forum_posts.json')
  Future<List<ForumPost>> searchForumPosts({
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('search[id]') int? searchId,
    @Query('search[created_at]') String? searchCreatedAt,
    @Query('search[updated_at]') String? searchUpdatedAt,
    @Query('search[creator_name]') String? searchCreatorName,
    @Query('search[creator_id]') int? searchCreatorId,
    @Query('search[topic_id]') int? searchTopicId,
    @Query('search[topic_title_matches]') String? searchTopicTitleMatches,
    @Query('search[body_matches]') String? searchBodyMatches,
    @Query('search[topic_category_id]') int? searchTopicCategoryId,
    @Query('search[is_hidden]') bool? searchIsHidden,
  });

  /// Create a forum post
  @POST('/forum_posts.json')
  Future<ForumPost> createForumPost({
    @Body() required CreateForumPostBody body,
  });

  /// Get a forum post by ID.
  ///
  /// [id] - The ID of the forum post.
  @GET('/forum_posts/{id}.json')
  Future<ForumPost> getForumPost({
    @Path('id') required int id,
  });

  /// Update a forum post.
  ///
  /// [id] - The ID of the forum post.
  @PATCH('/forum_posts/{id}.json')
  Future<ForumPost> updateForumPost({
    @Path('id') required int id,
    @Body() required UpdateForumPostBody body,
  });

  /// Delete a forum post.
  ///
  /// [id] - The ID of the forum post.
  @DELETE('/forum_posts/{id}.json')
  Future<void> deleteForumPost({
    @Path('id') required int id,
  });

  /// Hide a forum post.
  ///
  /// [id] - The ID of the forum post.
  @POST('/forum_posts/{id}/hide.json')
  Future<ForumPost> hideForumPost({
    @Path('id') required int id,
  });

  /// Unhide a forum post.
  ///
  /// [id] - The ID of the forum post.
  @POST('/forum_posts/{id}/unhide.json')
  Future<ForumPost> unhideForumPost({
    @Path('id') required int id,
  });

  /// Mark or unmark a forum post with a warning.
  ///
  /// [id] - The ID of the forum post.
  ///
  /// [recordType] - The type of warning to apply or "unmark" to remove.
  @POST('/forum_posts/{id}/warning.json')
  Future<PostForumPostsIdWarningJsonResponse> warningForumPost({
    @Path('id') required int id,
    @Query('record_type') required WarningBlipRecordType recordType,
  });
}
