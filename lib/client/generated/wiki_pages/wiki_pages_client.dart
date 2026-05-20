// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/create_wiki_page_body.dart';
import '../models/search_wiki_pages_search_order.dart';
import '../models/update_wiki_page_body.dart';
import '../models/wiki_page.dart';

part 'wiki_pages_client.g.dart';

@RestApi()
abstract class WikiPagesClient {
  factory WikiPagesClient(Dio dio, {String? baseUrl}) = _WikiPagesClient;

  /// Search wiki pages.
  ///
  /// [page] - The page number for pagination.
  ///
  /// [limit] - The number of results per page.
  ///
  /// [searchTitle] - Filter by title (supports wildcards).
  ///
  /// [searchBodyMatches] - Search by body text.
  ///
  /// [searchOtherNamesMatch] - Search by other names.
  ///
  /// [searchCreatorId] - Filter by creator user ID.
  ///
  /// [searchCreatorName] - Filter by creator username.
  ///
  /// [searchHideDeleted] - Hide deleted wiki pages.
  ///
  /// [searchParent] - Filter by parent wiki page.
  ///
  /// [searchOtherNamesPresent] - Filter by whether other names are present.
  ///
  /// [searchIsLocked] - Filter by locked status.
  ///
  /// [searchIsDeleted] - Filter by deleted status.
  ///
  /// [searchOrder] - Sort order for results.
  @GET('/wiki_pages.json')
  Future<List<WikiPage>> searchWikiPages({
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('search[title]') String? searchTitle,
    @Query('search[body_matches]') String? searchBodyMatches,
    @Query('search[other_names_match]') String? searchOtherNamesMatch,
    @Query('search[creator_id]') int? searchCreatorId,
    @Query('search[creator_name]') String? searchCreatorName,
    @Query('search[hide_deleted]') String? searchHideDeleted,
    @Query('search[parent]') String? searchParent,
    @Query('search[other_names_present]') String? searchOtherNamesPresent,
    @Query('search[is_locked]') String? searchIsLocked,
    @Query('search[is_deleted]') String? searchIsDeleted,
    @Query('search[order]') SearchWikiPagesSearchOrder? searchOrder,
  });

  /// Create a wiki page
  @POST('/wiki_pages.json')
  Future<WikiPage> createWikiPage({
    @Body() required CreateWikiPageBody body,
  });

  /// Get a wiki page by ID or title.
  ///
  /// [id] - The ID or title of the wiki page.
  @GET('/wiki_pages/{id}.json')
  Future<WikiPage> getWikiPage({
    @Path('id') required String id,
  });

  /// Update a wiki page.
  ///
  /// [id] - The ID of the wiki page to update.
  @PUT('/wiki_pages/{id}.json')
  Future<WikiPage> updateWikiPage({
    @Path('id') required int id,
    @Body() required UpdateWikiPageBody body,
  });

  /// Delete a wiki page.
  ///
  /// [id] - The ID of the wiki page to delete.
  @DELETE('/wiki_pages/{id}.json')
  Future<void> deleteWikiPage({
    @Path('id') required int id,
  });

  /// Revert a wiki page to a previous version.
  ///
  /// [id] - The ID of the wiki page to revert.
  ///
  /// [versionId] - The ID of the version to revert to.
  @PUT('/wiki_pages/{id}/revert.json')
  Future<WikiPage> revertWikiPage({
    @Path('id') required int id,
    @Query('version_id') required int versionId,
  });

  /// Show an existing wiki page or prepare to create a new one.
  ///
  /// [title] - The title to look up or create.
  @GET('/wiki_pages/show_or_new.json')
  Future<WikiPage> showOrNewWikiPage({
    @Query('title') String? title,
  });
}
