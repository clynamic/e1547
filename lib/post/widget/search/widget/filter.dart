import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';

/// Opens the filter prompt of a posts page.
///
/// A prompt opens in its own route, so the page's controller is out of
/// scope, and is handed over again.
Future<void> showPostsFilterPrompt({required BuildContext context}) {
  final controller = context.read<PostParamsController>();
  return showPrompt<void>(
    context,
    pinnedHeader: true,
    parentBuilder: (context, child) =>
        ChangeNotifierProvider<PostParamsController>.value(
          value: controller,
          child: child,
        ),
    header: (context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Text(
        AppLocalizations.of(context).searchFilterTitle,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    ),
    body: const PostsFilterPanel(),
  );
}

/// A button that edits the filter tags of the current posts search.
///
/// Highlights itself while any filter tag is in use.
class PostsPageFilterButton extends StatelessWidget {
  const PostsPageFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PostParamsController>();
    final map = TagMap(controller.value.tags);
    final active =
        PostParams.tagsFilter.filters.whereType<FilterTag>().any(
          (filter) => map.containsKey(filter.tag),
        ) ||
        // The file type filter writes its family of tags as one group
        // token, which no plain filter tag carries.
        hasFileTypeTokens(map);

    return IconButton(
      tooltip: AppLocalizations.of(context).searchFilterTitle,
      icon: Icon(
        Icons.filter_list,
        color: active ? Theme.of(context).colorScheme.primary : null,
      ),
      onPressed: () => showPostsFilterPrompt(context: context),
    );
  }
}

/// The filter prompt body of a posts page.
///
/// Edits the filter tags of the search the prompt was opened from, and
/// previews the query syntax they produce.
///
/// Changes are debounced: every filter control feeds FilterList.onChanged
/// on each interaction, and some controls, like the uploader filter, edit
/// free text. Feeding that straight into the controller refetches the
/// search on every keystroke.
class PostsFilterPanel extends StatefulWidget {
  const PostsFilterPanel({super.key});

  @override
  State<PostsFilterPanel> createState() => _PostsFilterPanelState();
}

class _PostsFilterPanelState extends State<PostsFilterPanel> {
  final Debouncer _apply = Debouncer();

  @override
  void dispose() {
    // Closing the prompt applies whatever the user just entered,
    // keeping the panel's live apply semantics intact.
    _apply.flush();
    _apply.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = context.watch<PostParamsController>();
    final map = TagMap(controller.value.tags);
    final query = map.toString();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FilterList(
            tags: map,
            onChanged: (value) {
              final tags = TagMap.from(value).toString();
              // Debounced: each keystroke no longer refetches the search.
              _apply(
                () => controller.update(
                  (params) => params.copyWith(tags: tags.isEmpty ? null : tags),
                ),
              );
            },
            filters: PostParams.tagsFilter.filters,
          ),
        ),
        const Divider(indent: 4, endIndent: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  l10n.searchFilterQueryLabel,
                  style: TextStyle(color: dimTextColor(context)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  key: const Key('PostsFilterPanel/Query'),
                  query.isEmpty ? '—' : query,
                  style: const TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
