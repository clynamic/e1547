import 'package:dio/dio.dart';
import 'package:e1547/reply/reply.dart';
import 'package:e1547/shared/shared.dart';

class ReplyClient {
  ReplyClient({required this.dio});

  final Dio dio;

  Future<Reply> get({required int id, bool? force, CancelToken? cancelToken}) =>
      dio
          .get(
            '/forum_posts/$id.json',
            options: forceOptions(force),
            cancelToken: cancelToken,
          )
          .then((response) => E621Reply.fromJson(response.data));

  Future<List<Reply>> page({
    int? page,
    int? limit,
    QueryMap? query,
    bool? force,
    CancelToken? cancelToken,
  }) => dio
      .get(
        '/forum_posts.json',
        queryParameters: {'page': page, 'limit': limit, ...?query}.toQuery(),
        options: forceOptions(force),
        cancelToken: cancelToken,
      )
      .then(unwrapRailsArray)
      .then(
        (response) => (response.data as List)
            .map<Reply>((e) => E621Reply.fromJson(e))
            .toList(),
      );
}
