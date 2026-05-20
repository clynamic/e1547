// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/comment.dart';
import '../models/create_comment_body.dart';
import '../models/post_comments_id_warning_json_response.dart';
import '../models/search_comments_group_by.dart';
import '../models/update_comment_body.dart';
import '../models/warning_blip_record_type.dart';

part 'comments_client.g.dart';

@RestApi()
abstract class CommentsClient {
  factory CommentsClient(Dio dio, {String? baseUrl}) = _CommentsClient;

  /// Search comments.
  ///
  /// [page] - The page number for pagination.
  ///
  /// [limit] - The number of results per page.
  ///
  /// [searchId] - Filter by comment ID.
  ///
  /// [searchCreatedAt] - Filter by creation date.
  ///
  /// [searchUpdatedAt] - Filter by update date.
  ///
  /// [searchBodyMatches] - Filter by comment body text.
  ///
  /// [searchPostId] - Filter by post ID.
  ///
  /// [searchPostTagsMatch] - Filter by post tags.
  ///
  /// [searchCreatorName] - Filter by creator username.
  ///
  /// [searchCreatorId] - Filter by creator user ID.
  ///
  /// [searchPostNoteUpdaterName] - Filter by note updater username.
  ///
  /// [searchPostNoteUpdaterId] - Filter by note updater user ID.
  ///
  /// [searchPosterId] - Filter by post uploader ID.
  ///
  /// [searchPosterName] - Filter by post uploader username.
  ///
  /// [searchIsSticky] - Filter by sticky status.
  ///
  /// [searchDoNotBumpPost] - Filter by do not bump post status.
  ///
  /// [searchIsHidden] - Filter by hidden status (moderator only).
  ///
  /// [searchIpAddr] - Filter by creator IP address (admin only).
  ///
  /// [searchOrder] - Sort order (post_id, score, updated_at).
  ///
  /// [searchAdvancedSearch] - Use advanced search for body_matches.
  ///
  /// [groupBy] - Group results by post.
  @GET('/comments.json')
  Future<List<Comment>> searchComments({
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('search[id]') int? searchId,
    @Query('search[created_at]') String? searchCreatedAt,
    @Query('search[updated_at]') String? searchUpdatedAt,
    @Query('search[body_matches]') String? searchBodyMatches,
    @Query('search[post_id]') int? searchPostId,
    @Query('search[post_tags_match]') String? searchPostTagsMatch,
    @Query('search[creator_name]') String? searchCreatorName,
    @Query('search[creator_id]') int? searchCreatorId,
    @Query('search[post_note_updater_name]') String? searchPostNoteUpdaterName,
    @Query('search[post_note_updater_id]') int? searchPostNoteUpdaterId,
    @Query('search[poster_id]') int? searchPosterId,
    @Query('search[poster_name]') String? searchPosterName,
    @Query('search[is_sticky]') bool? searchIsSticky,
    @Query('search[do_not_bump_post]') bool? searchDoNotBumpPost,
    @Query('search[is_hidden]') bool? searchIsHidden,
    @Query('search[ip_addr]') String? searchIpAddr,
    @Query('search[order]') String? searchOrder,
    @Query('search[advanced_search]') bool? searchAdvancedSearch,
    @Query('group_by') SearchCommentsGroupBy? groupBy,
  });

  /// Create a comment
  @POST('/comments.json')
  Future<Comment> createComment({
    @Body() required CreateCommentBody body,
  });

  /// Get a comment by ID.
  ///
  /// [id] - The ID of the comment.
  @GET('/comments/{id}.json')
  Future<Comment> getComment({
    @Path('id') required int id,
  });

  /// Update a comment.
  ///
  /// [id] - The ID of the comment.
  @PATCH('/comments/{id}.json')
  Future<Comment> updateComment({
    @Path('id') required int id,
    @Body() required UpdateCommentBody body,
  });

  /// Delete a comment.
  ///
  /// [id] - The ID of the comment.
  @DELETE('/comments/{id}.json')
  Future<void> deleteComment({
    @Path('id') required int id,
  });

  /// Hide a comment.
  ///
  /// [id] - The ID of the comment.
  @POST('/comments/{id}/hide.json')
  Future<Comment> hideComment({
    @Path('id') required int id,
  });

  /// Unhide a comment.
  ///
  /// [id] - The ID of the comment.
  @POST('/comments/{id}/unhide.json')
  Future<Comment> unhideComment({
    @Path('id') required int id,
  });

  /// Mark or unmark a comment with a warning.
  ///
  /// [id] - The ID of the comment.
  ///
  /// [recordType] - The type of warning to apply or "unmark" to remove.
  @POST('/comments/{id}/warning.json')
  Future<PostCommentsIdWarningJsonResponse> warningComment({
    @Path('id') required int id,
    @Query('record_type') required WarningBlipRecordType recordType,
  });
}
