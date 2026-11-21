import 'package:e1547/logs/logs.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoggingDioInterceptor.describeReason', () {
    test('reads the reason of an error response', () {
      expect(
        LoggingDioInterceptor.describeReason({
          'success': false,
          'reason': 'Access denied',
        }),
        'Access denied',
      );
    });

    test('falls back to the message field', () {
      expect(
        LoggingDioInterceptor.describeReason({'message': 'Throttled'}),
        'Throttled',
      );
    });

    test('ignores bodies that are not structured', () {
      expect(LoggingDioInterceptor.describeReason('<html>denied</html>'), null);
      expect(LoggingDioInterceptor.describeReason(null), null);
    });

    test('ignores a response without a reason', () {
      expect(LoggingDioInterceptor.describeReason({'posts': []}), null);
    });

    test('caps a long reason', () {
      final String result = LoggingDioInterceptor.describeReason({
        'reason': 'x' * 500,
      })!;
      expect(result.length, LoggingDioInterceptor.reasonLimit + 1);
      expect(result.endsWith('…'), isTrue);
    });
  });
}
