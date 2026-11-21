import 'package:e1547/post/post.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notified_preferences/notified_preferences.dart';

import '../../_support/posts.dart';
import '../../_support/video.dart';

void main() {
  late Settings settings;
  late VideoService videos;

  final first = samplePost(ext: 'webm', file: 'first.webm');
  final second = samplePost(id: 2, ext: 'webm', file: 'second.webm');

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    settings = Settings(await SharedPreferences.getInstance());
    videos = fakeVideoService();
  });

  tearDown(() {
    for (final post in [first, second]) {
      videos.unloadVideo(post.file!);
    }
    videos.dispose();
  });

  Widget app(Widget home) => MultiProvider(
    providers: [
      Provider<Settings>.value(value: settings),
      ChangeNotifierProvider<VideoService>.value(value: videos),
    ],
    child: MaterialApp(home: home),
  );

  VideoPlayer playerOf(WidgetTester tester, Post post) => tester
      .state<PostVideoRouteState>(
        find.byWidgetPredicate(
          (widget) => widget is PostVideoRoute && widget.post == post,
        ),
      )
      .player!;

  Widget fullscreen(Post post) => PostVideoRoute(
    post: post,
    stopOnDispose: false,
    child: Builder(
      builder: (context) => TextButton(
        onPressed: Navigator.of(context).pop,
        child: const Text('close'),
      ),
    ),
  );

  testWidgets('a fullscreen video pauses once it is swiped away', (
    tester,
  ) async {
    final controller = PageController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      app(
        PageView(
          controller: controller,
          children: [
            for (final post in [first, second]) fullscreen(post),
          ],
        ),
      ),
    );

    final player = playerOf(tester, first);
    await player.play();
    expect(player.state.playing, isTrue);

    controller.jumpToPage(1);
    await tester.pumpAndSettle();

    expect(player.state.playing, isFalse);
  });

  testWidgets('a fullscreen video pauses once its route is popped', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => fullscreen(first))),
            child: const Text('open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final player = playerOf(tester, first);
    await player.play();

    await tester.tap(find.text('close'));
    await tester.pumpAndSettle();

    expect(player.state.playing, isFalse);
  });

  testWidgets(
    'a fullscreen video keeps playing when its detail is shown again',
    (tester) async {
      await tester.pumpWidget(
        app(
          PostVideoRoute(
            post: first,
            child: Builder(
              builder: (context) => TextButton(
                onPressed: () {
                  PostVideoRoute.of(context).keepPlaying();
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => fullscreen(first)));
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      final player = playerOf(tester, first);
      await player.play();

      await tester.tap(find.text('close'));
      await tester.pumpAndSettle();

      expect(player.state.playing, isTrue);
    },
  );

  testWidgets('a route rebuilt with another post leases that post\'s video', (
    tester,
  ) async {
    await tester.pumpWidget(app(fullscreen(first)));
    final VideoPlayer previous = playerOf(tester, first);

    await tester.pumpWidget(app(fullscreen(second)));
    await tester.pump();

    final VideoPlayer current = playerOf(tester, second);
    expect(current, same(videos.getVideo(second.file!)));
    expect(current, isNot(same(previous)));
    expect(previous.isLeased, isFalse);
  });

  testWidgets('a route rebuilt with another post stops that video on close', (
    tester,
  ) async {
    Widget routes({required Post? leased}) => app(
      Column(
        children: [
          if (leased != null)
            PostVideoRoute(
              key: const ValueKey('leased'),
              post: leased,
              child: const SizedBox(),
            ),
          PostVideoRoute(
            key: const ValueKey('holder'),
            post: second,
            stopOnDispose: false,
            child: const SizedBox(),
          ),
        ],
      ),
    );
    await videos.getVideo(first.file!).play();
    await tester.pumpWidget(routes(leased: first));
    await tester.pump();

    await tester.pumpWidget(routes(leased: second));
    await tester.pump();
    final VideoPlayer player = videos.getVideo(second.file!);
    await player.play();

    await tester.pumpWidget(routes(leased: null));
    await tester.pump();

    expect(player.state.playing, isFalse);
  });

  testWidgets('a route builds its page anew only for another post', (
    tester,
  ) async {
    Future<State> pageOf(Post post) async {
      await tester.pumpWidget(
        app(
          PostVideoRoute(
            post: post,
            child: const Material(child: TextField()),
          ),
        ),
      );
      return tester.state(find.byType(EditableText));
    }

    final State page = await pageOf(first);

    expect(await pageOf(first.copyWith(score: first.score + 1)), same(page));
    expect(await pageOf(second), isNot(same(page)));
  });
}
