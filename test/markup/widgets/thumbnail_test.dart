import 'package:e1547/markup/markup.dart';
import 'package:e1547/post/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/environment.dart';
import '../../_support/fixtures.dart';
import '../../_support/harness.dart';

void main() {
  setUpAll(initializeTestApp);

  late TestEnvironment env;

  setUp(() async => env = await TestEnvironment.start());

  tearDown(() => env.dispose());

  displayTest('the first ten thumbs become thumbnails, the rest stay links', (
    tester,
  ) async {
    await tester.runAsync(
      () => tester.pumpWidget(
        env.app(
          Scaffold(
            body: DText([for (int i = 1; i <= 11; i++) 'thumb #$i'].join(' ')),
          ),
        ),
      ),
    );
    await env.settle(tester);

    expect(
      tester
          .widgetList<PostThumbnail>(find.byType(PostThumbnail))
          .map((e) => e.id),
      [for (int i = 1; i <= 10; i++) i],
    );
    expect(find.textContaining('#11', findRichText: true), findsOneWidget);
  });

  displayTest('thumbs of one text load their posts in one request', (
    tester,
  ) async {
    final List<int> ids = loadFixtureList(
      'posts.json',
    ).map((e) => e['id']! as int).take(3).toList();
    env.fake.requests.clear();

    await tester.runAsync(
      () => tester.pumpWidget(
        env.app(Scaffold(body: DText(ids.map((e) => 'thumb #$e').join(' ')))),
      ),
    );
    await env.settle(tester);

    expect(
      tester
          .widgetList<PostTileOverlay>(find.byType(PostTileOverlay))
          .map((e) => e.post.id),
      ids,
    );
    expect(
      env.fake.requests.where((e) => e.path == '/posts.json'),
      hasLength(1),
    );
  });
}
