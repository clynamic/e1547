import 'package:e1547/follow/follow.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/environment.dart';
import '../../_support/harness.dart';

void main() {
  setUpAll(initializeTestApp);

  late TestEnvironment env;

  setUp(() async => env = await TestEnvironment.start());

  tearDown(() => env.dispose());

  test('rejects a rename onto tags another follow has', () async {
    final FollowClient follows = env.client.follows;
    await follows.create(tags: 'cat', type: FollowType.update);
    await follows.create(tags: 'dog', type: FollowType.update);
    final Follow dog = (await follows.getByTags(tags: 'dog'))!;

    await expectLater(
      follows.update(id: dog.id, tags: 'Cat'),
      throwsA(isA<FollowTagsTakenException>()),
    );
    await follows.update(id: dog.id, tags: 'Dog');

    expect((await follows.all()).map((e) => e.tags).toSet(), {'cat', 'Dog'});
  });
}
