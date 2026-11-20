import 'dart:convert';
import 'dart:io';

import 'package:e1547/logs/logs.dart';
import 'package:flutter_test/flutter_test.dart';

String lineFor(int index) => jsonEncode(
  LogEntry(
    time: DateTime(2026, 1, 1, 0, 0, index),
    level: LogLevel.info,
    source: 'Test',
    event: 'entry {n}',
    attributes: {'n': index},
  ).toJson(),
);

void main() {
  late Directory dir;
  late File file;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('logs');
    file = File('${dir.path}/test$logFileExtension');
  });

  tearDown(() => dir.delete(recursive: true));

  Future<void> write(int count) => file.writeAsString(
    [for (int i = 0; i < count; i++) '${lineFor(i)}\n'].join(),
  );

  int nOf(LogEntry entry) => entry.attributes['n']! as int;

  group('LogFileSource', () {
    test('reads only the tail of a file that exceeds a page', () async {
      await write(400);
      final source = LogFileSource(file, pageBytes: 2048);
      await source.load();

      expect(source.entries, isNotEmpty);
      expect(source.entries.length, lessThan(400));
      expect(source.hasEarlier, isTrue);
      expect(nOf(source.entries.last), 399);
      source.dispose();
    });

    test('prepends earlier pages in order until the file starts', () async {
      await write(400);
      final source = LogFileSource(file, pageBytes: 2048);
      await source.load();

      while (source.hasEarlier) {
        await source.loadEarlier();
      }

      expect(source.entries.length, 400);
      expect([
        for (final entry in source.entries) nOf(entry),
      ], List.generate(400, (i) => i));
      source.dispose();
    });

    test('never loads a whole small file twice', () async {
      await write(5);
      final source = LogFileSource(file, pageBytes: 2048);
      await source.load();

      expect(source.hasEarlier, isFalse);
      expect(source.entries.length, 5);
      source.dispose();
    });

    test('identifies each entry by its byte offset', () async {
      await write(400);
      final source = LogFileSource(file, pageBytes: 2048);
      await source.load();

      final List<int> offsets = [0];
      for (int i = 0; i < 400; i++) {
        offsets.add(offsets.last + utf8.encode(lineFor(i)).length + 1);
      }
      expect(source.hasEarlier, isTrue);
      expect(source.entries.map((entry) => entry.id), [
        for (final entry in source.entries) offsets[nOf(entry)],
      ]);
      source.dispose();
    });

    test('leaves a half written trailing line alone', () async {
      await write(10);
      await file.writeAsString('{"v":1,"t":"2026', mode: FileMode.append);
      final source = LogFileSource(file, pageBytes: 2048);
      await source.load();

      expect(source.entries.length, 10);
      expect(nOf(source.entries.last), 9);
      source.dispose();
    });

    test('reports loading until the first page is read', () async {
      await write(5);
      final source = LogFileSource(file, pageBytes: 2048);
      expect(source.loading, isTrue);

      final Future<void> loading = source.load();
      expect(source.loading, isTrue);

      await loading;
      expect(source.loading, isFalse);
      source.dispose();
    });

    test('stops loading even when the file is missing', () async {
      final source = LogFileSource(
        File('${dir.path}/missing$logFileExtension'),
      );
      await source.load();

      expect(source.loading, isFalse);
      expect(source.entries, isEmpty);
      source.dispose();
    });

    test('skips lines it cannot parse', () async {
      await write(3);
      await file.writeAsString('not json at all\n', mode: FileMode.append);
      final source = LogFileSource(file, pageBytes: 2048);
      await source.load();

      expect(source.entries.length, 3);
      source.dispose();
    });
  });
}
