import 'package:dio/dio.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';

class TagClient {
  TagClient({required this.dio});

  final Dio dio;

  Set<String> _batch = {};
  Future<List<TagPreview>>? _batched;

  // Technically missing get()
  Future<List<Tag>> page({
    int? page,
    int? limit,
    QueryMap? query,
    CancelToken? cancelToken,
  }) => dio
      .get(
        '/tags.json',
        queryParameters: {'page': page, 'limit': limit, ...?query},
        cancelToken: cancelToken,
      )
      .then(unwrapRailsArray)
      .then((response) => response.data.map<Tag>(E621Tag.fromJson).toList());

  Future<List<TagPreview>> preview({
    required String tags,
    CancelToken? cancelToken,
  }) => dio
      .post(
        '/tags/preview.json',
        data: {'tags': tags},
        cancelToken: cancelToken,
      )
      .then(unwrapRailsArray)
      .then(
        (response) => response.data
            .map<TagPreview>(
              (json) => TagPreview.fromJson(json as Map<String, dynamic>),
            )
            .toList(),
      );

  Future<List<TagPreview>> previewBatched(Iterable<String> names) {
    _batch.addAll(names);
    return _batched ??= Future(() {
      final String tags = _batch.join(' ');
      _batch = {};
      _batched = null;
      return preview(tags: tags);
    });
  }

  Future<List<Tag>> autocomplete({
    String? search,
    int? limit,
    int? category,
    CancelToken? cancelToken,
  }) async {
    search ??= '';
    if (search.contains(':')) return [];
    if (category == null) {
      if (search.length < 3) return [];
      return dio
          .get(
            '/tags/autocomplete.json',
            queryParameters: {'search[name_matches]': search},
            cancelToken: cancelToken,
          )
          .then(unwrapRailsArray)
          .then(
            (response) =>
                response.data.map<Tag>(E621Tag.fromJson).take(3).toList(),
          );
    } else {
      return page(
        limit: limit,
        query: {
          'search[name_matches]': '$search*',
          'search[category]': category,
          'search[order]': 'count',
        }.toQuery(),
      );
    }
  }

  Future<String?> aliases({
    int? page,
    int? limit,
    QueryMap? query,
    CancelToken? cancelToken,
  }) => dio
      .get(
        '/tag_aliases.json',
        queryParameters: {'page': page, 'limit': limit, ...?query},
        cancelToken: cancelToken,
      )
      .then(unwrapRailsArray)
      .then((response) {
        return (response.data as List)
            .cast<Map<String, dynamic>>()
            .where((e) => e['status'] != 'deleted')
            .map((e) => e['consequent_name'] as String?)
            .firstOrNull;
      });
}
