import 'package:e1547/logs/logs.dart';
import 'package:flutter_test/flutter_test.dart';

LogEntry entryWith(Map<String, Object?> attributes) => LogEntry(
  time: DateTime(2026),
  level: LogLevel.info,
  source: 'Test',
  event: 'test.event',
  attributes: attributes,
);

void main() {
  const LogRedactor redactor = LogRedactor();

  group('LogRedactor', () {
    test('redacts secret keys and leaves the rest', () {
      final LogEntry result = redactor.apply(
        entryWith({'authorization': 'Basic abc', 'user': 'tester'}),
      );
      expect(result.attributes['authorization'], '[redacted]');
      expect(result.attributes['user'], 'tester');
    });

    test('matches keys regardless of case and separators', () {
      for (final String key in [
        'api_key',
        'apiKey',
        'API-KEY',
        'refresh_token',
        'Set-Cookie',
      ]) {
        expect(redactor.isSecret(key), isTrue, reason: key);
      }
      expect(redactor.isSecret('username'), isFalse);
      expect(redactor.isSecret('tags'), isFalse);
    });

    test('redacts keys in nested maps', () {
      final LogEntry result = redactor.apply(
        entryWith({
          'headers': {'Cookie': 'session=1', 'Accept': 'json'},
        }),
      );
      final Map<Object?, Object?> headers =
          result.attributes['headers']! as Map<Object?, Object?>;
      expect(headers['Cookie'], '[redacted]');
      expect(headers['Accept'], 'json');
    });

    test('scrubs credentials out of urls', () {
      final LogEntry result = redactor.apply(
        entryWith({
          'url':
              'https://e621.net/posts.json?login=tester&api_key=hunter2&tags=cat',
        }),
      );
      final String url = result.attributes['url']! as String;
      expect(url, contains('tags=cat'));
      expect(url, isNot(contains('hunter2')));
      expect(url, isNot(contains('tester')));
    });

    test('scrubs credentials out of relative paths', () {
      final LogEntry result = redactor.apply(
        entryWith({'path': '/posts.json?login=tester&api_key=hunter2&page=1'}),
      );
      final String path = result.attributes['path']! as String;
      expect(path, contains('page=1'));
      expect(path, isNot(contains('hunter2')));
    });

    test('keeps repeated query keys', () {
      final LogEntry result = redactor.apply(
        entryWith({'path': '/posts.json?tags=a&tags=b&api_key=hunter2'}),
      );
      final String path = result.attributes['path']! as String;
      expect(path, contains('tags=a'));
      expect(path, contains('tags=b'));
      expect(path, isNot(contains('hunter2')));
    });

    test('scrubs the error message', () {
      final LogEntry result = redactor.apply(
        LogEntry(
          time: DateTime(2026),
          level: LogLevel.error,
          source: 'Test',
          event: 'test.event',
          error: const LogError(
            type: 'StateError',
            message: 'failed on https://e621.net/x.json?api_key=hunter2',
          ),
        ),
      );
      expect(result.error!.message, isNot(contains('hunter2')));
      expect(result.error!.type, 'StateError');
    });

    test('stringifies values that are not plain data', () {
      final LogEntry result = redactor.apply(
        entryWith({'thing': Uri.parse('https://e621.net/x.json?login=tester')}),
      );
      expect(result.attributes['thing'], isA<String>());
      expect('${result.attributes['thing']}', isNot(contains('tester')));
    });

    test('leaves numbers and booleans as they are', () {
      final LogEntry result = redactor.apply(
        entryWith({'count': 3, 'ok': true, 'nothing': null}),
      );
      expect(result.attributes['count'], 3);
      expect(result.attributes['ok'], true);
      expect(result.attributes['nothing'], isNull);
    });

    test('leaves strings that are not urls alone', () {
      final LogEntry result = redactor.apply(
        entryWith({'note': 'no url here'}),
      );
      expect(result.attributes['note'], 'no url here');
    });
  });
}
