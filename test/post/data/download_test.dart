import 'package:e1547/post/post.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/posts.dart';

void main() {
  test('names a download after its artists and id', () {
    expect(
      samplePost(
        id: 7,
        tags: {
          'artist': ['tester', 'conditional_dnp', 'helper'],
        },
      ).downloadFileName,
      'tester, helper - 7.${samplePost().ext}',
    );
    expect(samplePost(id: 7).downloadFileName, '7.${samplePost().ext}');
  });

  test('leaves out artists who do not fit a file name', () {
    expect(
      samplePost(
        id: 7,
        tags: {
          'artist': [
            for (int i = 0; i < 20; i++) 'tester_$i'.padRight(12, 'x'),
          ],
        },
      ).downloadFileName,
      '7.${samplePost().ext}',
    );
  });
}
