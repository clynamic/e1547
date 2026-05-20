// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/create_user_body.dart';
import '../models/get_users_search_order.dart';
import '../models/update_user_body.dart';
import '../models/user.dart';
import '../models/user_profile.dart';

part 'users_client.g.dart';

@RestApi()
abstract class UsersClient {
  factory UsersClient(Dio dio, {String? baseUrl}) = _UsersClient;

  /// Get a list of users.
  ///
  /// Returns a list of users based on search criteria.
  ///
  /// [page] - The page number to retrieve.
  ///
  /// [limit] - The number of users to retrieve per page.
  ///
  /// [searchId] - Filter by user ID.
  ///
  /// [searchName] - Filter by username.
  ///
  /// [searchAbout] - Filter by user's "About" section.
  ///
  /// [searchAvatarId] - Filter by avatar ID.
  ///
  /// [searchLevel] - Filter by user's access level.
  ///
  /// [searchMinLevel] - Filter by minimum access level.
  ///
  /// [searchMaxLevel] - Filter by maximum access level.
  ///
  /// [searchCanUploadFree] - Filter by upload permissions.
  ///
  /// [searchCanApprovePosts] - Filter by post approval permissions.
  ///
  /// [searchOrder] - Order the results by a specific field.
  @GET('/users.json')
  Future<List<User>> getUsers({
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('search[id]') String? searchId,
    @Query('search[name]') String? searchName,
    @Query('search[about]') String? searchAbout,
    @Query('search[avatar_id]') int? searchAvatarId,
    @Query('search[level]') int? searchLevel,
    @Query('search[min_level]') int? searchMinLevel,
    @Query('search[max_level]') int? searchMaxLevel,
    @Query('search[can_upload_free]') bool? searchCanUploadFree,
    @Query('search[can_approve_posts]') bool? searchCanApprovePosts,
    @Query('search[order]') GetUsersSearchOrder? searchOrder,
  });

  /// Create a new user account.
  ///
  /// Registers a new user account. Only available when not logged in and signups are enabled.
  @POST('/users.json')
  Future<User> createUser({
    @Body() required CreateUserBody body,
  });

  /// Get user information by ID or username.
  ///
  /// Returns detailed information about a user identified by their ID or username.
  ///
  /// [id] - The ID or username of the user to retrieve.
  @GET('/users/{id}.json')
  Future<UserProfile> getUser({
    @Path('id') required String id,
  });

  /// Update the current user's settings.
  ///
  /// Updates the currently authenticated user's account settings. Users can only update their own account unless they are an admin.
  ///
  /// [id] - The ID of the user to update (must be the current user unless admin).
  @PATCH('/users/{id}.json')
  Future<UserProfile> updateUser({
    @Path('id') required int id,
    @Body() required UpdateUserBody body,
  });

  /// Get the current authenticated user.
  ///
  /// Returns the currently authenticated user's full profile information.
  @GET('/users/me.json')
  Future<UserProfile> getCurrentUser();

  /// Get a user's upload limit information.
  ///
  /// Returns detailed upload limit information for a user.
  ///
  /// [id] - The ID or username of the user.
  @GET('/users/{id}/upload_limit.json')
  Future<UserProfile> getUserUploadLimit({
    @Path('id') required String id,
  });
}
