import 'dart:async';

class QueryBatch<K> {
  QueryBatch(this.load, {required this.cached});

  final Future<Iterable<K>> Function(List<K> keys) load;
  final bool Function(K key) cached;

  final Map<K, Future<void>> _inFlight = {};
  final Set<K> _absent = {};
  List<K>? _queued;
  Future<void>? _next;

  Future<void> request(Iterable<K> keys) => Future.wait([
    for (final K key in keys.toSet())
      if (!_absent.contains(key) && !cached(key))
        _inFlight[key] ??= _queue(key),
  ]);

  Future<void> _queue(K key) {
    (_queued ??= []).add(key);
    return _next ??= Future(() async {
      final List<K> keys = _queued!;
      _queued = null;
      _next = null;
      try {
        final Set<K> found = (await load(keys)).toSet();
        _absent.addAll(keys.where((key) => !found.contains(key)));
      } finally {
        keys.forEach(_inFlight.remove);
      }
    });
  }
}
