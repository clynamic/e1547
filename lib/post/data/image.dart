import 'package:cached_network_image/cached_network_image.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

enum PostImageSize { preview, sample, file }

Future<void> preloadPostImage({
  required BuildContext context,
  required Post post,
  required PostImageSize size,
}) async {
  String? url = switch (size) {
    PostImageSize.preview => post.preview,
    PostImageSize.sample => post.sample,
    PostImageSize.file => post.file,
  };
  if (post.type != PostType.image) return;
  if (url == null) return;
  final manager = context.read<BaseCacheManager>();
  if (size == PostImageSize.file) {
    // Decoding originals ahead of time would fill the image cache with
    // multi-megabyte bitmaps that a capped decode cannot even reuse.
    // They are only fetched to disk instead and get decoded,
    // at a capped size, once they are actually shown.
    try {
      await manager.getSingleFile(url);
    } on Exception {
      // A failed prefetch must not break preloading;
      // the image downloads again when it is shown.
    }
    return;
  }
  await precacheImage(
    CachedNetworkImageProvider(url, cacheManager: manager),
    context,
    onError: (error, stack) {},
  );
}

Future<void> preloadPostImages({
  required BuildContext context,
  required int index,
  required List<Post> posts,
  required PostImageSize size,
  int reach = 1,
}) async {
  for (int i = -(reach + 1); i < reach; i++) {
    int target = index + 1 + i;
    if (0 <= target && target < posts.length) {
      Post post = posts[target];
      if (post.type == PostType.image && post.file != null) {
        if (!context.mounted) return;
        await preloadPostImage(context: context, post: post, size: size);
      }
    }
  }
}
