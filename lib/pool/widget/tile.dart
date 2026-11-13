import 'package:e1547/client/client.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';

class PoolTile extends StatelessWidget {
  const PoolTile({super.key, required this.pool, this.onPressed});

  final Pool pool;
  final VoidCallback? onPressed;

  static const double titleLineHeight = 20;

  @override
  Widget build(BuildContext context) {
    final TileLayoutData layout = TileLayout.of(context);
    final bool staggered = layout.stagger == GridQuilt.vertical;
    final Widget title = Text(
      tagToName(pool.name),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: 14, height: titleLineHeight / 14),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 6,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  AppStyle.of(context).smallRadius,
                ),
                child: staggered
                    ? PoolCover(
                        id: pool.postIds.firstOrNull,
                        adaptive: true,
                        emptyRatio: PostGhost
                            .ratios[pool.id.abs() % PostGhost.ratios.length],
                      )
                    : AspectRatio(
                        aspectRatio: 1 / layout.tileHeightFactor,
                        child: PoolCover(id: pool.postIds.firstOrNull),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (staggered)
                      title
                    else
                      SizedBox(
                        height: titleLineHeight * 2,
                        child: Align(
                          alignment: AlignmentDirectional.topStart,
                          child: title,
                        ),
                      ),
                    Text(
                      '${pool.postCount} posts',
                      style: TextStyle(
                        fontSize: 12,
                        color: dimTextColor(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned.fill(
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: onPressed,
                onLongPress: () => showPoolPrompt(context: context, pool: pool),
                onSecondaryTap: () =>
                    showPoolPrompt(context: context, pool: pool),
                borderRadius: BorderRadius.circular(
                  AppStyle.of(context).smallRadius,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PoolCover extends StatelessWidget {
  const PoolCover({
    super.key,
    required this.id,
    this.adaptive = false,
    this.emptyRatio = 0.8,
  });

  final int? id;
  final bool adaptive;
  final double emptyRatio;

  @override
  Widget build(BuildContext context) {
    final Widget empty = ColoredBox(color: AppStyle.of(context).skeleton);
    Widget shape(Widget child, [double? ratio]) => adaptive
        ? AspectRatio(aspectRatio: ratio ?? emptyRatio, child: child)
        : SizedBox.expand(child: child);
    if (isSkeleton(context)) {
      return shape(const Bone(width: double.infinity, height: double.infinity));
    }
    final int? id = this.id;
    if (id == null) return shape(empty);
    final Client client = context.watch<Client>();
    return QueryBuilder(
      query: client.posts.useGet(id: id, vendored: true),
      builder: (context, state) {
        final Post? post = state.data;
        if (post == null) return shape(empty);
        final FilterController<Post>? filter = context
            .watch<FilterController<Post>?>();
        if (filter != null && !filter.filter(post)) {
          return shape(
            Stack(
              fit: StackFit.expand,
              children: [
                empty,
                Center(child: Icon(Icons.block, color: dimTextColor(context))),
              ],
            ),
          );
        }
        return shape(
          Stack(
            fit: StackFit.expand,
            children: [
              empty,
              PostTileOverlay(
                post: post,
                child: PostImageWidget(
                  post: post,
                  size: PostImageSize.sample,
                  fit: BoxFit.cover,
                  showProgress: false,
                  withLowRes: false,
                ),
              ),
            ],
          ),
          post.file == null
              ? emptyRatio
              : (post.width / post.height).clamp(0.6, 1.4),
        );
      },
    );
  }
}
