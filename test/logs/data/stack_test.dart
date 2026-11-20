import 'package:e1547/logs/logs.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const LogStackCompactor compactor = LogStackCompactor();

  group('LogStackCompactor', () {
    test('keeps our frames and elides framework runs', () {
      final List<String> result = compactor.compact([
        '#0      zero (package:e1547/app/app.dart:1:1)',
        '#1      one (package:flutter/src/widgets/framework.dart:2:1)',
        '#2      two (package:flutter/src/widgets/binding.dart:3:1)',
        '#3      three (package:flutter/src/widgets/binding.dart:4:1)',
        '#4      four (package:flutter/src/foundation/binding.dart:5:1)',
        '#5      ours (package:e1547/post/data/post.dart:6:1)',
        '#6      six (package:flutter/src/foundation/binding.dart:7:1)',
      ]);
      expect(result, [
        'package:e1547/app/app.dart 1:1 in zero',
        'package:flutter/src/widgets/framework.dart 2:1 in one',
        'package:flutter/src/widgets/binding.dart 3:1 in two',
        '<2 frames elided>',
        'package:e1547/post/data/post.dart 6:1 in ours',
        '<1 frames elided>',
      ]);
    });

    test('caps long traces and says how much it dropped', () {
      final List<String> result = compactor.compact([
        for (int i = 0; i < 60; i++) '#$i      f$i (package:e1547/a.dart:$i:1)',
      ]);
      expect(result.length, compactor.limit + 1);
      expect(result.last, '+45 more');
    });

    test('keeps a line it cannot parse as it is', () {
      final List<String> result = compactor.compact([
        'not a stack trace at all',
      ]);
      expect(result, ['not a stack trace at all']);
    });

    test('leaves entries without a trace untouched', () {
      final LogEntry entry = LogEntry(
        time: DateTime(2026),
        level: LogLevel.warn,
        source: 'Test',
        event: 'test.event',
        attributes: const {'post': 5},
        error: const LogError(type: 'StateError', message: 'broken'),
      );
      expect(compactor.apply(entry), entry);
    });
  });
}
