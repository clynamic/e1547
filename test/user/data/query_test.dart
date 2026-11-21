import 'package:e1547/user/user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/environment.dart';
import '../../_support/fixtures.dart';
import '../../_support/harness.dart';

void main() {
  setUpAll(initializeTestApp);

  late TestEnvironment env;

  setUp(() async => env = await TestEnvironment.start());

  tearDown(() => env.dispose());

  List<int> recorded() =>
      loadFixtureList('users.json').map((e) => e['id']! as int).toList();

  test('user summaries requested at once load in one request', () async {
    final List<int> ids = recorded().take(2).toList();
    env.fake.requests.clear();

    final List<PartialUser> users = await Future.wait([
      for (final int id in ids)
        env.client.users.usePartial(id: id).fetch().then((e) => e.data!),
    ]);

    expect(users.map((e) => e.id), ids);
    expect(env.fake.requests.map((e) => (e.path, e.query['search[id]'])), [
      ('/users.json', ids.join(',')),
    ]);
  });
}
