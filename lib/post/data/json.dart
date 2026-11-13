import 'package:deep_pick/deep_pick.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';

abstract final class E621Post {
  static List<String> _words(Pick pick) =>
      (pick.asStringOrNull() ?? '').split(' ').trim();

  static PartialPost partialFromJson(dynamic json) => pick(json).letOrThrow(
    (post) => PartialPost(
      id: post('id').asIntOrThrow(),
      file: post('file_url').asStringOrNull(),
      sample: post('sample_url').asStringOrNull(),
      preview: post('preview_url').asStringOrNull(),
      width: post('width').asIntOrThrow(),
      height: post('height').asIntOrThrow(),
      ext: post('file_ext').asStringOrThrow(),
      size: post('size').asIntOrThrow(),
      uploaderId: post('uploader_id').asIntOrThrow(),
      uploaderName: post('uploader').asStringOrNull(),
      createdAt: post('created_at').asDateTimeOrThrow(),
      score: post('score').asIntOrThrow(),
      favCount: post('fav_count').asIntOrThrow(),
      isFavorited: post('is_favorited').asBoolOrFalse(),
      vote: post('vote').asIntOrNull(),
      commentCount: post('comment_count').asIntOrThrow(),
      isDeleted: _words(post('flags')).contains('deleted'),
      rating: Rating.values.asNameMap()[post('rating').asStringOrThrow()]!,
      tags: _words(post('tags')),
      pools: _words(post('pools')).map(int.parse).toList(),
    ),
  );

  static Post fromJson(dynamic json) => pick(json).letOrThrow(
    (post) => Post(
      id: post('id').asIntOrThrow(),
      file: post('files', 'original', 'url').asStringOrNull(),
      sample: post('files', 'meta', 'has_sample').asBoolOrThrow()
          ? post('files', 'sample', 'jpg').asStringOrNull()
          : null,
      preview: post('files', 'preview', 'jpg').asStringOrNull(),
      width: post('files', 'original', 'width').asIntOrThrow(),
      height: post('files', 'original', 'height').asIntOrThrow(),
      ext: post('files', 'meta', 'ext').asStringOrThrow(),
      size: post('files', 'meta', 'size').asIntOrThrow(),
      variants: post('files', 'video').letOrNull((video) {
        if (video.asMapOrNull()?.isEmpty ?? true) return null;
        return {
          '${video('original', 'width').asIntOrThrow()}x${video('original', 'height').asIntOrThrow()}':
              video('original', 'url').asStringOrNull(),
          ...video('samples').asMapOrEmpty().values.fold<Map<String, String?>>(
            {},
            (acc, e) {
              final w = pick(e, 'width').asIntOrNull();
              final h = pick(e, 'height').asIntOrNull();
              final url = pick(e, 'url').asStringOrNull();
              if (w != null && h != null && url != null) {
                acc['${w}x$h'] = url;
              }
              return acc;
            },
          ),
        };
      }),
      tags: post('tags').letOrThrow(
        (pick) => pick.asMapOrThrow<String, List<dynamic>>().map(
          (key, value) => MapEntry(key, List.from(value)),
        ),
      ),
      uploaderId: post('uploader_id').asIntOrThrow(),
      uploaderName: post('uploader_name').asStringOrNull(),
      createdAt: post('created_at').asDateTimeOrThrow(),
      updatedAt: post('updated_at').asDateTimeOrNull(),
      score: post('stats', 'score', 'total').asIntOrThrow(),
      vote: post('stats', 'vote').asIntOrNull(),
      isDeleted: post('flags', 'deleted').asBoolOrThrow(),
      rating: post(
        'rating',
      ).letOrThrow((pick) => Rating.values.asNameMap()[pick.asString()]!),
      favCount: post('stats', 'fav_count').asIntOrThrow(),
      isFavorited: post('stats', 'is_favorited').asBoolOrThrow(),
      commentCount: post('stats', 'comment_count').asIntOrThrow(),
      description: post('description').asStringOrThrow(),
      sources: post('sources').asListOrThrow((pick) => pick.asStringOrThrow()),
      pools: post('pools').asListOrThrow((pick) => pick.asIntOrThrow()),
      relationships: Relationships(
        parentId: post('relationships', 'parent_id').asIntOrNull(),
        hasChildren: post('has', 'children').asBoolOrThrow(),
        hasActiveChildren: post('has', 'active_children').asBoolOrNull(),
        children: post(
          'relationships',
          'children',
        ).asListOrThrow((pick) => pick.asIntOrThrow()),
      ),
    ),
  );
}
