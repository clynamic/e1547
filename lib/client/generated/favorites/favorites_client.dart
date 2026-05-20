// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/add_favorite_body.dart';
import '../models/delete_favorites_id_json_response.dart';
import '../models/get_posts_post_id_favorites_json_response.dart';
import '../models/post.dart';
import '../models/post_favorites_json_response.dart';

part 'favorites_client.g.dart';

@RestApi()
abstract class FavoritesClient {
  factory FavoritesClient(Dio dio, {String? baseUrl}) = _FavoritesClient;

  /// Get a list of favorited posts.
  ///
  /// Returns a list of posts favorited by the specified user or the current user.
  ///
  /// Accepts the same `v2` and `mode` parameters as `/posts.json`.
  ///
  /// [userId] - The user ID whose favorites to retrieve (defaults to current user).
  ///
  /// [page] - The page number for pagination.
  ///
  /// [limit] - The number of posts to retrieve per page.
  @GET('/favorites.json')
  Future<List<Post>> getFavorites({
    @Query('user_id') int? userId,
    @Query('page') int? page,
    @Query('limit') int? limit,
  });

  /// Favorite a post
  @POST('/favorites.json')
  Future<PostFavoritesJsonResponse> addFavorite({
    @Body() required AddFavoriteBody body,
  });

  /// Unfavorite a post.
  ///
  /// [id] - The ID of the post to unfavorite.
  @DELETE('/favorites/{id}.json')
  Future<DeleteFavoritesIdJsonResponse> removeFavorite({
    @Path('id') required int id,
  });

  /// Get users who favorited a post.
  ///
  /// Returns a paginated list of users who favorited the specified post.
  ///
  /// [postId] - The ID of the post.
  ///
  /// [page] - The page number for pagination.
  ///
  /// [limit] - The number of users to retrieve per page (max 100).
  @GET('/posts/{post_id}/favorites.json')
  Future<List<GetPostsPostIdFavoritesJsonResponse>> getPostFavorites({
    @Path('post_id') required int postId,
    @Query('page') int? page,
    @Query('limit') int? limit,
  });
}
