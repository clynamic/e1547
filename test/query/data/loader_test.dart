import 'dart:async';

import 'package:e1547/query/query.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late List<List<int>> loads;
  late Set<int> server;
  late QueryLoader<int, String> loader;

  QueryLoader<int, String> loaderOf(
    Future<Map<int, String>> Function(List<int> keys) load,
  ) => QueryLoader((keys) {
    loads.add(keys);
    return load(keys);
  });

  setUp(() {
    loads = [];
    server = {1, 2, 3, 4};
    loader = loaderOf(
      (keys) async => {
        for (final int key in keys)
          if (server.contains(key)) key: 'item $key',
      },
    );
  });

  test(
    'a turn with more keys than the limit loads them in batches of it',
    () async {
      loader = QueryLoader((keys) async {
        loads.add(keys);
        return {for (final int key in keys) key: 'item $key'};
      }, limit: 2);

      final List<String?> values = await Future.wait([
        for (int key = 1; key <= 5; key++) loader.fetch(key),
      ]);

      expect(loads, [
        [1, 2],
        [3, 4],
        [5],
      ]);
      expect(values, ['item 1', 'item 2', 'item 3', 'item 4', 'item 5']);
    },
  );

  test('keys asked for in the same turn share one load', () async {
    final List<String?> values = await Future.wait([
      loader.fetch(1),
      loader.fetch(2),
      loader.fetch(3),
    ]);

    expect(loads, [
      [1, 2, 3],
    ]);
    expect(values, ['item 1', 'item 2', 'item 3']);
  });

  test('keys asked once a load started go into the next load', () async {
    final Completer<void> gate = Completer();
    loader = loaderOf((keys) async {
      await gate.future;
      return {for (final int key in keys) key: 'item $key'};
    });

    final Future<String?> first = loader.fetch(1);
    await Future<void>.delayed(Duration.zero);
    final Future<String?> later = loader.fetch(2);
    gate.complete();
    await Future.wait([first, later]);

    expect(loads, [
      [1],
      [2],
    ]);
  });

  test('a key a load leaves out is null and not asked for again', () async {
    expect(await loader.fetch(9), isNull);
    expect(await loader.fetch(9), isNull);
    await expectLater(loader.require(9), throwsA(isA<QueryMissingException>()));

    expect(loads, [
      [9],
    ]);
  });

  test('a failed load fails its keys and lets them be asked again', () async {
    int calls = 0;
    loader = loaderOf((keys) async {
      calls++;
      if (calls == 1) throw StateError('offline');
      return {for (final int key in keys) key: 'item $key'};
    });

    await expectLater(
      Future.wait([loader.fetch(1), loader.fetch(2)]),
      throwsStateError,
    );
    expect(await loader.fetch(1), 'item 1');

    expect(loads, [
      [1, 2],
      [1],
    ]);
  });

  test('a key that loaded is loaded again when asked again', () async {
    await loader.fetch(1);
    server.remove(1);

    expect(await loader.fetch(1), isNull);
    expect(loads, [
      [1],
      [1],
    ]);
  });
}
