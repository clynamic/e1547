import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> frames(WidgetTester tester, int count) async {
    for (int i = 0; i < count; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
  }

  testWidgets('a refreshing list shows the travelling hexagon above it', (
    tester,
  ) async {
    int refreshes = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PullToRefresh(
            onRefresh: () async {
              refreshes++;
              await Future<void>.delayed(const Duration(seconds: 1));
            },
            child: ListView(
              children: [
                for (int i = 0; i < 40; i++)
                  SizedBox(height: 48, child: Text('line $i')),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.f5);
    await frames(tester, 15);

    expect(refreshes, 1);
    final Finder hexagon = find.byType(HexagonalLoadingIndicator);
    expect(
      tester.widget<HexagonalLoadingIndicator>(hexagon).state,
      HexagonState.loading,
    );
    expect(tester.getRect(hexagon).top, greaterThanOrEqualTo(0));
    expect(
      tester.getRect(hexagon).bottom,
      lessThanOrEqualTo(tester.getRect(find.text('line 0')).top),
    );

    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('a refresh with a note shows it above the list for a while', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PullToRefresh.noted(
            onRefresh: () async {
              await Future<void>.delayed(const Duration(milliseconds: 200));
              return const RefreshNote('Up to date');
            },
            child: ListView(
              children: [
                for (int i = 0; i < 40; i++)
                  SizedBox(height: 48, child: Text('line $i')),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.f5);
    await frames(tester, 30);
    final Finder note = find.text('Up to date');
    final Rect rested = tester.getRect(note);

    expect(rested.top, greaterThanOrEqualTo(0));
    expect(
      rested.bottom,
      lessThanOrEqualTo(tester.getRect(find.text('line 0')).top),
    );

    await frames(tester, 82);

    expect(tester.getRect(note), rested);

    await frames(tester, 20);

    expect(note, findsNothing);

    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(seconds: 1));
  });
}
