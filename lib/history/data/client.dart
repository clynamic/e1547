import 'dart:async';

import 'package:dio/dio.dart';
import 'package:e1547/history/history.dart';
import 'package:e1547/shared/shared.dart';

class HistoryClient {
  HistoryClient({required this.server, required this.dio});

  final HistoryServer server;
  final Dio dio;

  Future<History> get({
    required int id,
    bool? force,
    CancelToken? cancelToken,
  }) => server.get(id: id, force: force, cancelToken: cancelToken);

  Future<List<History>> page({
    int? page,
    int? limit,
    QueryMap? query,
    bool? force,
    CancelToken? cancelToken,
  }) => server.page(
    page: page,
    limit: limit,
    query: query,
    force: force,
    cancelToken: cancelToken,
  );

  Future<void> add(HistoryRequest request) => server.add(request);

  Future<void> remove(int id) => removeAll([id]);

  Future<void> removeAll(List<int>? ids) => server.removeAll(ids);

  Future<int> count() => server.count();

  Future<List<DateTime>> days() => server.days();
}
