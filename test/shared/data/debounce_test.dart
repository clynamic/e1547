import 'package:e1547/shared/shared.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Debouncer', () {
    test('runs the last action after the delay', () async {
      final log = <int>[];
      final debouncer = Debouncer(delay: const Duration(milliseconds: 30));
      for (var i = 1; i <= 5; i++) {
        debouncer(() => log.add(i));
        await Future<void>.delayed(const Duration(milliseconds: 5));
      }
      expect(log, isEmpty);
      await Future<void>.delayed(const Duration(milliseconds: 40));
      expect(log, [5]);
      debouncer.dispose();
    });

    test('flush applies a pending action right away', () async {
      var ran = 0;
      final debouncer = Debouncer(delay: const Duration(minutes: 1));
      debouncer(() => ran++);
      expect(ran, 0);
      debouncer.flush();
      expect(ran, 1);
      // A second flush with nothing pending does nothing.
      debouncer.flush();
      expect(ran, 1);
      debouncer.dispose();
    });

    test('dispose drops a pending action', () async {
      var ran = 0;
      final debouncer = Debouncer(delay: const Duration(milliseconds: 10));
      debouncer(() => ran++);
      debouncer.dispose();
      await Future<void>.delayed(const Duration(milliseconds: 30));
      expect(ran, 0);
    });
  });
}
