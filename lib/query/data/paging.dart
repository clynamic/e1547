import 'package:e1547/query/query.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

extension QueryPagingState<T, Arg> on InfiniteQueryStatus<List<T>, Arg> {
  PagingState<Arg, T> get paging {
    return PagingState(
      pages: data?.pages,
      keys: data?.args,
      error: error,
      isLoading: isLoading,
      hasNextPage: switch (this) {
        InfiniteQuerySuccess e => e.hasNextPage,
        _ => true,
      },
    );
  }
}

extension QueryDataIntPagingState<T> on InfiniteQueryData<List<T>, int>? {
  int? get nextPage => (this?.lastPage?.isNotEmpty ?? true)
      ? (this?.args.lastOrNull ?? 0) + 1
      : null;
}

/// Paging helpers for queries whose page arguments are either a page number
/// (an int) or a server cursor (a String).
///
/// Cursor anchors come from comparing page items, so [T] must be comparable.
extension QueryDataObjectPagingState<T extends Comparable<Object>>
    on InfiniteQueryData<List<T>, Object>? {
  /// The next page argument for page-number pagination.
  ///
  /// Mirrors [QueryDataIntPagingState.nextPage]: an absent state starts at
  /// page 1, an empty last page means the end was reached, and anything else
  /// continues after the last requested page. [maxPage] caps the sequence,
  /// since e621 rejects page numbers past its limit.
  ///
  /// Page arguments are always ints; a non-int argument is a cursor, which
  /// cannot continue a page-number sequence, so it ends one instead.
  Object? nextPageArg({int? maxPage}) {
    final data = this;
    if (data == null) return 1;
    final lastPage = data.lastPage;
    if (lastPage != null && lastPage.isEmpty) return null;
    final lastArg = data.args.lastOrNull;
    if (lastArg is! int) return null;
    final next = lastArg + 1;
    if (maxPage != null && next > maxPage) return null;
    return next;
  }

  /// The next page argument for cursor pagination (`b<id>` on e621).
  ///
  /// The first page is a page number, so it always returns the newest posts.
  /// Later pages take the lowest id of the last page as their anchor, which
  /// the server resolves to the posts before it, making new posts unable to
  /// shift what a following page returns. An empty last page means the end
  /// was reached.
  Object? nextCursorPage() {
    final data = this;
    if (data == null) return 1;
    final lastPage = data.lastPage;
    if (lastPage == null) return 1;
    if (lastPage.isEmpty) return null;
    final minPageItem = lastPage.reduce((a, b) => a.compareTo(b) < 0 ? a : b);
    return 'b$minPageItem';
  }
}

extension QueryStatusErroring<T> on QueryStatus<T> {
  Object? get error {
    return switch (this) {
      QueryError e => e.error,
      _ => null,
    };
  }
}

extension InfiniteQueryStatusErroring<T, Arg>
    on InfiniteQueryStatus<List<T>, Arg> {
  Object? get error {
    return switch (this) {
      InfiniteQueryError e => e.error,
      _ => null,
    };
  }
}
