import 'dart:io';

import 'package:cached_query/cached_query.dart';
import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/logs/logs.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
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

Widget wrap(Widget child) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: child,
);

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
    testWidgets('holds the read position while entries arrive', (tester) async {
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

    testWidgets('shows what waited once scrolled back', (tester) async {
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
  testWidgets('selecting a log file keeps the logs page', (tester) async {
    final sqlite = AppDatabase(NativeDatabase.memory());
    addTearDown(sqlite.close);
    SharedPreferences.setMockInitialValues({});
    // Reading and listing log files is real IO, which the fake clock of a
    // widget test cannot wait for on its own.
    late final AppStorage storage;
    late final Settings settings;
    await tester.runAsync(() async {
      final temp = await Directory.systemTemp.createTemp('e1547-logs');
      // The list only offers its live entry once a log file exists, and a
      // file only parses with a full timestamp in its name.
      await File(
        '${temp.path}/2026-10-01-12-00-00-000.jsonl',
      ).writeAsString('');
      final preferences = await SharedPreferences.getInstance();
      storage = AppStorage(
        preferences: preferences,
        temporaryFiles: temp.path,
        queryCache: CachedQuery.asNewInstance(),
        sqlite: sqlite,
      );
      settings = Settings(preferences);
    });

    // The logger's deduplicator runs a timer of its own, which outlives
    // the tree and has to be closed by hand.
    final logs = Logs();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<Logs>.value(value: logs),
          Provider<AppStorage>.value(value: storage),
          Provider<Settings>.value(value: settings),
        ],
        child: const MaterialApp(
          locale: Locale('zh'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: LogsPage(),
        ),
      ),
    );
    await tester.pump();

    // The app bar's folder button opens the list of log files.
    await tester.tap(find.byIcon(Icons.folder));
    await tester.pump();
    // Listing the directory is real IO, which only lands in real time,
    // so both clocks take turns until the files have been read.
    for (var i = 0; i < 10; i++) {
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      });
      await tester.pump(const Duration(milliseconds: 100));
      if (find.text('实时').evaluate().isNotEmpty) break;
    }

    expect(find.byType(LogFileList), findsOneWidget);

    // Picking the live entry closes the list, and only the list.
    await tester.tap(find.text('实时'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(find.byType(LogFileList), findsNothing);
    expect(find.byType(LogsPage), findsOneWidget);

    // The log sources keep timers while they run, which the tree has to
    // dispose of before the test can end. The logger's own deduplicator
    // timer has to be closed even before that, with the tree already gone.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
    logs.deduplicator.close();
  });
}
