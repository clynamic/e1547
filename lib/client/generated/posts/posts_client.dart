// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/get_popular_posts_scale.dart';
import '../models/get_posts_id_json_response.dart';
import '../models/post.dart';

part 'posts_client.g.dart';

@RestApi()
abstract class PostsClient {
  factory PostsClient(Dio dio, {String? baseUrl}) = _PostsClient;

  /// Get a list of posts.
  ///
  /// Returns a list of posts filtered by tags.
  ///
  /// When `v2=true`, the response uses the v2 Post format selected by `mode`.
  /// (`basic` default, `extended`, or `thumbnail`). Otherwise the legacy.
  /// format wrapped in `{ "posts": [...] }` is returned.
  ///
  /// [page] - The page number for pagination.
  ///
  /// [limit] - The number of posts to retrieve per page.
  ///
  /// [tags] - Filter posts by tags.
  @GET('/posts.json')
  Future<List<Post>> getPosts({
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('tags') String? tags,
  });

  /// Get a post by ID.
  ///
  /// Returns detailed information about a specific post identified by its ID.
  ///
  /// When `v2=true`, the response uses the v2 Post format selected by `mode`.
  /// (`basic` default, `extended`, or `thumbnail`). Otherwise the legacy.
  /// format wrapped in `{ "post": {...} }` is returned.
  ///
  /// [id] - The unique ID of the post to retrieve.
  @GET('/posts/{id}.json')
  Future<GetPostsIdJsonResponse> getPost({
    @Path('id') required int id,
  });

  /// Get popular posts.
  ///
  /// Returns a list of popular posts for a given date and time scale.
  ///
  /// Accepts the same `v2` and `mode` parameters as `/posts.json`.
  ///
  /// [date] - The date to get popular posts for (YYYY-MM-DD format).
  ///
  /// [scale] - The time scale for popularity.
  @GET('/popular.json')
  Future<List<Post>> getPopularPosts({
    @Query('date') DateTime? date,
    @Query('scale') GetPopularPostsScale? scale,
  });
}
