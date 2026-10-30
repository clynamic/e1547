import 'package:dio/dio.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/user/user.dart';

class UserClient {
  UserClient({required this.dio});

  final Dio dio;

  late final QueryBatch<int> summaryBatch = QueryBatch(
    (ids) async => summaryCache.savePage(await summaries(ids: ids)),
    cached: (id) => summaryCache.get(id) != null,
  );

  // Technically missing users()
  Future<User> get({required int id, CancelToken? cancelToken}) =>
      _get(id.toString(), cancelToken: cancelToken);

  Future<User> getByName({required String name, CancelToken? cancelToken}) =>
      _get(name, cancelToken: cancelToken);

  Future<List<User>> summaries({
    required List<int> ids,
    CancelToken? cancelToken,
  }) => dio
      .get(
        '/users.json',
        queryParameters: {'search[id]': ids.join(','), 'limit': ids.length},
        cancelToken: cancelToken,
      )
      .then(unwrapRailsArray)
      .then(
        (response) =>
            response.data.map<User>(E621User.summaryFromJson).toList(),
      );

  Future<User> _get(String lookup, {CancelToken? cancelToken}) => dio
      .get('/users/$lookup.json', cancelToken: cancelToken)
      .then((response) => E621User.fromJson(response.data));
}
