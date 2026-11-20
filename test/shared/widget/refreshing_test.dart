import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('refreshes only the list on the current page on F5', (
    tester,
  ) async {
    final Map<String, int> refreshed = {'below': 0, 'current': 0};

    Widget list(String name) => Scaffold(
      body: PullToRefresh(
        onRefresh: () async => refreshed[name] = refreshed[name]! + 1,
        child: ListView(children: [Text(name)]),
      ),
    );

    await tester.pumpWidget(MaterialApp(home: list('below')));
    Navigator.of(
      tester.element(find.text('below')),
    ).push(MaterialPageRoute(builder: (context) => list('current')));
    await tester.pumpAndSettle();

    await tester.sendKeyEvent(LogicalKeyboardKey.f5);
    await tester.pumpAndSettle();

    expect(refreshed, {'below': 0, 'current': 1});
  });
}
