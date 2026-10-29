import 'package:e1547/client/client.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key, this.params});

  final PostParams? params;

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  int? tapped;

  void _open(String tags) => Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => PostsPage(params: PostParams(tags: tags)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final Client client = context.watch<Client>();
    return FilterControllerProvider(
      create: (_) =>
          isOwnFavorites(widget.params?.tags, client.identity.username)
          ? FavoritePostFilter(client)
          : PostFilter(client),
      keys: (_) => [client],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => PostParamsController(initial: widget.params),
          ),
          ChangeNotifierProvider(create: (_) => PostDisplayController()),
        ],
        child: Builder(
          builder: (context) {
            final List<String> terms = postSearchTerms(
              context.watch<PostParamsController>().value.tags,
            );
            final int? tapped =
                this.tapped != null && this.tapped! < terms.length
                ? this.tapped
                : null;
            void close() => setState(() => this.tapped = null);
            void change(List<String> next) {
              close();
              _open(next.join(' '));
            }

            return PopScope(
              canPop: tapped == null,
              onPopInvokedWithResult: (didPop, result) {
                if (!didPop) close();
              },
              child: Scaffold(
                body: GestureDetector(
                  onTap: tapped != null ? close : null,
                  child: PostResults(
                    dimmed: tapped != null,
                    top: (onRefresh) => [
                      SliverHexagonRefresh(
                        onRefresh: onRefresh ?? () async {},
                        headerExtent: null,
                        header: PostSearchHeader(
                          selected: tapped,
                          onChip: (index) => setState(
                            () => this.tapped = index == tapped ? null : index,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: AnimatedSize(
                          duration: defaultAnimationDuration,
                          curve: Curves.easeOutCubic,
                          alignment: Alignment.topCenter,
                          child: tapped != null
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: PostTagPanel(
                                    term: terms[tapped],
                                    onChange: (term) => change([
                                      ...terms.take(tapped),
                                      term,
                                      ...terms.skip(tapped + 1),
                                    ]),
                                    onRemove: () => change([
                                      ...terms.take(tapped),
                                      ...terms.skip(tapped + 1),
                                    ]),
                                  ),
                                )
                              : const SizedBox(width: double.infinity),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
