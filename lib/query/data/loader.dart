class QueryMissingException implements Exception {
  const QueryMissingException(this.key);

  final Object? key;

  @override
  String toString() => 'QueryMissingException($key)';
}

class QueryLoader<K, V> {
  QueryLoader(this.load, {this.limit});

  final Future<Map<K, V>> Function(List<K> keys) load;
  final int? limit;

  final Set<K> _missing = {};
  List<K>? _queued;
  Future<Map<K, V>>? _next;

  Future<V?> fetch(K key) {
    if (_missing.contains(key)) return Future.value();
    return _queue(key);
  }

  Future<V> require(K key) async =>
      await fetch(key) ?? (throw QueryMissingException(key));

  Future<V?> _queue(K key) async {
    final List<K> keys = _queued ??= [];
    keys.add(key);
    final Future<Map<K, V>> batch = _next ??= Future(() async {
      _close(keys);
      final Map<K, V> loaded = await load(keys);
      _missing.addAll(keys.where((key) => !loaded.containsKey(key)));
      return loaded;
    });
    if (limit case final int limit when keys.length >= limit) _close(keys);
    return (await batch)[key];
  }

  void _close(List<K> keys) {
    if (!identical(_queued, keys)) return;
    _queued = null;
    _next = null;
  }
}
