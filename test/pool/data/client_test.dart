import 'package:e1547/pool/pool.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/client.dart';
import '../../_support/fake_e621.dart';
import '../../_support/fixtures.dart';
import '../../_support/harness.dart';

void main() {
  late FakeE621 fake;
  late PoolClient client;

  setUpAll(initializeTestApp);

  setUp(() async {
    fake = await FakeE621.start();
    client = PoolClient(dio: dioFor(fake));
  });

  tearDown(() => fake.stop());

  test('maps a recorded pool onto the model', () async {
    final recorded = loadFixtureList('pools.json').first;

    final pool = (await client.page()).first;

    expect(pool.id, recorded['id']);
    expect(pool.name, recorded['name']);
    expect(pool.postIds, recorded['post_ids']);
    expect(pool.postCount, recorded['post_count']);
    expect(pool.active, recorded['is_active']);
    expect(pool.description, recorded['description']);
  });

  test('reads a pool by id', () async {
    final recorded = loadFixtureList('pools.json').last;

    final pool = await client.get(id: recorded['id']! as int);

    expect(pool.name, recorded['name']);
  });
}
