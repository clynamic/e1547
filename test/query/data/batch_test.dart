import 'dart:async';

import 'package:e1547/query/query.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late List<List<int>> loads;
  late Set<int> cache;
  late Set<int> server;
  late QueryBatch<int> batch;

  setUp(() {
    loads = [];
    cache = {};
    server = {1, 2, 3, 4};
    batch = QueryBatch((keys) async {
      loads.add(keys);
      final List<int> found = keys.where(server.contains).toList();
      cache.addAll(found);
      return found;
    }, cached: cache.contains);
  });

  test('keys asked for in the same turn share one load', () async {
    await Future.wait([
      batch.request([1, 2]),
      batch.request([2, 3]),
    ]);

    expect(loads, [
      [1, 2, 3],
    ]);
  });

  test('a key already loading is not loaded again', () async {
    final Completer<void> gate = Completer();
    batch = QueryBatch((keys) async {
      loads.add(keys);
      await gate.future;
      return keys;
    }, cached: (_) => false);

    final Future<void> first = batch.request([1]);
    await Future<void>.delayed(Duration.zero);
    final Future<void> second = batch.request([1, 2]);
    gate.complete();
    await Future.wait([first, second]);

    expect(loads, [
      [1],
      [2],
    ]);
  });

  test('cached keys and keys the server did not return are skipped', () async {
    cache.add(1);
    await batch.request([1, 9]);
    await batch.request([1, 9, 2]);

    expect(loads, [
      [9],
      [2],
    ]);
  });

  test('a failed load lets its keys be asked again', () async {
    int calls = 0;
    batch = QueryBatch((keys) async {
      calls++;
      if (calls == 1) throw StateError('offline');
      return keys;
    }, cached: (_) => false);

    await expectLater(batch.request([1]), throwsStateError);
    await batch.request([1]);

    expect(calls, 2);
  });
}
