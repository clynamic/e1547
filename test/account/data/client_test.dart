import 'package:flutter_test/flutter_test.dart';

import '../../_support/environment.dart';
import '../../_support/harness.dart';

void main() {
  late TestEnvironment env;

  setUpAll(initializeTestApp);

  setUp(() async => env = await TestEnvironment.start());

  tearDown(() => env.dispose());

  test('checks availability with a single post listing', () async {
    await env.client.accounts.available();

    final request = env.fake.requests.singleWhere(
      (e) => e.path == '/posts.json',
    );
    expect(request.method, 'HEAD');
    expect(request.query, {'limit': '1'});
  });
}
