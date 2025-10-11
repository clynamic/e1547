import 'package:dio/dio.dart';
import 'package:e1547/comment/comment.dart';
import 'package:e1547/shared/shared.dart';

class CommentClient {
  CommentClient({required this.dio});

  final Dio dio;

  Future<Comment> get({
    required int id,
    bool? force,
    CancelToken? cancelToken,
  }) => dio
      .get(
        '/comments/$id.json',
        options: forceOptions(force),
        cancelToken: cancelToken,
      )
      .then((response) => E621Comment.fromJson(response.data));

  Future<List<Comment>> page({
    int? page,
    int? limit,
    QueryMap? query,
    bool? force,
    CancelToken? cancelToken,
  }) => dio
      .get(
        '/comments.json',
        queryParameters: {'page': page, 'limit': limit, ...?query}.toQuery(),
        options: forceOptions(force),
        cancelToken: cancelToken,
      )
      .then(unwrapRailsArray)
      .then(
        (response) =>
            (response.data as List).map<Comment>(E621Comment.fromJson).toList(),
      );

  Future<void> create({required int postId, required String content}) =>
      dio.post(
        '/comments.json',
        data: FormData.fromMap({
          'comment[body]': content,
          'comment[post_id]': postId,
        }),
      );

  Future<void> update({
    required int id,
    required int postId,
    required String content,
  }) => dio.patch(
    '/comments/$id.json',
    data: FormData.fromMap({'comment[body]': content}),
  );

  Future<VoteResult> vote({
    required int id,
    required bool upvote,
    required bool replace,
  }) => dio
      .post(
        '/comments/$id/votes.json',
        queryParameters: {'score': upvote ? 1 : -1, 'no_unvote': replace},
      )
      .then((response) => VoteResult.fromJson(response.data));
}
