import 'package:e1547/client/client.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';

class ArtistRecommendations extends StatelessWidget {
  const ArtistRecommendations({super.key, required this.post});

  final Post post;

  static const int placeholders = 6;

  @override
  Widget build(BuildContext context) {
    final List<String> artists = filterArtists(post.tags['artist'] ?? const []);
    if (artists.isEmpty) return const SizedBox.shrink();
    if (isSkeleton(context)) {
      return ArtistRecommendationsRow(
        artists: artists,
        children: placeholderTiles,
      );
    }
    final Client client = context.watch<Client>();
    final PostFilter? filter = context.watch<PostFilter?>();
    return QueryBuilder(
      query: client.posts.useArtistRecommendations(id: post.id),
      builder: (context, state) {
        final List<PartialPost>? found = state.data;
        if (found == null) {
          if (state.isError) return const SizedBox.shrink();
          return Skeletonizer(
            child: ArtistRecommendationsRow(
              artists: artists,
              children: placeholderTiles,
            ),
          );
        }
        final List<PartialPost> shown = [
          for (final PartialPost post in found)
            if (filter?.allows(post) ?? true) post,
        ];
        if (shown.isEmpty) return const SizedBox.shrink();
        final String ids = shown.map((e) => e.id).join(',');
        return ArtistRecommendationsRow(
          artists: artists,
          children: [
            for (final PartialPost post in shown)
              RelationPreviewCard(
                onTap: () => pushPostGallery(
                  context,
                  params: PostParams(tags: 'id:$ids'),
                  initialPostId: post.id,
                ),
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
              ),
          ],
        );
      },
    );
  }

  static List<Widget> get placeholderTiles => [
    for (int i = 0; i < placeholders; i++)
      const RelationPreviewCard(
        child: Bone(width: double.infinity, height: double.infinity),
      ),
  ];
}

class ArtistRecommendationsRow extends StatelessWidget {
  const ArtistRecommendationsRow({
    super.key,
    required this.artists,
    required this.children,
  });

  final List<String> artists;
  final List<Widget> children;

  static const double minTileSize = 100;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          const Expanded(child: RelationHeader(title: 'From the artist')),
          TextButton.icon(
            style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PostsPage(
                  params: PostParams(
                    tags: artists.length == 1
                        ? artists.single
                        : artists.map((e) => '~$e').join(' '),
                  ),
                ),
              ),
            ),
            iconAlignment: IconAlignment.end,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('See all'),
          ),
        ],
      ),
      LayoutBuilder(
        builder: (context, constraints) {
          final int slots = (constraints.maxWidth / minTileSize).floor().clamp(
            1,
            double.maxFinite.toInt(),
          );
          final List<Widget> fitting = children.take(slots).toList();
          return Row(
            children: [
              for (final Widget child in fitting)
                Expanded(child: AspectRatio(aspectRatio: 1, child: child)),
              for (int i = fitting.length; i < slots; i++) const Spacer(),
            ],
          );
        },
      ),
      const SizedBox(height: 8),
      const Divider(),
    ],
  );
}
