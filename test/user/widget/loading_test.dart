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

  displayTest('a profile shows the name its summary knows while it loads', (
    tester,
  ) async {
    final Map<String, Object?> recorded = loadFixtureList('users.json').first;
    final int id = recorded['id']! as int;
    final String name = recorded['name']! as String;
    await tester.runAsync(() => env.client.users.usePartial(id: id).fetch());

    await tester.pumpWidget(env.app(UserLoadingPage(id)));
    await tester.pump();

    expect(skeletons(find.byType(UserPage)), findsOneWidget);
    expect(find.text(name), findsWidgets);

    await env.settle(tester);

    expect(skeletons(find.byType(UserPage)), findsNothing);
    expect(find.text(name), findsWidgets);
  });
}
