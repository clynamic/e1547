import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

IconData _postUnavailableIcon(BuildContext context) =>
    context.watch<Client>().hasLogin ? Icons.hide_image_outlined : Icons.lock;

const IconData _postDeletedIcon = Icons.delete;

const IconData _postUnsupportedIcon = Icons.open_in_new;

IconData? postFileIcon(BuildContext context, PostSummary post) {
  if (post.isDeleted) return _postDeletedIcon;
  if (post.file == null) return _postUnavailableIcon(context);
  if (post.type == PostType.unsupported) return _postUnsupportedIcon;
  return null;
}

class PostImageOverlay extends StatelessWidget {
  const PostImageOverlay({
    super.key,
    required this.post,
    required this.builder,
  });

  final Post post;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    if (post.file == null) {
      if (post.isDeleted) {
        return const IconMessage(
          title: Text('Post was deleted'),
          icon: Icon(_postDeletedIcon),
        );
      }

      return IconMessage(
        title: const Text('Post is unavailable'),
        icon: Icon(_postUnavailableIcon(context)),
      );
    }

    PostFilter? filter = context.watch<PostFilter?>();
    if ((filter?.denies(post) ?? false) && !post.isFavorited) {
      return const IconMessage(
        title: Text('Post is blacklisted'),
        icon: Icon(Icons.block),
      );
    }

    if (post.type == PostType.unsupported) {
      return IconMessage(
        title: Text('${post.ext} files are not supported'),
        icon: const Icon(_postUnsupportedIcon),
        action: Padding(
          padding: const EdgeInsets.all(4),
          child: TextButton(
            onPressed: () async => launch(post.file!),
            child: const Text('Open'),
          ),
        ),
      );
    }

    return builder(context);
  }
}
