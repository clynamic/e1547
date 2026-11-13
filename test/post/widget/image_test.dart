import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e1547/post/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../_support/images.dart';
import '../../_support/posts.dart';

void main() {
  testWidgets('a post image under a page is drawn at once by a hero flight '
      'back after the app was hidden through memory pressure', (tester) async {
    final Uint8List png = (await tester.runAsync(() async {
      final ui.PictureRecorder recorder = ui.PictureRecorder();
      Canvas(recorder).drawRect(
        const Rect.fromLTWH(0, 0, 4, 4),
        Paint()..color = const Color(0xFFFF0000),
      );
      final ui.Image image = await recorder.endRecording().toImage(4, 4);
      final ByteData? data = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      return data!.buffer.asUint8List();
    }))!;
    const String url = 'http://example.invalid/post.png';
    final ServedImageCacheManager images = ServedImageCacheManager(png);
    final ValueNotifier<bool> hidden = ValueNotifier(false);
    addTearDown(hidden.dispose);
    final GlobalKey<NavigatorState> navigator = GlobalKey();

    await tester.pumpWidget(
      Provider<BaseCacheManager>.value(
        value: images,
        child: MaterialApp(
          navigatorKey: navigator,
          builder: (context, child) => ValueListenableBuilder<bool>(
            valueListenable: hidden,
            builder: (context, hidden, _) => Visibility(
              visible: !hidden,
              maintainState: true,
              child: child!,
            ),
          ),
          home: Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: SizedBox.square(
                dimension: 100,
                child: Hero(
                  tag: 'post',
                  child: RawPostImageWidget(
                    post: samplePost(file: url, preview: url),
                    size: PostImageSize.preview,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.runAsync(
      () => precacheImage(
        CachedNetworkImageProvider(url, cacheManager: images),
        tester.element(find.byType(RawPostImageWidget)),
      ),
    );
    await tester.pumpAndSettle();
    navigator.currentState!.push(
      MaterialPageRoute<void>(
        builder: (context) => Scaffold(
          body: Center(
            child: SizedBox.square(
              dimension: 300,
              child: Hero(tag: 'post', child: Image.memory(png)),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    hidden.value = true;
    await tester.pump();
    tester.binding.handleMemoryPressure();
    hidden.value = false;
    await tester.pump();
    navigator.currentState!.pop();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 16));

    final RawImage flight = tester.widget<RawImage>(
      find
          .descendant(
            of: find.byType(RawPostImageWidget),
            matching: find.byType(RawImage),
          )
          .first,
    );
    expect(flight.image, isNotNull);
    await tester.pumpAndSettle();
  });
}
