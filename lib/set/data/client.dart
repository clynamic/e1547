import 'package:dio/dio.dart';
import 'package:e1547/set/set.dart';
import 'package:e1547/shared/shared.dart';

class PostSetClient {
  PostSetClient({required this.dio});

  final Dio dio;

  Future<PostSet> get({required int id, CancelToken? cancelToken}) => dio
      .get('/post_sets/$id.json', cancelToken: cancelToken)
      .then((response) => E621PostSet.fromJson(response.data));

  Future<List<PostSet>> page({
    int? page,
    int? limit,
    QueryMap? query,
    CancelToken? cancelToken,
  }) => dio
      .get(
        '/post_sets.json',
        queryParameters: {'page': page, 'limit': limit, ...?query},
        cancelToken: cancelToken,
      )
      .then(unwrapRailsArray)
      .then(
        (response) => (response.data as List)
            .map<PostSet>((e) => E621PostSet.fromJson(e))
            .toList(),
      );
}
