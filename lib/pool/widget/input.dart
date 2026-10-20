import 'package:cached_network_image/cached_network_image.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/history/history.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class PoolsPageFab extends StatelessWidget {
  const PoolsPageFab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PoolParamsController>();
    return SearchPromptFab(
      tags: controller.value.toQuery(),
      onSubmit: (value) => controller.value = PoolParams.fromQuery(value),
      filters: [
        WrapperFilterConfig(
          wrapper: (value) => 'search[$value]',
          unwrapper: (value) => value.substring(7, value.length - 1),
          filters: [
            PrimaryFilterConfig(
              filter: PoolNameFilterTag(tag: 'name_matches'),
              filters: [
                TextFilterTag(
                  tag: 'description_matches',
                  name: t('Description'),
                  icon: const Icon(Icons.description),
                ),
                TextFilterTag(
                  tag: 'creator_name',
                  name: t('Creator'),
                  icon: const Icon(Icons.person),
                ),
                ToggleFilterTag(
                  tag: 'is_active',
                  name: t('Active'),
                  enabled: 'true',
                  disabled: 'false',
                  description: t('Is active'),
                ),
                ChoiceFilterTag(
                  tag: 'category',
                  name: t('Category'),
                  icon: const Icon(Icons.category),
                  options: [
                    ChoiceFilterTagValue(value: null, name: t('Default')),
                    ChoiceFilterTagValue(value: 'series', name: t('Series')),
                    ChoiceFilterTagValue(
                      value: 'collection',
                      name: t('Collection'),
                    ),
                  ],
                ),
                ChoiceFilterTag(
                  tag: 'order',
                  name: t('Sort by'),
                  icon: const Icon(Icons.sort),
                  options: [
                    ChoiceFilterTagValue(value: null, name: t('Default')),
                    ChoiceFilterTagValue(value: 'name', name: t('Name')),
                    ChoiceFilterTagValue(
                      value: 'created_at',
                      name: t('Created'),
                    ),
                    ChoiceFilterTagValue(
                      value: 'updated_at',
                      name: t('Updated'),
                    ),
                    ChoiceFilterTagValue(
                      value: 'post_count',
                      name: t('Post count'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _PoolSearchResult {
  const _PoolSearchResult({
    required this.time,
    required this.name,
    this.thumbnail,
    this.link,
  });

  final DateTime time;
  final String name;
  final String? thumbnail;
  final String? link;
}

class PoolNameFilterTag extends BuilderFilterTag {
  PoolNameFilterTag({required super.tag, super.name})
    : super(builder: (context, state) => PoolNameFilter(state: state));
}

class PoolNameFilter extends StatelessWidget {
  const PoolNameFilter({super.key, required this.state});

  final FilterTagState state;

  @override
  Widget build(BuildContext context) {
    FilterTagThemeData theme = FilterTagTheme.of(context);
    return SubTextValue(
      value: state.value,
      onChanged: state.onChanged,
      builder: (context, controller) =>
          AutocompleteTextField<_PoolSearchResult>(
            direction: VerticalDirection.up,
            submit: (value) => state.onSubmit?.call(value),
            controller: controller,
            labelText: t('Pool title'),
            decoration: theme.decoration,
            focusNode: theme.focusNode,
            onSelected: (value) {
              if (value.link != null) {
                Navigator.of(context).pop();
                const E621LinkParser().open(context, value.link!);
              } else {
                controller.text = '${value.name} ';
                controller.setFocusToEnd();
              }
            },
            suggestionsCallback: (value) async {
              value = value.trim();
              final client = context.read<Client>();
              return (await client.histories.page(
                    page: 1,
                    query: HistoryParams(
                      date: DateTime.now(),
                      link: r'/pools/.*',
                      title: RegExp.escape(value.replaceAll(' ', '_')),
                    ).toQuery(),
                    limit: 4,
                  ))
                  .where((e) => e.title != null)
                  .map(
                    (e) => _PoolSearchResult(
                      time: e.visitedAt,
                      name: e.title!.replaceAll('_', ' '),
                      thumbnail: e.thumbnails.isNotEmpty
                          ? e.thumbnails.first
                          : null,
                      link: e.link,
                    ),
                  )
                  .toList();
            },
            itemBuilder: (context, value) => ListTile(
              title: Text(value.name),
              leading: value.thumbnail != null
                  ? Padding(
                      padding: const EdgeInsets.all(4),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4),
                        ),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: CachedNetworkImage(
                            imageUrl: value.thumbnail!,
                            errorWidget: defaultErrorBuilder,
                            fit: BoxFit.cover,
                            cacheManager: context.read<BaseCacheManager>(),
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Icon(
                        value.link != null
                            ? Icons.open_in_new
                            : Icons.lightbulb_outline,
                      ),
                    ),
            ),
          ),
    );
  }
}
