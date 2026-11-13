import 'package:e1547/post/post.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/environment.dart';
import '../../_support/harness.dart';

void main() {
  setUpAll(initializeTestApp);

  late TestEnvironment env;

  setUp(() async => env = await TestEnvironment.start());

  tearDown(() => env.dispose());

  displayTest('a search for the posts of a user is titled as their uploads', (
    tester,
  ) async {
    await tester.runAsync(
      () => tester.pumpWidget(
        env.app(const PostsPage(params: PostParams(tags: 'user:uploader'))),
      ),
    );
    await env.settle(tester);

    expect(find.text("uploader's Uploads"), findsOneWidget);
  });
}
