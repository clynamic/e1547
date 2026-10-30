import 'package:e1547/app/app.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/bed.dart';
import '../../_support/gestures.dart';
import '../../_support/harness.dart';
import '../../_support/images.dart';
import '../../_support/posts.dart';

void main() {
  late TestBed bed;

  setUpAll(initializeTestApp);

  setUp(() async => bed = await TestBed.start());

  tearDown(() => bed.dispose());

  /// Opens a post detail route from a tree layered like the app, where the
  /// client sits above the [Navigator] and the post list below it, so the route
  /// sees only what it was handed.
  Future<void> pushDetail(
    WidgetTester tester,
    PostFilter filter, {
    Post? post,
    BaseCacheManager images = const NoImageCacheManager(),
    WidgetBuilder? opener,
  }) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        bed.app(
          theme: AppTheme.dark.data,
          providers: [Provider<BaseCacheManager>.value(value: images)],
          FilterControllerProvider<PostFilter, Post>.value(
            value: filter,
            child: ChangeNotifierProvider(
              create: (_) => PostParamsController(),
              child: ImageCacheSizeProvider(
                size: null,
                child: KeyedSubtree(
                  key: const ValueKey('open'),
                  child: Builder(
                    builder: (context) =>
                        opener?.call(context) ??
                        TextButton(
                          onPressed: () => defaultPushPostDetail(
                            context,
                            post ?? samplePost(),
                          ),
                          child: const Text('open'),
                        ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await Future<void>.delayed(const Duration(milliseconds: 50));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('open')));
      await tester.pump();
      // The gallery queries as it opens, so that request has to land before
      // the tree is torn down.
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await bed.settle(tester, animating: true);
  }

  Future<void> openFullscreen(WidgetTester tester) async {
    await tester.pump(const Duration(seconds: 1));
    await tester.runAsync(() async {
      await tester.tap(find.byType(PostDetailImageDisplay));
      await tester.pump();
      await Future<void>.delayed(imageLoadPatience * 2);
    });
    for (int frame = 0; frame < 3; frame++) {
      await tester.pump(const Duration(seconds: 1));
    }
  }

  displayTest('a pushed gallery keeps the filter of its list', (tester) async {
    final filter = PostFilter(bed.client);
    addTearDown(filter.dispose);

    await pushDetail(tester, filter, post: samplePost(id: 1000));

    final gallery = tester.element(find.byType(PostDetailGallery));
    expect(gallery.read<FilterController<Post>?>(), same(filter));
  });

  displayTest('a pushed gallery drops the posts its list denies', (
    tester,
  ) async {
    bed.traits.value = bed.traits.value.copyWith(denylist: ['tag_47']);
    final filter = PostFilter(bed.client);
    addTearDown(filter.dispose);

    await pushDetail(tester, filter, post: samplePost(id: 1000));

    final view = tester.widget<PagedPageView<int, Post>>(
      find.byType(PagedPageView<int, Post>),
    );
    expect(view.state.items?.map((post) => post.id), [1000]);
  });

  void seedDeniedChild() {
    bed.traits.value = bed.traits.value.copyWith(denylist: ['bad_tag']);
    bed.client.posts.postCache.set(
      samplePost(
        id: 1049,
        tags: const {
          'general': ['bad_tag'],
        },
        file: 'http://example.invalid/1049.jpg',
        preview: 'http://example.invalid/1049.jpg',
      ),
    );
  }

  Future<void> openFirstRelation(WidgetTester tester) async {
    await tester.scrollUntilVisible(
      find.byType(PostFamilySection),
      200,
      scrollable: find
          .descendant(
            of: find.byType(PostDetail),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await Scrollable.ensureVisible(
      tester.element(find.byType(PostThumbnail).first),
      alignment: 0.5,
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.runAsync(() async {
      await tester.tap(find.byType(PostThumbnail).first);
      await tester.pump();
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await tester.pump(const Duration(seconds: 1));
  }

  displayTest('an avatar opens its post under the blacklist', (tester) async {
    seedDeniedChild();
    bed.client.posts.postCache.set(
      bed.client.posts.postCache
          .get(1049)!
          .copyWith(sample: 'http://example.invalid/1049.jpg'),
    );
    final filter = PostFilter(bed.client);
    addTearDown(filter.dispose);

    await pushDetail(
      tester,
      filter,
      opener: (context) =>
          const UserAvatar(id: 1049, userId: 1, hasCroppedAvatar: false),
    );
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(PostDetail), findsOneWidget);
    expect(find.text('Post is blacklisted'), findsOneWidget);
  });

  displayTest('a blacklisted post offers show', (tester) async {
    seedDeniedChild();
    final filter = PostFilter(bed.client);
    addTearDown(filter.dispose);

    await pushDetail(tester, filter, post: samplePost(id: 1042));
    await tester.pump(const Duration(seconds: 1));
    await openFirstRelation(tester);
    expect(find.text('Post is blacklisted'), findsOneWidget);
    expect(find.text('show'), findsOneWidget);

    await tester.tap(find.text('show'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Post is blacklisted'), findsNothing);
    expect(find.text('hide'), findsOneWidget);
  });

  displayTest('the hide button leaves with the blacklist off', (tester) async {
    bed.traits.value = bed.traits.value.copyWith(denylist: ['tag_2']);
    final filter = PostFilter(bed.client)..denying = false;
    addTearDown(filter.dispose);

    await pushDetail(tester, filter, post: samplePost(id: 1000));
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(PostDetailImageDisplay), findsOneWidget);
    expect(find.text('Post is blacklisted'), findsNothing);
    expect(find.text('hide'), findsNothing);
  });

  displayTest('a child opened from a relation keeps the filter', (
    tester,
  ) async {
    seedDeniedChild();
    final filter = PostFilter(bed.client)..denying = false;
    addTearDown(filter.dispose);

    await pushDetail(tester, filter, post: samplePost(id: 1042));
    await tester.pump(const Duration(seconds: 1));
    await openFirstRelation(tester);

    final child = tester.element(
      find.descendant(
        of: find.byType(PostLoadingPage),
        matching: find.byType(PostDetail),
      ),
    );
    expect(child.read<PostFilter?>(), same(filter));
    expect(find.text('Post is blacklisted'), findsNothing);
  });

  displayTest('pulling a post detail down from its top closes it', (
    tester,
  ) async {
    final filter = PostFilter(bed.client);
    addTearDown(filter.dispose);

    await pushDetail(tester, filter, post: samplePost(id: 1000));
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(PostDetail), findsOneWidget);

    await tester.timedDrag(
      find.byType(PostDetail),
      const Offset(0, 300),
      const Duration(seconds: 1),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(PostDetail), findsNothing);
    expect(find.text('open'), findsOneWidget);
  });

  displayTest('dragging a fullscreen image down returns to its detail', (
    tester,
  ) async {
    final filter = PostFilter(bed.client);
    addTearDown(filter.dispose);

    await pushDetail(tester, filter, post: samplePost(id: 1000));
    await tester.pump(const Duration(seconds: 1));
    await tester.runAsync(() async {
      await tester.tap(find.byType(PostDetailImageDisplay));
      await tester.pump();
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(Zoomable), findsOneWidget);

    await tester.timedDrag(
      find.byType(Zoomable),
      const Offset(0, 300),
      const Duration(seconds: 1),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(PostFullscreen), findsNothing);
    expect(find.byType(PostDetail), findsOneWidget);
  });

  displayTest('a zoomed fullscreen image pans where it has room', (
    tester,
  ) async {
    final filter = PostFilter(bed.client);
    addTearDown(filter.dispose);

    await pushDetail(tester, filter, post: samplePost(id: 1000));
    await tester.pump(const Duration(seconds: 1));
    await tester.runAsync(() async {
      await tester.tap(find.byType(PostDetailImageDisplay));
      await tester.pump();
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await tester.pump(const Duration(seconds: 1));

    await doubleTap(tester, tester.getCenter(find.byType(Zoomable)));

    final Zoomable image = tester.widget(find.byType(Zoomable));
    final double before = image.controller.transformation.value
        .getTranslation()
        .y;
    await tester.timedDrag(
      find.byType(Zoomable),
      const Offset(0, -100),
      const Duration(seconds: 1),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    final PageView pages = tester.widget(find.byType(PageView));
    expect(pages.controller!.page, 0);
    expect(find.byType(PostFullscreen), findsOneWidget);
    expect(
      image.controller.transformation.value.getTranslation().y,
      lessThan(before - 50),
    );
  });

  displayTest('a fullscreen swipe moves the detail beneath once it settles', (
    tester,
  ) async {
    final filter = PostFilter(bed.client);
    addTearDown(filter.dispose);

    await pushDetail(tester, filter, post: samplePost(id: 1000));
    await tester.pump(const Duration(seconds: 1));
    await tester.runAsync(() async {
      await tester.tap(find.byType(PostDetailImageDisplay));
      await tester.pump();
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await tester.pump(const Duration(seconds: 1));

    List<int> details() => tester
        .widgetList<PostDetail>(find.byType(PostDetail, skipOffstage: false))
        .map((detail) => detail.post.id)
        .toList();

    final TestGesture finger = await tester.startGesture(
      const Offset(700, 300),
    );
    await tester.runAsync(() async {
      for (int step = 0; step < 60; step++) {
        await finger.moveBy(const Offset(-10, 0));
        await tester.pump(const Duration(milliseconds: 16));
      }
    });
    expect(details(), [1000]);

    await tester.runAsync(() async {
      await finger.up();
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
    });
    await bed.settle(tester, animating: true);

    expect(details(), [1021]);
  });

  final Finder loadBar = find.descendant(
    of: find.byType(ImageLoadOverlay),
    matching: find.byType(LinearProgressIndicator),
  );

  displayTest('a loading fullscreen image has its bar follow the zoom', (
    tester,
  ) async {
    final filter = PostFilter(bed.client);
    addTearDown(filter.dispose);

    await pushDetail(
      tester,
      filter,
      post: samplePost(id: 1000),
      images: const PendingImageCacheManager(),
    );
    await openFullscreen(tester);

    final Rect image = tester.getRect(find.byType(PostImageWidget).last);
    expect(tester.getRect(loadBar).left, image.left);
    expect(tester.getRect(loadBar).width, image.width);
    expect(tester.getRect(loadBar).top, image.top);

    await doubleTap(tester, tester.getCenter(find.byType(Zoomable)));

    final Size screen = tester.getSize(find.byType(Zoomable));
    expect(tester.getRect(loadBar).width, screen.width);
    expect(tester.getRect(loadBar).width, greaterThan(image.width));
  });

  displayTest('a loading fullscreen image shows how far its download is', (
    tester,
  ) async {
    final filter = PostFilter(bed.client);
    addTearDown(filter.dispose);

    await pushDetail(
      tester,
      filter,
      post: samplePost(id: 1000),
      images: const PendingImageCacheManager(downloaded: 40),
    );
    await openFullscreen(tester);

    expect(tester.widget<LinearProgressIndicator>(loadBar).value, 0.4);
  });

  displayTest('a fullscreen image that failed to load has no bar', (
    tester,
  ) async {
    final filter = PostFilter(bed.client);
    addTearDown(filter.dispose);

    await pushDetail(
      tester,
      filter,
      post: samplePost(id: 1000),
      images: const FailingImageCacheManager(),
    );
    await openFullscreen(tester);

    expect(find.byType(ImageLoadOverlay), findsOneWidget);
    expect(loadBar, findsNothing);
  });

  displayTest('a fullscreen drag the system cancels stays open', (
    tester,
  ) async {
    final filter = PostFilter(bed.client);
    addTearDown(filter.dispose);

    await pushDetail(tester, filter, post: samplePost(id: 1000));
    await openFullscreen(tester);

    final TestGesture finger = await dragSlowly(
      tester,
      tester.getCenter(find.byType(Zoomable)),
      const Offset(0, -10),
    );
    await finger.cancel();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(PostFullscreen), findsOneWidget);
  });

  displayTest('a swipe from the system gesture area leaves fullscreen open', (
    tester,
  ) async {
    reserveBottomGestureArea(tester);
    final filter = PostFilter(bed.client);
    addTearDown(filter.dispose);

    await pushDetail(tester, filter, post: samplePost(id: 1000));
    await openFullscreen(tester);

    final Rect screen = tester.getRect(find.byType(Zoomable));
    final TestGesture finger = await dragSlowly(
      tester,
      screen.bottomCenter - const Offset(0, 10),
      const Offset(0, -10),
    );
    await finger.up();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(PostFullscreen), findsOneWidget);
  });

  displayTest(
    'a drag that starts on the play button closes a fullscreen video',
    (tester) async {
      final filter = PostFilter(bed.client);
      addTearDown(filter.dispose);

      await pushDetail(tester, filter, post: samplePost(id: 1000));
      await openFullscreen(tester);
      await tester.runAsync(() async {
        await tester.timedDrag(
          find.byType(PostFullscreen),
          const Offset(-500, 0),
          const Duration(milliseconds: 500),
        );
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
      });
      await bed.settle(tester, animating: true);

      await tester.timedDrag(
        find.byType(VideoButton),
        const Offset(0, 300),
        const Duration(seconds: 1),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(PostFullscreen), findsNothing);
      expect(find.byType(PostDetail), findsOneWidget);
    },
  );
}
