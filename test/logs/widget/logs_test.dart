import 'package:e1547/logs/logs.dart';
import 'package:e1547/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notified_preferences/notified_preferences.dart';
import 'package:provider/provider.dart';

class FakeLogSource extends LogSource {
  int _id = 0;

  @override
  bool get live => true;

  void add(String event, {LogLevel level = LogLevel.info}) {
    internalEntries.add(
      LogEntry(
        time: DateTime(2026),
        level: level,
        source: 'Test',
        event: event,
        attributes: const {'detail': 'value'},
        id: _id++,
      ),
    );
    notifyListeners();
  }
}

Widget wrap(Widget child) => MaterialApp(home: child);

Finder scrollView() => find.descendant(
  of: find.byType(CustomScrollView),
  matching: find.byType(Scrollable),
);

ScrollPosition positionOf(WidgetTester tester) =>
    tester.state<ScrollableState>(scrollView()).position;

Finder tileOf(String event) =>
    find.ancestor(of: find.text(event), matching: find.byType(LogEntryTile));

void main() {
  group('LogPage follows the newest entry', () {
    testWidgets('holds the scroll position while entries are added', (
      tester,
    ) async {
      final source = FakeLogSource();
      for (int i = 0; i < 40; i++) {
        source.add('entry $i');
      }
      await tester.pumpWidget(wrap(LogPage(source: source)));

      await tester.drag(scrollView(), const Offset(0, 300));
      await tester.pumpAndSettle();
      expect(positionOf(tester).pixels, greaterThan(0));

      final double before = tester.getTopLeft(tileOf('entry 30')).dy;
      source.add('entry fresh');
      await tester.pump();

      expect(tester.getTopLeft(tileOf('entry 30')).dy, before);
      expect(find.text('entry fresh'), findsNothing);
    });

    testWidgets('shows entries added while away once scrolled back', (
      tester,
    ) async {
      final source = FakeLogSource();
      for (int i = 0; i < 40; i++) {
        source.add('entry $i');
      }
      await tester.pumpWidget(wrap(LogPage(source: source)));

      await tester.drag(scrollView(), const Offset(0, 300));
      await tester.pumpAndSettle();
      source.add('entry fresh');
      await tester.pump();
      expect(find.text('entry fresh'), findsNothing);

      await tester.drag(scrollView(), const Offset(0, -300));
      await tester.pumpAndSettle();

      expect(positionOf(tester).pixels, 0);
      expect(find.text('entry fresh'), findsOneWidget);
    });

    testWidgets('leaves neighbouring entries closed', (tester) async {
      final source = FakeLogSource();
      for (int i = 0; i < 3; i++) {
        source.add('entry $i');
      }
      await tester.pumpWidget(wrap(LogPage(source: source)));

      await tester.tap(tileOf('entry 2'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);

      final double collapsed = tester.getSize(tileOf('entry 1')).height;
      final double expanded = tester.getSize(tileOf('entry 2')).height;
      source.add('entry fresh');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(tester.getSize(tileOf('entry fresh')).height, collapsed);
      expect(tester.getSize(tileOf('entry 2')).height, expanded);
      expect(
        find.descendant(
          of: tileOf('entry 2'),
          matching: find.byIcon(Icons.keyboard_arrow_up),
        ),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
    });
  });

  group('LogPage filters by recording level', () {
    late Settings settings;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      settings = await Settings.getInstance();
    });

    testWidgets('hides levels the log stops recording', (tester) async {
      final source = FakeLogSource();
      source.add('spam', level: LogLevel.trace);
      source.add('news');
      settings.verboseLogs.value = true;

      await tester.pumpWidget(
        wrap(
          Provider<Settings>.value(
            value: settings,
            child: LogPage(source: source),
          ),
        ),
      );
      expect(find.text('spam'), findsOneWidget);

      settings.verboseLogs.value = false;
      await tester.pumpAndSettle();

      expect(find.text('spam'), findsNothing);
      expect(find.text('news'), findsOneWidget);
    });

    testWidgets('shows them again when recording resumes', (tester) async {
      final source = FakeLogSource();
      source.add('spam', level: LogLevel.trace);
      settings.verboseLogs.value = false;

      await tester.pumpWidget(
        wrap(
          Provider<Settings>.value(
            value: settings,
            child: LogPage(source: source),
          ),
        ),
      );
      expect(find.text('spam'), findsNothing);

      settings.verboseLogs.value = true;
      await tester.pumpAndSettle();

      expect(find.text('spam'), findsOneWidget);
    });
  });
}
