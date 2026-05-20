// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/add_pool_element_body.dart';
import '../models/create_pool_body.dart';
import '../models/get_artists_search_order.dart';
import '../models/get_pool_element_recent_json_response.dart';
import '../models/pool.dart';
import '../models/pool_category.dart';
import '../models/pool_version.dart';
import '../models/update_pool_body.dart';

part 'pools_client.g.dart';

@RestApi()
abstract class PoolsClient {
  factory PoolsClient(Dio dio, {String? baseUrl}) = _PoolsClient;

  /// Search pools.
  ///
  /// Returns a paginated list of pools matching the given search criteria.
  ///
  /// [page] - The page number for pagination.
  ///
  /// [limit] - The number of pools to retrieve per page.
  ///
  /// [searchNameMatches] - Filter by pool name (wildcards supported).
  ///
  /// [searchDescriptionMatches] - Filter by description text.
  ///
  /// [searchCreatorId] - Filter by creator user ID.
  ///
  /// [searchCreatorName] - Filter by creator username.
  ///
  /// [searchCategory] - Filter by pool category.
  ///
  /// [searchIsActive] - Filter by active status.
  ///
  /// [searchOrder] - Sort order.
  @GET('/pools.json')
  Future<List<Pool>> searchPools({
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('search[name_matches]') String? searchNameMatches,
    @Query('search[description_matches]') String? searchDescriptionMatches,
    @Query('search[creator_id]') int? searchCreatorId,
    @Query('search[creator_name]') String? searchCreatorName,
    @Query('search[category]') PoolCategory? searchCategory,
    @Query('search[is_active]') String? searchIsActive,
    @Query('search[order]') GetArtistsSearchOrder? searchOrder,
  });

  /// Create a new pool
  @POST('/pools.json')
  Future<Pool> createPool({
    @Body() required CreatePoolBody body,
  });

  /// Get a pool by ID.
  ///
  /// [id] - The ID of the pool.
  @GET('/pools/{id}.json')
  Future<Pool> getPool({
    @Path('id') required int id,
  });

  /// Update a pool.
  ///
  /// [id] - The ID of the pool to update.
  @PUT('/pools/{id}.json')
  Future<Pool> updatePool({
    @Path('id') required int id,
    @Body() required UpdatePoolBody body,
  });

  /// Delete a pool.
  ///
  /// [id] - The ID of the pool to delete.
  @DELETE('/pools/{id}.json')
  Future<void> deletePool({
    @Path('id') required int id,
  });

  /// Search pool versions.
  ///
  /// Returns a paginated list of pool version history entries.
  ///
  /// [page] - The page number for pagination.
  ///
  /// [limit] - The number of versions to retrieve per page.
  ///
  /// [searchPoolId] - Filter by pool ID.
  ///
  /// [searchUpdaterId] - Filter by updater user ID.
  ///
  /// [searchUpdaterName] - Filter by updater username.
  ///
  /// [searchIpAddr] - Filter by IP address (admin only).
  @GET('/pool_versions.json')
  Future<List<PoolVersion>> searchPoolVersions({
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('search[pool_id]') int? searchPoolId,
    @Query('search[updater_id]') int? searchUpdaterId,
    @Query('search[updater_name]') String? searchUpdaterName,
    @Query('search[ip_addr]') String? searchIpAddr,
  });

  /// Add a post to a pool
  @POST('/pool_element.json')
  Future<Pool> addPoolElement({
    @Body() required AddPoolElementBody body,
  });

  /// Remove a post from a pool.
  ///
  /// [poolId] - The ID of the pool.
  ///
  /// [poolName] - The name of the pool (alternative to pool_id).
  ///
  /// [postId] - The ID of the post to remove.
  @DELETE('/pool_element.json')
  Future<Pool> removePoolElement({
    @Query('post_id') required int postId,
    @Query('pool_id') int? poolId,
    @Query('pool_name') String? poolName,
  });

  /// Get recently used pools.
  ///
  /// Returns a list of pools the current user recently added posts to.
  @GET('/pool_element/recent.json')
  Future<List<GetPoolElementRecentJsonResponse>> getRecentPoolElements();
}
