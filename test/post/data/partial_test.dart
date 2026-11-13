import 'package:e1547/post/post.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/environment.dart';
import '../../_support/harness.dart';

void main() {
  setUpAll(initializeTestApp);

  late TestEnvironment env;

  setUp(() async => env = await TestEnvironment.start());

  tearDown(() => env.dispose());

  Future<PartialPost> recommendedCopyOf(
    Map<String, Object?> recorded, {
    Map<String, Object?> changes = const {},
  }) async {
    env.fake.state.posts.add({...recorded, ...changes, 'id': 90001});
    final List<PartialPost> posts = await env.client.posts
        .artistRecommendations(id: recorded['id']! as int);
    return posts.firstWhere((e) => e.id == 90001);
  }

  test(
    'posts by the same artist read the files, flags and tags of a post',
    () async {
      final Map<String, Object?> recorded = env.fake.state.posts.first;

      final PartialPost post = await recommendedCopyOf(
        recorded,
        changes: {
          'flags': {...(recorded['flags']! as Map), 'deleted': true},
        },
      );

      final Map files = recorded['files']! as Map;
      expect(post.width, (files['original']! as Map)['width']);
      expect(post.ext, (files['meta']! as Map)['ext']);
      expect(post.isDeleted, isTrue);
      expect(
        post.allTags,
        containsAll((recorded['tags']! as Map).values.first as List),
      );
    },
  );

  test(
    'a post by the same artist is denied by its uploader and file size',
    () async {
      final Map<String, Object?> recorded = env.fake.state.posts.first;
      final String uploader = recorded['uploader_name']! as String;
      final int size =
          ((recorded['files']! as Map)['meta']! as Map)['size']! as int;

      final PartialPost post = await recommendedCopyOf(recorded);

      expect(post.isDeniedBy(['user:$uploader']), isTrue);
      expect(post.isDeniedBy(['filesize:$size']), isTrue);
      expect(post.isDeniedBy(['filesize:..${size - 1}']), isFalse);
    },
  );
}
