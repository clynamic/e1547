import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const double drawerWidth = 304;
  const double fabMargin = 16;

  Future<void> show(
    WidgetTester tester, {
    required double width,
    required FloatingActionButtonLocation location,
    bool drawer = false,
    bool endDrawer = false,
  }) async {
    tester.view.physicalSize = Size(width, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: AdaptiveScaffold(
          drawer: drawer ? const Drawer() : null,
          endDrawer: endDrawer ? const Drawer() : null,
          floatingActionButtonLocation: location,
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
          body: const SizedBox.expand(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Rect fab(WidgetTester tester) =>
      tester.getRect(find.byType(FloatingActionButton));

  testWidgets('a start fab clears an inline drawer', (tester) async {
    await show(
      tester,
      width: 1300,
      drawer: true,
      location: FloatingActionButtonLocation.startFloat,
    );
    expect(fab(tester).left, moreOrLessEquals(drawerWidth + fabMargin));
  });

  testWidgets('an end fab clears an inline end drawer', (tester) async {
    await show(
      tester,
      width: 1700,
      endDrawer: true,
      location: FloatingActionButtonLocation.endFloat,
    );
    expect(fab(tester).right, moreOrLessEquals(1700 - drawerWidth - fabMargin));
  });

  testWidgets('a start fab is at the edge while the drawer is an overlay', (
    tester,
  ) async {
    await show(
      tester,
      width: 800,
      drawer: true,
      location: FloatingActionButtonLocation.startFloat,
    );
    expect(fab(tester).left, moreOrLessEquals(fabMargin));
  });

  testWidgets('an end fab keeps its place beside an inline start drawer', (
    tester,
  ) async {
    await show(
      tester,
      width: 1300,
      drawer: true,
      location: FloatingActionButtonLocation.endFloat,
    );
    expect(fab(tester).right, moreOrLessEquals(1300 - fabMargin));
  });
}
