import 'package:e1547/logs/logs.dart';
import 'package:flutter_test/flutter_test.dart';

LogEntry at(
  int second, {
  LogLevel level = LogLevel.info,
  String event = 'test.event',
}) => LogEntry(
  time: DateTime(2026, 1, 1, 0, 0, second),
  level: level,
  source: 'Test',
  event: event,
);

void main() {
  late List<LogEntry> emitted;
  late LogDeduplicator dedupe;

  setUp(() {
    emitted = [];
    dedupe = LogDeduplicator(
      window: const Duration(seconds: 5),
      threshold: 2,
      errorThreshold: 5,
    )..attach(emitted.add);
  });

  tearDown(() => dedupe.close());

  group('LogDeduplicator', () {
    test('passes the first few of a kind through', () {
      for (int i = 0; i < 2; i++) {
        dedupe.add(at(i));
      }
      expect(emitted.length, 2);
    });

    test('suppresses everything past the threshold', () {
      for (int i = 0; i < 9; i++) {
        dedupe.add(at(0));
      }
      expect(emitted.length, 2);
    });

    test('reports the suppressed count when the window closes', () {
      for (int i = 0; i < 9; i++) {
        dedupe.add(at(0));
      }
      dedupe.flush(DateTime(2026, 1, 1, 0, 0, 20));

      expect(emitted.length, 3);
      final LogEntry summary = emitted.last;
      expect(summary.event, LogDeduplicator.suppressedEvent);
      expect(summary.attributes['event'], 'test.event');
      expect(summary.attributes['count'], 7);
    });

    test('never rewrites an entry it already emitted', () {
      for (int i = 0; i < 9; i++) {
        dedupe.add(at(0));
      }
      final List<LogEntry> before = emitted.take(2).toList();
      dedupe.flush(DateTime(2026, 1, 1, 0, 0, 20));
      expect(emitted.take(2).toList(), before);
    });

    test('keeps the summary at the level it is summarising', () {
      for (int i = 0; i < 9; i++) {
        dedupe.add(at(0, level: LogLevel.warn));
      }
      dedupe.flush(DateTime(2026, 1, 1, 0, 0, 20));
      expect(emitted.last.level, LogLevel.warn);
    });

    test('gives errors a looser threshold', () {
      for (int i = 0; i < 9; i++) {
        dedupe.add(at(0, level: LogLevel.error));
      }
      expect(emitted.length, 5);
    });

    test('treats unlike attributes as unlike events', () {
      for (int i = 0; i < 9; i++) {
        dedupe.add(
          LogEntry(
            time: DateTime(2026),
            level: LogLevel.debug,
            source: 'Dio',
            event: 'http.response',
            attributes: {'request_id': 'r$i'},
          ),
        );
      }
      expect(emitted.length, 9);
    });

    test('counts unlike events separately', () {
      for (int i = 0; i < 9; i++) {
        dedupe.add(at(0, event: 'a'));
        dedupe.add(at(0, event: 'b'));
      }
      expect(emitted.where((e) => e.event == 'a').length, 2);
      expect(emitted.where((e) => e.event == 'b').length, 2);
    });

    test('flushes pending counts on close', () {
      for (int i = 0; i < 9; i++) {
        dedupe.add(at(0));
      }
      dedupe.close();

      expect(emitted.last.event, LogDeduplicator.suppressedEvent);
      expect(emitted.last.attributes['count'], 7);
    });

    test('opens a fresh window once the old one ends', () {
      for (int i = 0; i < 9; i++) {
        dedupe.add(at(0));
      }
      dedupe.add(at(30));

      expect(emitted.length, 4);
      expect(emitted[2].event, LogDeduplicator.suppressedEvent);
      expect(emitted[3].event, 'test.event');
    });

    test('reports nothing when nothing was suppressed', () {
      dedupe.add(at(0));
      dedupe.flush(DateTime(2026, 1, 1, 0, 0, 20));
      expect(emitted.length, 1);
    });
  });
}
