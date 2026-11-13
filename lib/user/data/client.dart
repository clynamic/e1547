import 'package:dio/dio.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/user/user.dart';

class UserClient {
  UserClient({required this.dio});

  final Dio dio;

  // Technically missing users()
  Future<User> get({required int id, CancelToken? cancelToken}) =>
      _get(id.toString(), cancelToken: cancelToken);

  Future<User> getByName({required String name, CancelToken? cancelToken}) =>
      _get(name, cancelToken: cancelToken);

  Future<List<PartialUser>> page({
    int? page,
    int? limit,
    QueryMap? query,
    CancelToken? cancelToken,
  }) => dio
      .get(
        '/users.json',
        queryParameters: {'page': page, 'limit': limit, ...?query},
        cancelToken: cancelToken,
      )
      .then(unwrapRailsArray)
      .then(
        (response) => (response.data as List)
            .map<PartialUser>(E621User.partialFromJson)
            .toList(),
      );

  Future<List<PartialUser>> byIds({
    required List<int> ids,
    CancelToken? cancelToken,
  }) => page(
    limit: ids.length,
    query: {'search[id]': ids.join(',')},
    cancelToken: cancelToken,
  );

  Future<User> _get(String lookup, {CancelToken? cancelToken}) => dio
      .get('/users/$lookup.json', cancelToken: cancelToken)
      .then((response) => E621User.fromJson(response.data));
}
