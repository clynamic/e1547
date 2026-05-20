// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/create_forum_topic_body.dart';
import '../models/forum_topic.dart';
import '../models/update_forum_topic_body.dart';

part 'forum_topics_client.g.dart';

@RestApi()
abstract class ForumTopicsClient {
  factory ForumTopicsClient(Dio dio, {String? baseUrl}) = _ForumTopicsClient;

  /// Search forum topics.
  ///
  /// [page] - The page number for pagination.
  ///
  /// [limit] - The number of results per page.
  ///
  /// [searchId] - Filter by forum topic ID.
  ///
  /// [searchCreatedAt] - Filter by creation date.
  ///
  /// [searchUpdatedAt] - Filter by update date.
  ///
  /// [searchTitleMatches] - Filter by title text.
  ///
  /// [searchTitle] - Filter by exact title.
  ///
  /// [searchCategoryId] - Filter by forum category ID.
  ///
  /// [searchIsSticky] - Filter by sticky status.
  ///
  /// [searchIsLocked] - Filter by locked status.
  ///
  /// [searchIsHidden] - Filter by hidden status.
  ///
  /// [searchOrder] - Sort order (sticky).
  @GET('/forum_topics.json')
  Future<List<ForumTopic>> searchForumTopics({
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('search[id]') int? searchId,
    @Query('search[created_at]') String? searchCreatedAt,
    @Query('search[updated_at]') String? searchUpdatedAt,
    @Query('search[title_matches]') String? searchTitleMatches,
    @Query('search[title]') String? searchTitle,
    @Query('search[category_id]') int? searchCategoryId,
    @Query('search[is_sticky]') bool? searchIsSticky,
    @Query('search[is_locked]') bool? searchIsLocked,
    @Query('search[is_hidden]') bool? searchIsHidden,
    @Query('search[order]') String? searchOrder,
  });

  /// Create a forum topic
  @POST('/forum_topics.json')
  Future<ForumTopic> createForumTopic({
    @Body() required CreateForumTopicBody body,
  });

  /// Get a forum topic by ID.
  ///
  /// [id] - The ID of the forum topic.
  ///
  /// [page] - The page number for forum posts pagination.
  @GET('/forum_topics/{id}.json')
  Future<ForumTopic> getForumTopic({
    @Path('id') required int id,
    @Query('page') int? page,
  });

  /// Update a forum topic.
  ///
  /// [id] - The ID of the forum topic.
  @PATCH('/forum_topics/{id}.json')
  Future<ForumTopic> updateForumTopic({
    @Path('id') required int id,
    @Body() required UpdateForumTopicBody body,
  });

  /// Delete a forum topic.
  ///
  /// [id] - The ID of the forum topic.
  @DELETE('/forum_topics/{id}.json')
  Future<void> deleteForumTopic({
    @Path('id') required int id,
  });

  /// Hide a forum topic.
  ///
  /// [id] - The ID of the forum topic.
  @POST('/forum_topics/{id}/hide.json')
  Future<ForumTopic> hideForumTopic({
    @Path('id') required int id,
  });

  /// Unhide a forum topic.
  ///
  /// [id] - The ID of the forum topic.
  @POST('/forum_topics/{id}/unhide.json')
  Future<ForumTopic> unhideForumTopic({
    @Path('id') required int id,
  });

  /// Subscribe to a forum topic.
  ///
  /// [id] - The ID of the forum topic.
  @POST('/forum_topics/{id}/subscribe.json')
  Future<void> subscribeForumTopic({
    @Path('id') required int id,
  });

  /// Unsubscribe from a forum topic.
  ///
  /// [id] - The ID of the forum topic.
  @POST('/forum_topics/{id}/unsubscribe.json')
  Future<void> unsubscribeForumTopic({
    @Path('id') required int id,
  });

  /// Mark all forum topics as read
  @POST('/forum_topics/mark_all_as_read.json')
  Future<void> markAllForumTopicsAsRead();
}
