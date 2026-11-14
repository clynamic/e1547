import 'package:e1547/post/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/environment.dart';
import '../../_support/harness.dart';
import '../../_support/posts.dart';

void main() {
  setUpAll(initializeTestApp);

  late TestEnvironment env;

  setUp(() async => env = await TestEnvironment.start());

  tearDown(() => env.dispose());

  Future<void> show(WidgetTester tester, Post post) => tester.pumpWidget(
    env.app(
      Scaffold(
        body: PostTileOverlay(post: post, child: const Text('image')),
      ),
    ),
  );

  displayTest(
    'a tile marks a post it cannot show with an icon for the reason',
    (tester) async {
      final Post shown = samplePost(file: 'https://e621.example/full.jpg');

      await show(tester, shown);
      expect(find.text('image'), findsOneWidget);

      await show(tester, shown.copyWith(isDeleted: true));
      expect(find.byIcon(Icons.delete), findsOneWidget);
      expect(find.text('image'), findsNothing);

      await show(tester, shown.copyWith(file: null));
      expect(find.byIcon(Icons.lock), findsOneWidget);

      await show(tester, shown.copyWith(ext: 'swf'));
      expect(find.byIcon(Icons.open_in_new), findsOneWidget);
    },
  );

  displayTest('the post page marks a post it cannot show with the icon its '
      'tile has', (tester) async {
    final Post shown = samplePost(file: 'https://e621.example/full.jpg');
    Future<void> page(Post post) => tester.pumpWidget(
      env.app(
        Scaffold(
          body: PostImageOverlay(
            post: post,
            builder: (context) => const Text('image'),
          ),
        ),
      ),
    );

    await page(shown.copyWith(file: null, isDeleted: true));
    expect(find.byIcon(Icons.delete), findsOneWidget);
    expect(find.text('Post was deleted'), findsOneWidget);

    await page(shown.copyWith(file: null));
    expect(find.byIcon(Icons.lock), findsOneWidget);
    expect(find.text('Post is unavailable'), findsOneWidget);

    await page(shown.copyWith(ext: 'swf'));
    expect(find.byIcon(Icons.open_in_new), findsOneWidget);
    expect(find.text('Open'), findsOneWidget);
  });
}
