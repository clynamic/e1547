import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('the page buttons leave the page behind the gallery visible', (
    tester,
  ) async {
    final GlobalKey boundary = GlobalKey();
    final PageController controller = PageController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: RepaintBoundary(
          key: boundary,
          child: Stack(
            fit: StackFit.expand,
            children: [
              const ColoredBox(color: Color(0xFFFF0000)),
              GalleryButtons(
                controller: controller,
                child: PageView(
                  controller: controller,
                  children: const [SizedBox.expand(), SizedBox.expand()],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final Size size = tester.getSize(find.byKey(boundary));
    final Color center = (await tester.runAsync(() async {
      final RenderRepaintBoundary render =
          boundary.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final ui.Image image = await render.toImage();
      final ByteData data = (await image.toByteData())!;
      final int x = size.width ~/ 2;
      final int y = size.height ~/ 2;
      final int offset = (y * image.width + x) * 4;
      return Color.fromARGB(
        data.getUint8(offset + 3),
        data.getUint8(offset),
        data.getUint8(offset + 1),
        data.getUint8(offset + 2),
      );
    }))!;

    expect(center, const Color(0xFFFF0000));
  });
}
