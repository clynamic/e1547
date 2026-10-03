import 'package:e1547/client/client.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'filter.freezed.dart';

class PostFilter extends FilterController<Post>
    implements ValueNotifier<PostFilterValue> {
  PostFilter(this.client, [PostFilterValue? value])
    : _value = value ?? const PostFilterValue() {
    client.traits.addListener(_updateDenyList);
  }

  final Client client;

  PostFilterValue _value;

  final Map<int, _PostFilterCache> _filterCache = {};

  void _updateDenyList() {
    _filterCache.clear();
    notifyListeners();
  }

  @override
  Object idOf(Post post) => post.id;

  @override
  bool filter(Post post) => !denies(post);

  @override
  PostFilterValue get value => _value;

  @override
  set value(PostFilterValue value) {
    if (_value == value) return;
    _value = value;
    notifyListeners();
  }

  bool get denying => value.denying;
  set denying(bool enabled) => value = value.copyWith(denying: enabled);

  List<String> get allowedEntries => value.allowedEntries;
  set allowedEntries(List<String> entries) {
    final newValue = value.copyWith(allowedEntries: entries);
    if (value == newValue) return;
    _filterCache.clear();
    value = newValue;
  }

  List<int> get allowedPosts => value.allowedPosts;
  set allowedPosts(List<int> posts) =>
      value = value.copyWith(allowedPosts: posts);

  void allow(int postId) {
    if (!allowedPosts.contains(postId)) {
      allowedPosts = [...allowedPosts, postId];
    }
  }

  void disallow(int postId) {
    allowedPosts = allowedPosts.where((id) => id != postId).toList();
  }

  void enable(String entry) {
    if (!allowedEntries.contains(entry)) {
      allowedEntries = [...allowedEntries, entry];
    }
  }

  void disable(String entry) {
    if (allowedEntries.contains(entry)) {
      allowedEntries = allowedEntries.where((e) => e != entry).toList();
    }
  }

  void toggle(String entry) {
    if (allowedEntries.contains(entry)) {
      disable(entry);
    } else {
      enable(entry);
    }
  }

  Map<String, int> get blockedCountsByEntry {
    if (!denying) return const {};
    final counts = <String, int>{};
    for (final post in tracked) {
      if (allowedPosts.contains(post.id)) continue;
      for (final entry in entriesFor(post)) {
        if (allowedEntries.contains(entry)) continue;
        counts[entry] = (counts[entry] ?? 0) + 1;
      }
    }
    return counts;
  }

  List<String> entriesFor(Post post) {
    final now = DateTime.now();
    _evictStaleEntries(now);

    final cached = _filterCache[post.id];

    if (cached == null || cached.hash != post.hashCode) {
      final deniers = post.getDeniers(client.traits.value.denylist).toList();
      _filterCache[post.id] = (
        hash: post.hashCode,
        entries: deniers,
        lastAccessed: now,
      );
      return deniers;
    }

    _filterCache[post.id] = (
      hash: cached.hash,
      entries: cached.entries,
      lastAccessed: now,
    );
    return cached.entries;
  }

  // Sweeping the whole cache on every lookup made every refresh O(N²) over
  // the loaded posts; a throttled sweep keeps the same 60s entry lifetime.
  static const Duration _sweepInterval = Duration(seconds: 15);
  DateTime _lastSweep = DateTime.fromMillisecondsSinceEpoch(0);

  void _evictStaleEntries(DateTime now) {
    // A backwards clock only delays the next sweep; eviction never changes
    // results, it only costs a recomputation.
    if (now.difference(_lastSweep) < _sweepInterval) return;
    _lastSweep = now;
    final cutoff = now.subtract(const Duration(minutes: 1));
    _filterCache.removeWhere((_, entry) => entry.lastAccessed.isBefore(cutoff));
  }

  bool denies(Post post) {
    if (!denying) return false;
    if (allowedPosts.contains(post.id)) return false;
    final activeEntries = entriesFor(
      post,
    ).where((entry) => !allowedEntries.contains(entry));
    return activeEntries.isNotEmpty;
  }

  @override
  void dispose() {
    client.traits.removeListener(_updateDenyList);
    super.dispose();
  }
}

class FavoritePostFilter extends PostFilter {
  FavoritePostFilter(super.client, [super.value]);

  @override
  bool filter(Post post) {
    if (post.isFavorited) return true;
    return super.filter(post);
  }
}

typedef _PostFilterCache = ({
  int hash,
  List<String> entries,
  DateTime lastAccessed,
});

@freezed
abstract class PostFilterValue with _$PostFilterValue {
  const factory PostFilterValue({
    @Default(true) bool denying,
    @Default([]) List<String> allowedEntries,
    @Default([]) List<int> allowedPosts,
  }) = _PostFilterValue;
}
