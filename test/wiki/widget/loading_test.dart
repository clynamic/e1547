import 'package:e1547/wiki/wiki.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/environment.dart';
import '../../_support/harness.dart';

void main() {
  setUpAll(initializeTestApp);

  late TestEnvironment env;

  setUp(() async => env = await TestEnvironment.start());

  tearDown(() => env.dispose());

  displayTest('a wiki that failed to load loads again on retry', (
    tester,
  ) async {
    final Map<String, Object?> recorded = env.fake.state.wikis.first;
    final int id = recorded['id']! as int;
    env.fake.state.wikis.remove(recorded);

    await tester.pumpWidget(env.app(WikiLoadingPage(id)));
    await env.settle(tester);
    expect(find.text('Failed to load wiki'), findsOneWidget);

    env.fake.state.wikis.insert(0, recorded);
    await tester.tap(find.text('Try again'));
    await env.settle(tester);

    expect(find.byType(WikiPage), findsOneWidget);
  });
}
