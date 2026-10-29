import 'package:e1547/shared/shared.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('an age reads in its largest whole unit', () {
    final DateTime now = DateTime(2026, 10, 30, 12);
    for (final (Duration ago, String expected) in [
      (const Duration(seconds: 30), 'now'),
      (const Duration(minutes: 5), '5 min'),
      (const Duration(hours: 3, minutes: 59), '3 h'),
      (const Duration(days: 2, hours: 23), '2 d'),
      (const Duration(days: 13), '1 w'),
      (const Duration(days: 70), '2 mo'),
      (const Duration(days: 800), '2 y'),
    ]) {
      expect(DateFormatting.age(now.subtract(ago), now: now), expected);
    }
  });
}
