import 'package:e1547/client/client.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';

class ArtistRecommendations extends StatelessWidget {
  const ArtistRecommendations({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final List<String> artists = filterArtists(post.tags['artist'] ?? const []);
    if (artists.isEmpty) return const SizedBox.shrink();
    if (isSkeleton(context)) {
      return ArtistRecommendationsRow(artists: artists, loading: true);
    }
    final Client client = context.watch<Client>();
    final PostFilter? filter = context.watch<PostFilter?>();
    return QueryBuilder(
      query: client.posts.useArtistRecommendations(id: post.id),
      builder: (context, state) {
        final List<PartialPost>? found = state.data;
        if (found == null) {
          if (state.isError) return const SizedBox.shrink();
          return ArtistRecommendationsRow(artists: artists, loading: true);
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
              PostRowTile(
                post: post,
                onTap: () => pushPostGallery(
                  context,
                  params: PostParams(tags: 'id:$ids'),
                  initialPostId: post.id,
                ),
              ),
          ],
        );
      },
    );
  }
}

class ArtistRecommendationsRow extends StatelessWidget {
  const ArtistRecommendationsRow({
    super.key,
    required this.artists,
    this.children = const [],
    this.loading = false,
  });

  final List<String> artists;
  final List<Widget> children;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    void all() => Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PostsPage(
          params: PostParams(
            tags: artists.length == 1
                ? artists.single
                : artists.map((e) => '~$e').join(' '),
          ),
        ),
      ),
    );
    const String title = 'From the artist';
    if (loading) return PostRowSection.loading(title: title, onAll: all);
    return PostRowSection(title: title, onAll: all, children: children);
  }
}
