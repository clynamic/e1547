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
}
