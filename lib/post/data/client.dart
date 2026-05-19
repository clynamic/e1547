import 'dart:math';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';

class PostClient {
  PostClient({required this.dio});

  final Dio dio;

  Future<Post> get({required int id, bool? force, CancelToken? cancelToken}) =>
      dio
          .get(
            '/posts/$id.json',
            cancelToken: cancelToken,
            options: forceOptions(force),
          )
          .then(unwrapRailsArray)
          .then((response) => E621Post.fromJson(response.data));

  Future<List<Post>> page({
    int? page,
    int? limit,
    QueryMap? query,
    bool? force,
    CancelToken? cancelToken,
  }) => dio
      .get(
        '/posts.json',
        queryParameters: {'page': page, 'limit': limit, ...?query}.toQuery(),
        cancelToken: cancelToken,
        options: forceOptions(force),
      )
      .then(unwrapRailsArray)
      .then(
        (response) =>
            (response.data as List).map<Post>(E621Post.fromJson).toList(),
      )
      .then(_filter);

  /// Filters out "broken" posts.
  /// Flash posts are considered to be broken by default, since we will not be able to display them.
  /// Censored posts, which have contentious tags and are unavailable to anonymous users, are also considered broken.
  /// Posts which are not deleted but have no file are censored.
  List<Post> _filter(List<Post> posts) => posts
      .whereNot((post) => !post.isDeleted && post.file == null)
      .whereNot((post) => post.ext == 'swf')
      .toList();

  Future<List<Post>> byIds({
    required List<int> ids,
    int? limit,
    bool? force,
    CancelToken? cancelToken,
  }) async {
    limit = max(0, min(limit ?? 75, 100));

    List<List<int>> chunks = [];
    for (int i = 0; i < ids.length; i += limit) {
      chunks.add(ids.sublist(i, min(i + limit, ids.length)));
    }

    List<Post> result = [];
    for (final chunk in chunks) {
      if (chunk.isEmpty) continue;
      String filter = 'id:${chunk.join(',')}';
      List<Post> part = await page(
        query: {'tags': filter},
        limit: limit,
        force: force,
        cancelToken: cancelToken,
      );
      Map<int, Post> table = {for (Post e in part) e.id: e};
      part =
          (chunk.map((e) => table[e]).toList()..removeWhere((e) => e == null))
              .cast<Post>();
      result.addAll(part);
    }
    return result;
  }

  Future<List<Post>> byTags({
    required List<String> tags,
    int? page,
    int? limit,
    bool? force,
    CancelToken? cancelToken,
  }) async {
    page ??= 1;
    tags.removeWhere((e) => e.contains(' ') || e.contains(':'));
    if (tags.isEmpty) return [];
    int max = 40;
    int pages = (tags.length / max).ceil();
    int chunkSize = (tags.length / pages).ceil();

    int tagPage = page % pages != 0 ? page % pages : pages;
    int sitePage = (page / pages).ceil();

    List<String> chunk = tags
        .sublist((tagPage - 1) * chunkSize)
        .take(chunkSize)
        .toList();
    String filter = chunk.map((e) => '~$e').join(' ');
    return this.page(
      page: sitePage,
      query: {'tags': filter},
      limit: limit,
      force: force,
      cancelToken: cancelToken,
    );
  }

  Future<void> update({required int id, required Map<String, String?> data}) =>
      dio.put('/posts/$id.json', data: FormData.fromMap(data));

  Future<void> vote({
    required int id,
    required bool upvote,
    required bool replace,
  }) => dio.post(
    '/posts/$id/votes.json',
    queryParameters: {'score': upvote ? 1 : -1, 'no_unvote': replace},
  );

  Future<List<Post>> favorites({
    int? page,
    int? limit,
    QueryMap? query,
    bool? force,
    CancelToken? cancelToken,
  }) => dio
      .get(
        '/favorites.json',
        queryParameters: {
          'page': page,
          'limit': limit,
          // may not contain tags, or we get redirected to a html page
          ...?(query?..remove('tags')),
        },
        options: forceOptions(force),
        cancelToken: cancelToken,
      )
      .then(unwrapRailsArray)
      .then(
        (response) => (response.data as List<dynamic>)
            .map<Post>(E621Post.fromJson)
            .where((post) => !post.isDeleted && post.file != null)
            .toList(),
      );

  Future<void> addFavorite(int postId) =>
      dio.post('/favorites.json', queryParameters: {'post_id': postId});

  Future<void> removeFavorite(int postId) =>
      dio.delete('/favorites/$postId.json');
}
