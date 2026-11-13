import 'package:dio/dio.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/shared/shared.dart';

class PoolClient {
  PoolClient({required this.dio});

  final Dio dio;

  Future<Pool> get({required int id, CancelToken? cancelToken}) => dio
      .get('/pools/$id.json', cancelToken: cancelToken)
      .then((response) => E621Pool.fromJson(response.data));

  Future<List<Pool>> page({
    int? page,
    int? limit,
    QueryMap? query,
    CancelToken? cancelToken,
  }) => dio
      .get(
        '/pools.json',
        queryParameters: {'page': page, 'limit': limit, ...?query},
        cancelToken: cancelToken,
      )
      .then(unwrapRailsArray)
      .then(
        (response) => (response.data as List)
            .map<Pool>((e) => E621Pool.fromJson(e))
            .toList(),
      );

  Future<List<Pool>> byIds({
    required List<int> ids,
    CancelToken? cancelToken,
  }) => page(
    limit: ids.length,
    query: {'search[id]': ids.join(',')},
    cancelToken: cancelToken,
  );
}
