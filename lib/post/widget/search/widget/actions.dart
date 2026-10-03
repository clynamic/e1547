import 'package:collection/collection.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';

class TagListActions extends StatefulWidget {
  const TagListActions({super.key, required this.tag});

  final String tag;

  @override
  State<TagListActions> createState() => _TagListActionsState();
}

class _TagListActionsState extends State<TagListActions> {
  bool _busy = false;

  // Follow, notify, bookmark and block actions mutate the server; a second
  // tap while a request is in flight would repeat the mutation.
  Future<void> guard(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String tag = widget.tag;
    if (wikiMetaTags.any((prefix) => tag.startsWith(prefix))) {
      return const SizedBox.shrink();
    }
    return Consumer<Client>(
      builder: (context, client, child) {
        final query = client.follows.useAll(
          query: FollowsQuery(tags: tag).toQuery(),
        );
        return QueryBuilder(
          query: query,
          builder: (context, followState) => ValueListenableBuilder(
            valueListenable: client.traits,
            builder: (context, traits, child) {
              final Follow? follow = followState.data?.firstWhereOrNull(
                (f) => f.tags == tag,
              );
              final bool hasFollow = follow != null;

              final bool following =
                  hasFollow &&
                  const [
                    FollowType.update,
                    FollowType.notify,
                  ].contains(follow.type);

              final bool notifying =
                  hasFollow && follow.type == FollowType.notify;
              final bool bookmarked =
                  hasFollow && follow.type == FollowType.bookmark;
              final bool denied = traits.denylist.contains(tag);

              Future<void> applyFollowMutation(FollowType type) async {
                if (hasFollow) {
                  if (follow.type == type) {
                    await client.follows.delete(follow.id);
                  } else if (follow.type == FollowType.notify &&
                      type == FollowType.update) {
                    await client.follows.delete(follow.id);
                  } else {
                    await client.follows.update(id: follow.id, type: type);
                  }
                } else {
                  await client.follows.create(tags: tag, type: type);
                  if (denied) {
                    client.traits.value = traits.copyWith(
                      denylist: traits.denylist..remove(tag),
                    );
                  }
                }
                query.invalidate();
              }

              return AnimatedSwitcher(
                duration: defaultAnimationDuration,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CrossFade(
                      showChild: !denied,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ActionButton(
                            icon: following
                                ? const Icon(Icons.person_remove_alt_1)
                                : const Icon(Icons.person_add_alt_1),
                            label: following
                                ? Text(
                                    AppLocalizations.of(context).actionUnfollow,
                                  )
                                : Text(
                                    AppLocalizations.of(context).actionFollow,
                                  ),
                            onTap: () => guard(
                              () => applyFollowMutation(FollowType.update),
                            ),
                          ),
                          CrossFade(
                            showChild: following,
                            child: ActionButton(
                              icon: notifying
                                  ? const Icon(Icons.notifications_active)
                                  : const Icon(Icons.notifications_none),
                              label: notifying
                                  ? Text(
                                      AppLocalizations.of(context).actionMute,
                                    )
                                  : Text(
                                      AppLocalizations.of(context).actionNotify,
                                    ),
                              onTap: () => guard(() async {
                                if (!hasFollow) return;
                                await client.follows.update(
                                  id: follow.id,
                                  type: notifying
                                      ? FollowType.update
                                      : FollowType.notify,
                                );
                                query.invalidate();
                              }),
                            ),
                          ),
                          ActionButton(
                            icon: bookmarked
                                ? const Icon(Icons.turned_in)
                                : const Icon(Icons.turned_in_not),
                            label: bookmarked
                                ? Text(
                                    AppLocalizations.of(
                                      context,
                                    ).actionUnbookmark,
                                  )
                                : Text(
                                    AppLocalizations.of(context).actionBookmark,
                                  ),
                            onTap: () => guard(
                              () => applyFollowMutation(FollowType.bookmark),
                            ),
                          ),
                        ],
                      ),
                    ),
                    CrossFade(
                      showChild: !hasFollow,
                      child: ActionButton(
                        icon: CrossFade(
                          showChild: denied,
                          secondChild: const Icon(Icons.block),
                          child: const Icon(Icons.check),
                        ),
                        label: denied
                            ? Text(AppLocalizations.of(context).actionUnblock)
                            : Text(AppLocalizations.of(context).actionBlock),
                        onTap: () => guard(() async {
                          if (denied) {
                            await client.accounts.push(
                              traits: traits.copyWith(
                                denylist: traits.denylist
                                    .whereNot((element) => element == tag)
                                    .toList(),
                              ),
                            );
                          } else {
                            if (hasFollow) {
                              await client.follows.delete(follow.id);
                              query.invalidate();
                            }
                            await client.accounts.push(
                              traits: traits.copyWith(
                                denylist: [...traits.denylist, tag],
                              ),
                            );
                          }
                        }),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class RemoveTagAction extends StatelessWidget {
  const RemoveTagAction({super.key, required this.tag});

  final String tag;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PostParamsController>();

    return ActionButton(
      icon: const Icon(Icons.search_off),
      label: Text(AppLocalizations.of(context).actionRemove),
      onTap: () {
        if (popDialog(context)) {
          controller.removeTag(tag);
        }
      },
    );
  }
}

class AddTagAction extends StatelessWidget {
  const AddTagAction({super.key, required this.tag});

  final String tag;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PostParamsController>();

    return ActionButton(
      icon: const Icon(Icons.zoom_in),
      label: Text(AppLocalizations.of(context).actionAdd),
      onTap: () {
        if (popDialog(context)) {
          controller.addTag(tag);
        }
      },
    );
  }
}

class SubtractTagAction extends StatelessWidget {
  const SubtractTagAction({super.key, required this.tag});

  final String tag;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PostParamsController>();

    return ActionButton(
      icon: const Icon(Icons.zoom_out),
      label: Text(AppLocalizations.of(context).actionSubtract),
      onTap: () {
        if (popDialog(context)) {
          controller.subtractTag(tag);
        }
      },
    );
  }
}

class TagSearchActions extends StatelessWidget {
  const TagSearchActions({super.key, required this.tag});

  final String tag;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PostParamsController>();

    if (tag.contains(' ')) {
      return const SizedBox.shrink();
    }

    bool isSearched = controller.hasTag(tag);

    if (isSearched) {
      return RemoveTagAction(tag: tag);
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AddTagAction(tag: tag),
          SubtractTagAction(tag: tag),
        ],
      );
    }
  }
}
