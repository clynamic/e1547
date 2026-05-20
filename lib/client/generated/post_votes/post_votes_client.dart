// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/create_post_vote_body.dart';
import '../models/create_post_vote_body_score.dart';
import '../models/lock_post_votes_body.dart';
import '../models/post_posts_post_id_votes_json_response.dart';
import '../models/post_vote.dart';

part 'post_votes_client.g.dart';

@RestApi()
abstract class PostVotesClient {
  factory PostVotesClient(Dio dio, {String? baseUrl}) = _PostVotesClient;

  /// Get a list of post votes.
  ///
  /// Returns a paginated list of post votes based on search criteria.
  ///
  /// [page] - The page number for pagination.
  ///
  /// [limit] - The number of post votes to retrieve per page.
  ///
  /// [searchPostId] - Filter by post ID.
  ///
  /// [searchUserName] - Filter by voter username.
  ///
  /// [searchUserId] - Filter by voter user ID.
  ///
  /// [searchPostCreatorId] - Filter by post uploader ID.
  ///
  /// [searchPostCreatorName] - Filter by post uploader username.
  ///
  /// [searchTimeframe] - Filter by votes within the last N days.
  ///
  /// [searchScore] - Filter by vote score (1 or -1).
  ///
  /// [searchUserIpAddr] - Filter by voter IP address (admin only).
  ///
  /// [searchDuplicatesOnly] - Show only duplicate IP votes (admin only).
  ///
  /// [searchOrder] - Sort order (admin only, supports ip_addr).
  @GET('/post_votes.json')
  Future<List<PostVote>> getPostVotes({
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('search[post_id]') int? searchPostId,
    @Query('search[user_name]') String? searchUserName,
    @Query('search[user_id]') int? searchUserId,
    @Query('search[post_creator_id]') int? searchPostCreatorId,
    @Query('search[post_creator_name]') String? searchPostCreatorName,
    @Query('search[timeframe]') int? searchTimeframe,
    @Query('search[score]') CreatePostVoteBodyScore? searchScore,
    @Query('search[user_ip_addr]') String? searchUserIpAddr,
    @Query('search[duplicates_only]') bool? searchDuplicatesOnly,
    @Query('search[order]') String? searchOrder,
  });

  /// Lock post votes.
  ///
  /// Locks the specified post votes, preventing further voting changes.
  @POST('/post_votes/lock.json')
  Future<void> lockPostVotes({
    @Body() required LockPostVotesBody body,
  });

  /// Delete post votes.
  ///
  /// Deletes the specified post votes.
  @POST('/post_votes/delete.json')
  Future<void> deletePostVotes({
    @Body() required LockPostVotesBody body,
  });

  /// Vote on a post.
  ///
  /// Casts a vote on the specified post. Voting again with the same score will remove the vote unless no_unvote is set.
  ///
  /// [postId] - The ID of the post to vote on.
  @POST('/posts/{post_id}/votes.json')
  Future<PostPostsPostIdVotesJsonResponse> createPostVote({
    @Path('post_id') required int postId,
    @Body() required CreatePostVoteBody body,
  });

  /// Remove vote from a post.
  ///
  /// Removes the current user's vote from the specified post.
  ///
  /// [postId] - The ID of the post to remove the vote from.
  @DELETE('/posts/{post_id}/votes.json')
  Future<void> deletePostVote({
    @Path('post_id') required int postId,
  });
}
