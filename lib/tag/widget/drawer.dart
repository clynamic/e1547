import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';

class DrawerTagCounter extends StatelessWidget {
  const DrawerTagCounter({super.key, required this.posts, this.error});

  final List<Post>? posts;
  final Object? error;

  @override
  Widget build(BuildContext context) {
    return DrawerTagCounterBody(posts: posts, error: error);
  }
}

class DrawerMultiTagCounter extends StatelessWidget {
  const DrawerMultiTagCounter({super.key, this.filter});

  final PostFilter? filter;

  @override
  Widget build(BuildContext context) {
    final resolved = filter ?? context.watch<PostFilter>();
    return AnimatedBuilder(
      animation: resolved,
      builder: (context, child) => DrawerTagCounterBody(
        posts: resolved.tracked.where(resolved.filter).toList(),
      ),
    );
  }
}

class DrawerTagCounterBody extends StatelessWidget {
  const DrawerTagCounterBody({
    super.key,
    required this.posts,
    this.limit = 15,
    this.error,
  });

  final int limit;
  final List<Post>? posts;
  final Object? error;

  @override
  Widget build(BuildContext context) {
    List<Widget>? children;

    if (posts != null) {
      List<CountedTag> tags = countTagsByPosts(posts!);
      tags.sort((a, b) => b.count.compareTo(a.count));
      children = [];
      for (CountedTag tag in tags.take(limit)) {
        children.add(
          TagCounterCard(
            tag: tag.tag,
            count: tag.count,
            category: tag.category,
          ),
        );
      }
    }

    return Column(
      children: [
        ExpandableNotifier(
          initialExpanded: true,
          child: ExpandableTheme(
            data: ExpandableThemeData(
              headerAlignment: ExpandablePanelHeaderAlignment.center,
              iconColor: Theme.of(context).iconTheme.color,
            ),
            child: ExpandablePanel(
              header: ListTile(
                title: Text(AppLocalizations.of(context).filterTags),
                leading: const Icon(Icons.tag),
              ),
              collapsed: const SizedBox.shrink(),
              expanded: Column(
                children: [
                  const Divider(),
                  CrossFade.builder(
                    showChild: children != null,
                    builder: (context) => CrossFade(
                      showChild: children!.isNotEmpty,
                      secondChild: Text(
                        AppLocalizations.of(context).tagNoTags,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: dimTextColor(context),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [Expanded(child: Wrap(children: children))],
                        ),
                      ),
                    ),
                    secondChild: CrossFade(
                      showChild: error != null,
                      secondChild: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: SizedCircularProgressIndicator(size: 24),
                          ),
                        ],
                      ),
                      child: Dimmed(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.warning_amber, size: 12),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                AppLocalizations.of(
                                  context,
                                ).tagFailedToLoadTags,
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
