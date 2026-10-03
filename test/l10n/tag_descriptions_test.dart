import 'package:e1547/l10n/tag_descriptions_zh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('describes common tags for chinese users', () {
    expect(
      localizedTagDescription('canid', const Locale('zh')),
      contains('犬科'),
    );
    expect(
      localizedTagDescription('gynomorph', const Locale('zh')),
      isNotEmpty,
    );
  });

  test('serves both chinese scripts from the simplified list', () {
    final simplified = localizedTagDescription(
      'wolf',
      const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    );
    final traditional = localizedTagDescription(
      'wolf',
      const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
    );
    expect(simplified, isNotNull);
    expect(traditional, simplified);
  });

  test('returns nothing for non-chinese users', () {
    expect(localizedTagDescription('canid', const Locale('en')), isNull);
    expect(localizedTagDescription('canid', const Locale('ja')), isNull);
  });

  test('returns nothing for unknown tags', () {
    expect(
      localizedTagDescription(
        'definitely_not_a_curated_tag',
        const Locale('zh'),
      ),
      isNull,
    );
  });

  test('the dictionary uses concise clinical wording', () {
    for (final entry in tagDescriptionsZh.entries) {
      expect(entry.key, isNotEmpty);
      // curated descriptions stay short; wikis can be pages long
      expect(entry.value.length, lessThan(60));
      // every entry ends with a full stop, like the site's short summaries
      expect(
        entry.value.endsWith('。'),
        isTrue,
        reason: '${entry.key} misses its full stop',
      );
    }
  });
}
