import 'package:e1547/pool/pool.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/environment.dart';
import '../../_support/fixtures.dart';
import '../../_support/harness.dart';

void main() {
  setUpAll(initializeTestApp);

  late TestEnvironment env;

  setUp(() async => env = await TestEnvironment.start());

  tearDown(() => env.dispose());

  test('pools asked for at once come in one request', () async {
    final List<int> ids = loadFixtureList(
      'pools.json',
    ).map((e) => e['id']! as int).take(2).toList();
    env.fake.requests.clear();

    final List<Pool> pools = await Future.wait([
      for (final int id in ids)
        env.client.pools.useGet(id: id).fetch().then((e) => e.data!),
    ]);

    expect(pools.map((e) => e.id), ids);
    expect(env.fake.requests.map((e) => (e.path, e.query['search[id]'])), [
      ('/pools.json', ids.join(',')),
    ]);
  });
}
