// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/create_post_flag_body.dart';
import '../models/post_flag.dart';
import '../models/post_flag_type.dart';
import '../models/resolve_post_flag_approval.dart';

part 'post_flags_client.g.dart';

@RestApi()
abstract class PostFlagsClient {
  factory PostFlagsClient(Dio dio, {String? baseUrl}) = _PostFlagsClient;

  /// Get a list of post flags.
  ///
  /// Returns a list of post flags based on search criteria.
  ///
  /// [page] - The page number to retrieve.
  ///
  /// [limit] - The number of post flags to retrieve per page.
  ///
  /// [searchReasonMatches] - Filter post flags by matching reason text.
  ///
  /// [searchPostTagsMatch] - Filter post flags by matching post tags.
  ///
  /// [searchPostId] - Filter post flags by post ID.
  ///
  /// [searchType] - Filter post flags by type (e.g., flag or deletion).
  ///
  /// [searchIsResolved] - Filter post flags by resolution status.
  ///
  /// [searchCreatorName] - Filter post flags by the creator's username.
  ///
  /// [searchCreatorId] - Filter post flags by creator ID.
  ///
  /// [searchCreatedAt] - Filter post flags by creation date.
  ///
  /// [searchUpdatedAt] - Filter post flags by last update date.
  ///
  /// [searchId] - Filter post flags by flag ID.
  @GET('/post_flags.json')
  Future<List<PostFlag>> getPostFlags({
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('search[reason_matches]') String? searchReasonMatches,
    @Query('search[post_tags_match]') String? searchPostTagsMatch,
    @Query('search[post_id]') int? searchPostId,
    @Query('search[type]') PostFlagType? searchType,
    @Query('search[is_resolved]') bool? searchIsResolved,
    @Query('search[creator_name]') String? searchCreatorName,
    @Query('search[creator_id]') int? searchCreatorId,
    @Query('search[created_at]') String? searchCreatedAt,
    @Query('search[updated_at]') String? searchUpdatedAt,
    @Query('search[id]') String? searchId,
  });

  /// Create a post flag.
  ///
  /// Creates a new flag or deletion request for a post.
  @POST('/post_flags.json')
  Future<PostFlag> createPostFlag({
    @Body() required CreatePostFlagBody body,
  });

  /// Get a post flag by ID.
  ///
  /// Returns detailed information about a specific post flag identified by its ID.
  ///
  /// [id] - The unique ID of the post flag to retrieve.
  @GET('/post_flags/{id}.json')
  Future<PostFlag> getPostFlag({
    @Path('id') required int id,
  });

  /// Clear a post flag note.
  ///
  /// Removes the note from the specified post flag.
  ///
  /// [id] - The ID of the post flag.
  @POST('/post_flags/{id}/clear_note.json')
  Future<PostFlag> clearPostFlagNote({
    @Path('id') required int id,
  });

  /// Resolve a post flag.
  ///
  /// Resolves the active flag on a post, optionally approving the post.
  ///
  /// [postId] - The ID of the flagged post.
  ///
  /// [approval] - Set to "approve" to also approve the post.
  @DELETE('/posts/{post_id}/flag.json')
  Future<void> resolvePostFlag({
    @Path('post_id') required int postId,
    @Query('approval') ResolvePostFlagApproval? approval,
  });
}
