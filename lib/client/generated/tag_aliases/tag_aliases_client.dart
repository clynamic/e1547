// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/get_tag_aliases_search_order.dart';
import '../models/get_tag_aliases_search_status.dart';
import '../models/tag_alias.dart';

part 'tag_aliases_client.g.dart';

@RestApi()
abstract class TagAliasesClient {
  factory TagAliasesClient(Dio dio, {String? baseUrl}) = _TagAliasesClient;

  /// Get a list of tag aliases.
  ///
  /// Returns a list of tag aliases filtered by various criteria.
  ///
  /// [page] - The page number to retrieve.
  ///
  /// [limit] - The number of tag aliases to retrieve per page.
  ///
  /// [searchNameMatches] - Filter by matching names.
  ///
  /// [searchAntecedentName] - Filter by the antecedent name of the alias.
  ///
  /// [searchConsequentName] - Filter by the consequent name of the alias.
  ///
  /// [searchCreatorName] - Filter by the creator's username.
  ///
  /// [searchApproverName] - Filter by the approver's username.
  ///
  /// [searchAntecedentTagCategory] - Filter by the tag category of the antecedent tag.
  ///
  /// [searchConsequentTagCategory] - Filter by the tag category of the consequent tag.
  ///
  /// [searchStatus] - Filter by the status of the tag alias.
  ///
  /// [searchOrder] - Order the results by a specific field.
  ///
  /// [searchCreatedAt] - Filter by the creation date of the request.
  ///
  /// [searchUpdatedAt] - Filter by the last update date of the request.
  @GET('/tag_aliases.json')
  Future<List<TagAlias>> getTagAliases({
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('search[name_matches]') String? searchNameMatches,
    @Query('search[antecedent_name]') String? searchAntecedentName,
    @Query('search[consequent_name]') String? searchConsequentName,
    @Query('search[creator_name]') String? searchCreatorName,
    @Query('search[approver_name]') String? searchApproverName,
    @Query('search[antecedent_tag_category]') int? searchAntecedentTagCategory,
    @Query('search[consequent_tag_category]') int? searchConsequentTagCategory,
    @Query('search[status]') GetTagAliasesSearchStatus? searchStatus,
    @Query('search[order]') GetTagAliasesSearchOrder? searchOrder,
    @Query('search[created_at]') String? searchCreatedAt,
    @Query('search[updated_at]') String? searchUpdatedAt,
  });

  /// Get a tag alias by ID.
  ///
  /// Returns detailed information about a specific tag alias identified by its ID.
  ///
  /// [id] - The unique ID of the tag alias to retrieve.
  @GET('/tag_aliases/{id}.json')
  Future<TagAlias> getTagAlias({
    @Path('id') required int id,
  });
}
