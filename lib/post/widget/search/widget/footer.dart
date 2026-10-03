import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Paging readouts for the footer of a posts list.
extension PostListPaging on InfiniteQueryStatus<List<Post>, Object> {
  /// The page the search is currently on.
  ///
  /// Page number searches carry their page in their arguments. Cursor
  /// searches drift through new posts, so their cursor pages are counted
  /// after the last page number they fetched, which is the page they started
  /// at or jumped to.
  int get currentPage {
    final data = this.data;
    if (data == null) return 0;
    // The search ends with an empty page, which is no page to be on.
    var end = data.pages.length;
    while (end > 0 && data.pages[end - 1].isEmpty) {
      end--;
    }
    // A search whose pages have not landed yet still reports the page its
    // arguments fetch, which is the page a jump went to.
    final args = data.args.take(end).toList();
    final pageArgs = args.isEmpty ? data.args : args;
    final pageNumber = pageArgs.whereType<int>().lastOrNull ?? 0;
    final cursorPages = pageArgs.whereType<String>().length;
    return pageNumber + cursorPages;
  }

  /// Whether the search ended because e621 serves no page past its cap.
  ///
  /// Cursor searches end by running out of posts instead, which needs no
  /// special hint.
  bool get atSitePageLimit => switch (this) {
    InfiniteQuerySuccess e =>
      !e.hasNextPage && e.data.args.lastOrNull == maxSitePage,
    _ => false,
  };
}

/// The footer of a posts list.
///
/// Reports the page and posts a search has loaded, and offers jumping to one
/// of its pages. Nothing is shown while the search has loaded nothing yet, or
/// when it ended without any posts.
class PostListFooter extends StatelessWidget {
  const PostListFooter({
    super.key,
    required this.state,
    required this.query,
    required this.scrollController,
  });

  final InfiniteQueryStatus<List<Post>, Object> state;

  /// The id query backing [state].
  ///
  /// Its pages are id lists, and a jump only replaces its page arguments.
  final InfiniteQuery<List<Object>, Object> query;

  /// The controller of the scroll view the footer ends.
  ///
  /// The scroll view shadows the primary scroll controller from the slivers
  /// below it, so it has to be handed in from outside.
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final data = state.data;
    if (data == null) return const SizedBox.shrink();
    // An ended search without posts has nothing to report or page through.
    // An empty last page counts as ended too: the query's has-next-page
    // flag lags an empty page by a fetch, and an empty search never
    // fetches again to correct it.
    final bool ended = switch (state) {
      InfiniteQuerySuccess success =>
        !success.hasNextPage || success.data.pages.lastOrNull?.isEmpty == true,
      _ => false,
    };
    if (ended && data.pages.expand((page) => page).isEmpty) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Dimmed(
                child: Text(
                  l10n.postListPageSummary(
                    data.pages.expand((page) => page).length,
                    state.currentPage,
                  ),
                ),
              ),
            ),
            IconButton(
              tooltip: l10n.postListJumpToPage,
              onPressed: () => jumpToPage(context),
              icon: const Icon(Icons.onetwothree),
            ),
          ],
        ),
        if (state.atSitePageLimit)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Dimmed(child: Text(l10n.postListPageLimit)),
          ),
      ],
    );
  }

  /// Opens the page jump prompt and applies the page it returns.
  Future<void> jumpToPage(BuildContext context) async {
    final page = await showPageJumpPrompt(
      context: context,
      currentPage: state.currentPage,
    );
    if (page == null) return;
    // The list is returned to the top of the page it is about to jump to.
    // Leaving the bottom of the list behind also stops its auto-loading.
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0,
        duration: defaultAnimationDuration,
        curve: Curves.easeInOut,
      );
    }
    // A fetch that is still in flight would swallow the jump's refetch, and
    // would then overwrite the jump with a page of the search it jumped
    // away from, so it is waited out first.
    while (true) {
      while (query.state is InfiniteQueryLoading) {
        await query.stream.firstWhere(
          (state) => state is! InfiniteQueryLoading,
        );
      }
      // The query clears its in-flight fetch a turn of the event loop after
      // its last state lands. Waiting out that turn lets the jump's refetch
      // take the settled fetch's place instead of being swallowed by it.
      await null;
      if (query.state is! InfiniteQueryLoading) break;
    }
    // The posts query pages over id lists, so the jump hands it the one page
    // argument its refetch restarts from.
    query.setData(
      InfiniteQueryData<List<int>, Object>(pages: const [], args: [page]),
    );
    query.invalidate();
  }
}

/// Shows a dialog that returns the page to jump a posts search to.
Future<int?> showPageJumpPrompt({
  required BuildContext context,
  required int currentPage,
}) => showDialog<int>(
  context: context,
  builder: (context) => _PageJumpDialog(currentPage: currentPage),
);

class _PageJumpDialog extends StatefulWidget {
  const _PageJumpDialog({required this.currentPage});

  /// The page the search is currently on, prefilled into the field.
  final int currentPage;

  @override
  State<_PageJumpDialog> createState() => _PageJumpDialogState();
}

class _PageJumpDialogState extends State<_PageJumpDialog> {
  late final TextEditingController controller = TextEditingController(
    text: widget.currentPage.toString(),
  );
  bool hasError = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void submit() {
    final page = int.tryParse(controller.text);
    if (page == null || page < 1 || page > maxSitePage) {
      setState(() => hasError = true);
      return;
    }
    popDialog(context, page);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.postListJumpToPage),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          labelText: l10n.postListJumpPageLabel,
          errorText: hasError ? l10n.postListJumpPageRange(maxSitePage) : null,
        ),
        onChanged: (value) => setState(() => hasError = false),
        onSubmitted: (_) => submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => popDialog(context),
          child: Text(l10n.actionCancel),
        ),
        TextButton(onPressed: submit, child: Text(l10n.actionOk)),
      ],
    );
  }
}
