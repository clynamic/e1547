import 'package:e1547/shared/shared.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'params.freezed.dart';

enum PostSetOrder {
  updatedAt('updated_at', 'Recently updated', 'last updated'),
  name('name', 'Name', 'by name'),
  createdAt('id_desc', 'Newest', 'newest first'),
  postCount('post_count', 'Most posts', 'most posts');

  const PostSetOrder(this.value, this.label, this.words);

  final String value;
  final String label;
  final String words;
}

@freezed
abstract class PostSetParams with _$PostSetParams {
  const factory PostSetParams({
    String? name,
    String? creator,
    PostSetOrder? order,
  }) = _PostSetParams;

  const PostSetParams._();

  QueryMap toQuery() => <String, Object?>{
    'search[name]': name,
    'search[creator_name]': creator,
    'search[order]': (order ?? PostSetOrder.updatedAt).value,
  }.toQuery();
}

class PostSetParamsController extends ValueNotifier<PostSetParams> {
  PostSetParamsController([PostSetParams? initial])
    : super(initial ?? const PostSetParams());
}
