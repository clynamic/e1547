import 'dart:math';

import 'package:e1547/client/client.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';

const double postRelationPreviewSize = 92;

/// Square preview of a related post.
///
/// Shows an empty card while it loads, and a dim icon when it cannot be shown.
class PostRelationPreview extends StatelessWidget {
  const PostRelationPreview({
    super.key,
    required this.id,
    this.size = postRelationPreviewSize,
    this.onTap,
  });

  final int id;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Client client = context.watch<Client>();
    final FilterController<Post>? filter = context
        .watch<FilterController<Post>?>();
    return QueryBuilder(
      query: client.posts.useGet(id: id),
      builder: (context, state) {
        final Post? post = state.data;
        final bool denied =
            post != null && filter != null && !filter.filter(post);
        final VoidCallback open =
            onTap ?? () => pushPostLoadingPage(context, id);
        if (post != null && !denied) {
          return PostRowTile(post: post, size: size, onTap: open);
        }
        return RelationPreviewCard(
          size: size,
          onTap: open,
          child: RelationPreviewIcon(
            icon: denied
                ? Icons.block
                : state.error != null
                ? Icons.warning_amber_outlined
                : null,
          ),
        );
      },
    );
  }
}

class PostThumbnail extends StatelessWidget {
  const PostThumbnail({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    final Widget thumbnail = PostRelationPreview(id: id);
    if (context.read<FilterController<Post>?>() != null) return thumbnail;
    final Client client = context.watch<Client>();
    return FilterControllerProvider<PostFilter, Post>(
      create: (_) => PostFilter(client),
      keys: (_) => [client],
      child: thumbnail,
    );
  }
}

/// Square shell every relation preview is drawn in.
class RelationPreviewCard extends StatelessWidget {
  const RelationPreviewCard({
    super.key,
    this.size = postRelationPreviewSize,
    this.onTap,
    this.child,
  });

  final double size;
  final VoidCallback? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ?child,
          Material(
            type: MaterialType.transparency,
            child: InkWell(onTap: onTap),
          ),
        ],
      ),
    ),
  );
}

/// Reason a relation preview holds no image, or nothing while it loads.
class RelationPreviewIcon extends StatelessWidget {
  const RelationPreviewIcon({super.key, required this.icon});

  final IconData? icon;

  @override
  Widget build(BuildContext context) => CrossFade(
    showChild: icon != null,
    child: Center(child: Dimmed(child: Icon(icon))),
  );
}

/// Related post shown with its id and artists beside the preview.
class PostRelationTile extends StatelessWidget {
  const PostRelationTile({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    final Client client = context.watch<Client>();
    return QueryBuilder(
      query: client.posts.useGet(id: id),
      builder: (context, state) {
        final Post? post = state.data;
        final List<String> artists = filterArtists(
          post?.tags['artist'] ?? const [],
        );
        return InkWell(
          onTap: () => pushPostLoadingPage(context, id),
          child: Row(
            children: [
              PostRelationPreview(id: id),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('#$id', style: Theme.of(context).textTheme.titleSmall),
                    CrossFade(
                      showChild: post != null,
                      child: Text(
                        artists.isEmpty
                            ? 'no artist'
                            : artists.map(tagToName).join(', '),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: dimTextColor(context),
                          fontStyle: artists.isEmpty
                              ? FontStyle.italic
                              : FontStyle.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_right),
            ],
          ),
        );
      },
    );
  }
}

class RelationHeader extends StatelessWidget {
  const RelationHeader({super.key, required this.title, this.count});

  final String title;
  final int? count;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    child: Row(
      children: [
        Flexible(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        if (count != null) ...[
          const SizedBox(width: 8),
          Text(
            count.toString(),
            style: TextStyle(fontSize: 16, color: dimTextColor(context)),
          ),
        ],
      ],
    ),
  );
}

class PostRowSection extends StatelessWidget {
  const PostRowSection({
    super.key,
    required this.title,
    required this.onAll,
    required this.children,
    this.count,
  }) : loading = false;

  const PostRowSection.loading({
    super.key,
    required this.title,
    required this.onAll,
  }) : count = null,
       loading = true,
       children = const [];

  final String title;
  final int? count;
  final VoidCallback onAll;
  final List<Widget> children;
  final bool loading;

  static const double minTileSize = 100;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: RelationHeader(title: title, count: count),
          ),
          TextButton.icon(
            style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
            onPressed: onAll,
            iconAlignment: IconAlignment.end,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('See all'),
          ),
        ],
      ),
      LayoutBuilder(
        builder: (context, constraints) {
          final int slots = max(
            1,
            (constraints.maxWidth / minTileSize).floor(),
          );
          final List<Widget> fitting = loading
              ? [
                  for (int i = 0; i < min(slots, 6); i++)
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Bone(
                        width: double.infinity,
                        height: double.infinity,
                        borderRadius: BorderRadius.circular(
                          AppStyle.of(context).smallRadius,
                        ),
                      ),
                    ),
                ]
              : children.take(slots).toList();
          final Widget row = Row(
            children: [
              for (final Widget child in fitting)
                Expanded(child: AspectRatio(aspectRatio: 1, child: child)),
              for (int i = fitting.length; i < slots; i++) const Spacer(),
            ],
          );
          return Skeletonizer(enabled: loading, child: row);
        },
      ),
      const SizedBox(height: 8),
      const Divider(),
    ],
  );
}

class PostRowTile extends StatelessWidget {
  const PostRowTile({
    super.key,
    required this.post,
    required this.onTap,
    this.size = postRelationPreviewSize,
  });

  final PostSummary post;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) => RelationPreviewCard(
    size: size,
    onTap: onTap,
    child: PostTileOverlay(
      post: post,
      child: PostImageWidget(
        post: post,
        size: PostImageSize.preview,
        fit: BoxFit.cover,
        showProgress: false,
        withLowRes: false,
      ),
    ),
  );
}
