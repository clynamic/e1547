import 'package:e1547/shared/shared.dart';
import 'package:e1547/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/single_child_widget.dart';

import '../../_support/environment.dart';
import '../../_support/fake_e621.dart';
import '../../_support/fixtures.dart';
import '../../_support/harness.dart';
import '../../_support/images.dart';

void main() {
  setUpAll(initializeTestApp);

  late TestEnvironment env;

  setUp(() async => env = await TestEnvironment.start());

  tearDown(() => env.dispose());

  List<Map<String, Object?>> recorded() => loadFixtureList('posts.json');

  Future<void> show(
    WidgetTester tester,
    List<Widget> avatars, {
    List<SingleChildWidget> providers = const [],
  }) async {
    await tester.runAsync(
      () => tester.pumpWidget(
        env.app(
          Scaffold(body: Row(children: avatars)),
          providers: providers,
        ),
      ),
    );
    await env.settle(tester);
  }

  List<String?> urls(WidgetTester tester) =>
      tester.widgetList<Avatar>(find.byType(Avatar)).map((e) => e.url).toList();

  Iterable<FakeRequest> postRequests() =>
      env.fake.requests.where((e) => e.path == '/posts.json');

  displayTest('avatars shown together come in one post request', (
    tester,
  ) async {
    final List<int> ids = recorded()
        .map((e) => e['id']! as int)
        .take(3)
        .toList();
    env.fake.requests.clear();

    await show(tester, [
      for (final (int index, int id) in ids.indexed)
        UserAvatar(id: id, userId: index + 1, hasCroppedAvatar: false),
    ]);

    expect(postRequests(), hasLength(1));
    expect(
      env.fake.requests.single.query,
      containsPair('tags', 'id:${ids.join(',')} status:any'),
    );
    expect(urls(tester), everyElement(isNotNull));
  });

  displayTest('a cropped avatar finds its media host through its post', (
    tester,
  ) async {
    final Map<String, Object?> post = recorded().first;
    final int id = post['id']! as int;

    await show(tester, [UserAvatar(id: id, userId: 7, hasCroppedAvatar: true)]);

    expect(postRequests(), hasLength(1));
    expect(urls(tester).single, endsWith('/data/avatars/7.jpg?t=$id'));
  });

  displayTest('an avatar that does not load shows the empty avatar', (
    tester,
  ) async {
    await show(
      tester,
      [const Avatar('https://media.example/missing.jpg')],
      providers: [
        Provider<BaseCacheManager>.value(
          value: const FailingImageCacheManager(),
        ),
      ],
    );
    await tester.pump();

    expect(
      find.descendant(
        of: find.byType(Avatar),
        matching: find.byType(EmptyAvatar),
      ),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.warning_amber), findsNothing);
  });
}
