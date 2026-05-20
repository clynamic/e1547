// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/post_related_tag_bulk_body.dart';
import '../models/preview_tags_body.dart';
import '../models/related_tag.dart';
import '../models/search_tags_search_order.dart';
import '../models/tag.dart';
import '../models/update_tag_body.dart';

part 'tags_client.g.dart';

@RestApi()
abstract class TagsClient {
  factory TagsClient(Dio dio, {String? baseUrl}) = _TagsClient;

  /// Search tags.
  ///
  /// [page] - The page number for pagination.
  ///
  /// [limit] - The number of results per page.
  ///
  /// [searchNameMatches] - Search by tag name pattern (supports wildcards).
  ///
  /// [searchName] - Filter by exact tag name (comma-separated for multiple).
  ///
  /// [searchCategory] - Filter by tag category ID (comma-separated for multiple).
  ///
  /// [searchHideEmpty] - Hide tags with no posts (default true).
  ///
  /// [searchHasWiki] - Filter by whether the tag has a wiki page.
  ///
  /// [searchHasArtist] - Filter by whether the tag has an artist entry.
  ///
  /// [searchIsLocked] - Filter by locked status.
  ///
  /// [searchFuzzyNameMatches] - Search by fuzzy tag name match.
  ///
  /// [searchOrder] - Sort order for results.
  @GET('/tags.json')
  Future<List<Tag>> searchTags({
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('search[name_matches]') String? searchNameMatches,
    @Query('search[name]') String? searchName,
    @Query('search[category]') String? searchCategory,
    @Query('search[hide_empty]') String? searchHideEmpty,
    @Query('search[has_wiki]') String? searchHasWiki,
    @Query('search[has_artist]') String? searchHasArtist,
    @Query('search[is_locked]') String? searchIsLocked,
    @Query('search[fuzzy_name_matches]') String? searchFuzzyNameMatches,
    @Query('search[order]') SearchTagsSearchOrder? searchOrder,
  });

  /// Get a tag by ID or name.
  ///
  /// [id] - The ID or name of the tag.
  @GET('/tags/{id}.json')
  Future<Tag> getTag({
    @Path('id') required String id,
  });

  /// Update a tag.
  ///
  /// [id] - The ID of the tag to update.
  @PUT('/tags/{id}.json')
  Future<Tag> updateTag({
    @Path('id') required int id,
    @Body() required UpdateTagBody body,
  });

  /// Preview tag information
  @POST('/tags/preview.json')
  Future<dynamic> previewTags({
    @Body() required PreviewTagsBody body,
  });

  /// Get related tags.
  ///
  /// Returns tags related to the given query tag.
  ///
  /// [searchQuery] - The tag to find related tags for.
  ///
  /// [searchCategoryId] - Filter by tag category ID.
  @GET('/related_tag.json')
  Future<RelatedTag> getRelatedTag({
    @Query('search[query]') required String searchQuery,
    @Query('search[category_id]') int? searchCategoryId,
  });

  /// Get related tags in bulk.
  ///
  /// Returns related tags for a bulk query.
  ///
  /// [query] - The tag query for bulk related tag lookup.
  ///
  /// [categoryId] - Filter by tag category ID.
  @GET('/related_tag/bulk.json')
  Future<RelatedTag> getRelatedTagBulk({
    @Query('query') required String query,
    @Query('category_id') int? categoryId,
  });

  /// Get related tags in bulk (POST).
  ///
  /// Returns related tags for a bulk query via POST.
  @POST('/related_tag/bulk.json')
  Future<RelatedTag> postRelatedTagBulk({
    @Body() required PostRelatedTagBulkBody body,
  });
}
