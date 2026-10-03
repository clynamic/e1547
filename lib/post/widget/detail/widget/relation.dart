import 'package:e1547/client/client.dart';
import 'package:e1547/l10n/app_localizations.dart';
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
        return RelationPreviewCard(
          size: size,
          onTap:
              onTap ??
              () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => PostLoadingPage(id)),
              ),
          child: post != null && !denied
              ? PostTileOverlay(
                  post: post,
                  child: PostImageWidget(
                    post: post,
                    size: PostImageSize.preview,
                    fit: BoxFit.cover,
                    showProgress: false,
                    withLowRes: false,
                  ),
                )
              : RelationPreviewIcon(
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
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => PostLoadingPage(id))),
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
                            ? AppLocalizations.of(context).detailNoArtist
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
        Text(title, style: const TextStyle(fontSize: 16)),
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
