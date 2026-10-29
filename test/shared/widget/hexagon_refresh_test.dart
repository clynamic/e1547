import 'dart:async';

import 'package:e1547/shared/shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpList(
    WidgetTester tester,
    Future<void> Function() onRefresh, {
    RefreshNote? note,
  }) => tester.pumpWidget(
    MaterialApp(
      home: ListenableProvider<RefreshNote?>.value(
        value: note,
        child: Scaffold(
          body: CustomScrollView(
            physics: refreshPhysics,
            slivers: [
              SliverHexagonRefresh(
                onRefresh: onRefresh,
                headerExtent: 72,
                header: const Text('header'),
              ),
              SliverList.list(
                children: [
                  const SizedBox(key: ValueKey('first'), height: 100),
                  for (int i = 0; i < 19; i++) const SizedBox(height: 100),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );

  HexagonRefreshPainter? painter(WidgetTester tester) => tester
      .widgetList<CustomPaint>(find.byType(CustomPaint))
      .map((e) => e.painter)
      .whereType<HexagonRefreshPainter>()
      .firstOrNull;

  testWidgets('a long pull refreshes and holds the hexagon while loading', (
    tester,
  ) async {
    final Completer<void> loading = Completer();
    int refreshes = 0;
    await pumpList(tester, () {
      refreshes++;
      return loading.future;
    });

    await tester.drag(find.text('header'), const Offset(0, 500));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    expect(refreshes, 1);
    expect(painter(tester)?.mode, RefreshIndicatorMode.refresh);
    expect(
      tester.getTopLeft(find.byType(HexagonRefreshIndicator)).dy,
      greaterThanOrEqualTo(tester.getBottomLeft(find.text('header')).dy),
    );

    loading.complete();
    await tester.pumpAndSettle();

    expect(find.byType(HexagonRefreshIndicator), findsNothing);
  });

  testWidgets('a note left by the refresh shows where the pull opened', (
    tester,
  ) async {
    final RefreshNote note = RefreshNote();
    addTearDown(note.dispose);
    await pumpList(tester, () async {
      note.value = (context, refresh) => const Text('nothing new');
    }, note: note);

    await tester.drag(find.text('header'), const Offset(0, 500));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('nothing new'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('nothing new')).dy,
      greaterThanOrEqualTo(tester.getBottomLeft(find.text('header')).dy),
    );

    await tester.pump(const Duration(milliseconds: 700));
    expect(find.text('nothing new'), findsOneWidget);

    await tester.pump(refreshNoteDuration);
    await tester.pumpAndSettle();

    expect(find.text('nothing new'), findsNothing);
    expect(find.byType(HexagonRefreshIndicator), findsNothing);
  });

  testWidgets('a touch closes the note left by the refresh', (tester) async {
    final RefreshNote note = RefreshNote();
    addTearDown(note.dispose);
    await pumpList(tester, () async {
      note.value = (context, refresh) => const Text('nothing new');
    }, note: note);
    await tester.drag(find.text('header'), const Offset(0, 500));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('nothing new'), findsOneWidget);

    final TestGesture gesture = await tester.startGesture(
      tester.getCenter(find.text('header')),
    );
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    expect(find.text('nothing new'), findsNothing);
  });

  testWidgets('a pull past the line refreshes once it is let go', (
    tester,
  ) async {
    int refreshes = 0;
    await pumpList(tester, () async => refreshes++);

    final TestGesture gesture = await tester.startGesture(
      tester.getCenter(find.text('header')),
    );
    for (int i = 0; i < 4; i++) {
      await gesture.moveBy(const Offset(0, 40));
      await tester.pump();
    }
    await tester.pump(const Duration(milliseconds: 100));

    expect(painter(tester)?.mode, RefreshIndicatorMode.armed);
    expect(refreshes, 0);

    await gesture.up();
    await tester.pump();
    await tester.pump();

    expect(refreshes, 1);
    await tester.pumpAndSettle();
  });

  testWidgets('a pull taken back under the line refreshes nothing', (
    tester,
  ) async {
    int refreshes = 0;
    await pumpList(tester, () async => refreshes++);

    final TestGesture gesture = await tester.startGesture(
      tester.getCenter(find.text('header')),
    );
    for (int i = 0; i < 10; i++) {
      await gesture.moveBy(const Offset(0, 50));
      await tester.pump();
    }
    for (int i = 0; i < 10; i++) {
      await gesture.moveBy(const Offset(0, -50));
      await tester.pump();
    }
    await gesture.up();
    await tester.pumpAndSettle();

    expect(refreshes, 0);
  });

  testWidgets('a short pull raises the hexagon from behind the header', (
    tester,
  ) async {
    await pumpList(tester, () async {});

    final TestGesture gesture = await tester.startGesture(
      tester.getCenter(find.text('header')),
    );
    await gesture.moveBy(const Offset(0, 20));
    await gesture.moveBy(const Offset(0, 20));
    await tester.pump();

    final double edge = tester
        .getTopLeft(find.byKey(const ValueKey('first')))
        .dy;
    expect(edge, inExclusiveRange(72, 72 + hexagonRefreshSize));
    final Rect hexagon = tester.getRect(find.byType(HexagonRefreshIndicator));
    expect(hexagon.bottom, closeTo(edge, 0.5));
    expect(hexagon.height, hexagonRefreshSize);

    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('a short pull draws part of the outline and refreshes nothing', (
    tester,
  ) async {
    int refreshes = 0;
    await pumpList(tester, () async => refreshes++);

    final TestGesture gesture = await tester.startGesture(
      tester.getCenter(find.text('header')),
    );
    await gesture.moveBy(const Offset(0, 20));
    await gesture.moveBy(const Offset(0, 40));
    await tester.pump();

    expect(painter(tester)?.mode, RefreshIndicatorMode.drag);
    expect(painter(tester)?.progress, inExclusiveRange(0, 1));
    expect(tester.getTopLeft(find.text('header')).dy, 0);
    expect(
      tester.getTopLeft(find.byType(HexagonRefreshIndicator)).dy,
      greaterThanOrEqualTo(tester.getBottomLeft(find.text('header')).dy),
    );

    await gesture.up();
    await tester.pumpAndSettle();
    expect(refreshes, 0);
  });

  testWidgets('tapping the active tab refreshes through the shortcuts', (
    tester,
  ) async {
    final NavBarReselectController reselect = NavBarReselectController();
    int refreshes = 0;
    await tester.pumpWidget(
      NavBarReselect(
        controller: reselect,
        child: RefreshShortcuts(
          onRefresh: () async => refreshes++,
          child: const SizedBox(),
        ),
      ),
    );

    await reselect.reselect();

    expect(refreshes, 1);
  });

  testWidgets('F5 refreshes only the page in view', (tester) async {
    final List<String> refreshed = [];
    final GlobalKey<NavigatorState> navigator = GlobalKey();
    Widget page(String name) => RefreshShortcuts(
      onRefresh: () async => refreshed.add(name),
      child: Text(name),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Column(
          children: [
            Expanded(
              child: TickerMode(enabled: false, child: page('hidden tab')),
            ),
            Expanded(
              child: Navigator(
                key: navigator,
                onGenerateRoute: (_) =>
                    MaterialPageRoute(builder: (context) => page('covered')),
              ),
            ),
          ],
        ),
      ),
    );
    navigator.currentState!.push(
      MaterialPageRoute(builder: (context) => page('on top')),
    );
    await tester.pumpAndSettle();

    await tester.sendKeyEvent(LogicalKeyboardKey.f5);

    expect(refreshed, ['on top']);
  });

  testWidgets('after a rebuild, F5 and the tab reach the newest refresh', (
    tester,
  ) async {
    final NavBarReselectController reselect = NavBarReselectController();
    final List<String> refreshed = [];
    Widget page(String name) => MaterialApp(
      home: NavBarReselect(
        controller: reselect,
        child: RefreshShortcuts(
          onRefresh: () async => refreshed.add(name),
          child: const SizedBox(),
        ),
      ),
    );
    await tester.pumpWidget(page('first'));
    await tester.pumpWidget(page('second'));

    await tester.sendKeyEvent(LogicalKeyboardKey.f5);
    await reselect.reselect();

    expect(refreshed, ['second', 'second']);
  });
}
