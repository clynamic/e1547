import 'package:collection/collection.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/history/history.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/l10n/tag_descriptions_zh.dart';
import 'package:e1547/markup/markup.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:e1547/wiki/wiki.dart';
import 'package:flutter/material.dart';

Future<void> showTagSearchPrompt({
  required BuildContext context,
  required String tag,
}) {
  final controller = context.read<PostParamsController?>();
  return showPrompt<void>(
    context,
    pinnedHeader: true,
    dialogWidth: 800,
    // A prompt opens in its own route, so the page's controller is out of
    // scope.
    parentBuilder: (context, child) => controller == null
        ? child
        : ChangeNotifierProvider<PostParamsController>.value(
            value: controller,
            child: child,
          ),
    header: (context) {
      final canSearch =
          context.read<PostParamsController?>()?.canSearch ?? false;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: OverflowBar(
          alignment: MainAxisAlignment.spaceBetween,
          overflowSpacing: 8,
          children: [
            InkWell(
              onTap: () {
                if (popDialog(context)) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          PostsPage(params: PostParams(tags: tag)),
                    ),
                  );
                }
              },
              child: Text(
                tagToName(tag),
                style: Theme.of(context).textTheme.titleLarge,
                softWrap: true,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (canSearch) TagSearchActions(tag: tag),
                  TagListActions(tag: tag),
                ],
              ),
            ),
          ],
        ),
      );
    },
    body: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(indent: 4, endIndent: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          // Keeps the dialog from jumping as each tag resolves.
          child: AnimatedSize(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.topCenter,
            child: TagSearchInfo(tag: tag),
          ),
        ),
      ],
    ),
  );
}

class TagSearchInfo extends StatelessWidget {
  const TagSearchInfo({super.key, required this.tag});

  final String tag;

  @override
  Widget build(BuildContext context) {
    List<String> tags = TagMap(tag).toString().split(' ');

    if (tags.length > 1) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: tags.map((e) => TagSearchInfoChild(tag: e)).toList(),
      );
    }
    return SearchTagDisplay(tag: tag);
  }
}

class TagSearchInfoChild extends StatelessWidget {
  const TagSearchInfoChild({super.key, required this.tag});

  final String tag;

  @override
  Widget build(BuildContext context) {
    final canSearch = context.read<PostParamsController?>()?.canSearch ?? false;
    Widget actions(String tag, bool alignRight) {
      return SingleChildScrollView(
        reverse: alignRight,
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: alignRight
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (canSearch) TagSearchActions(tag: tag),
            TagListActions(tag: tag),
          ],
        ),
      );
    }

    final bool onDesktop = Theme.of(context).isDesktop;
    return ExpandableNotifier(
      child: ExpandableTheme(
        data: ExpandableThemeData(
          headerAlignment: ExpandablePanelHeaderAlignment.center,
          iconColor: Theme.of(context).iconTheme.color,
          iconPlacement: onDesktop ? ExpandablePanelIconPlacement.left : null,
        ),
        child: ExpandablePanel(
          header: Builder(
            builder: (context) {
              bool expanded = ExpandableController.of(context)!.expanded;
              return Row(
                children: [
                  Expanded(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: expanded
                          ? Theme.of(context).textTheme.titleLarge!
                          : Theme.of(context).textTheme.titleMedium!,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(tagToName(tag)),
                      ),
                    ),
                  ),
                  if (expanded && onDesktop) actions(tag, onDesktop),
                ],
              );
            },
          ),
          collapsed: const SizedBox.shrink(),
          expanded: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!onDesktop) actions(tag, onDesktop),
              const SizedBox(height: 8),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SearchTagDisplay(tag: tag),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchTagDisplay extends StatefulWidget {
  const SearchTagDisplay({super.key, required this.tag});

  final String tag;

  @override
  State<SearchTagDisplay> createState() => _SearchTagDisplayState();
}

class _SearchTagDisplayState extends State<SearchTagDisplay> {
  late Future<Wiki?> wiki = retrieveWiki();

  Future<Wiki?> retrieveWiki() async {
    final client = context.read<Client>();
    List<Wiki> results = await client.wikis.page(
      query: {'search[title]': tagToRaw(widget.tag)},
    );
    return results.firstWhereOrNull((e) => e.title == tagToRaw(widget.tag));
  }

  @override
  void initState() {
    super.initState();
    // TODO: history connector?
    final client = context.read<Client>();
    wiki.then((value) {
      if (value != null) {
        client.histories.add(WikiHistoryRequest.item(wiki: value));
      } else {
        client.histories.add(
          WikiHistoryRequest.search(
            query: {'search[title]': tagToRaw(widget.tag)},
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // chinese users get a curated offline description for common tags,
    // both when a wiki exists and when it does not
    final String? localized = localizedTagDescription(
      tagToRaw(widget.tag),
      Localizations.maybeLocaleOf(context) ?? const Locale('en'),
    );
    return FutureBuilder<Wiki?>(
      future: wiki,
      builder: (context, snapshot) => CrossFade.builder(
        style: FadeAnimationStyle.stacked,
        showChild: snapshot.connectionState == ConnectionState.done,
        builder: (context) {
          if (snapshot.hasData) {
            return DText(localized ?? snapshot.data!.body);
          } else if (snapshot.hasError) {
            return IconMessage(
              title: Text(AppLocalizations.of(context).tagUnableToRetrieveWiki),
              icon: const Icon(Icons.warning_amber_outlined),
              direction: Axis.horizontal,
            );
          } else {
            if (localized != null) {
              return DText(localized);
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    AppLocalizations.of(context).tagNoWikiEntry,
                    style: TextStyle(
                      color: dimTextColor(context, 0.5),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            );
          }
        },
        secondChild: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
