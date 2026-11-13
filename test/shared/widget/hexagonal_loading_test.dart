import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
    for (int i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    expect(refreshes, 1);
    expect(
      tester
          .widget<HexagonalLoadingIndicator>(
            find.byType(HexagonalLoadingIndicator, skipOffstage: false),
          )
          .state,
      HexagonState.loading,
    );

    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets(
    'a refresh that brings a note holds it above the list to be read',
    (tester) async {
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
      for (int i = 0; i < 8; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      final Finder note = find.text('Up to date', skipOffstage: false);

      expect(note, findsOneWidget);

      for (int i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(note, findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
      await tester.pump(const Duration(seconds: 1));
    },
  );
}
