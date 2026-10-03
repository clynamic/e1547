import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/posts.dart';

void main() {
  late AppDatabase sqlite;
  late Identity identity;
  late FollowRepository repository;
  late ValueNotifier<Traits> traits;
  late FollowServer server;

  setUp(() async {
    sqlite = AppDatabase(NativeDatabase.memory());
    identity = await IdentityRepository(
      sqlite,
    ).add(const IdentityRequest(host: 'e621.net', username: 'tester'));
    repository = FollowRepository(database: sqlite);
    traits = ValueNotifier(
      const Traits(
        id: 1,
        userId: null,
        denylist: ['wolf'],
        homeTags: '',
        avatar: null,
        perPage: null,
      ),
    );
    // syncWith never talks to the network, so a bare client suffices.
    final dio = Dio();
    server = FollowServer(
      database: sqlite,
      identity: identity,
      traits: traits,
      postsClient: PostClient(
        dio: dio,
        pools: PoolClient(dio: dio),
        traits: traits,
        identity: identity,
      ),
    );
  });

  tearDown(() async {
    server.dispose();
    traits.dispose();
    await sqlite.close();
  });

  Future<Follow> seedFollow() async {
    await repository.add(const FollowRequest(tags: 'canine'), identity.id);
    return (await repository.getByTags('canine', identity.id))!;
  }

  group('FollowServer.syncWith', () {
    test('keeps denied posts out of the preview', () async {
      final follow = await seedFollow();

      await server.syncWith(
        id: follow.id,
        posts: [
          samplePost(preview: '/preview/1'),
          samplePost(id: 2, preview: '/preview/2'),
          samplePost(
            id: 3,
            tags: const {
              'species': ['wolf'],
            },
            preview: '/preview/3',
          ),
        ],
      );

      final updated = await repository.get(follow.id);
      expect(updated.latest, 2);
      expect(updated.thumbnail, '/preview/2');
    });

    test('takes the sample of the newest allowed post', () async {
      final follow = await seedFollow();

      await server.syncWith(
        id: follow.id,
        posts: [
          samplePost(id: 2, preview: '/preview/2'),
          samplePost(
            id: 3,
            preview: '/preview/3',
          ).copyWith(sample: '/sample/3'),
          samplePost(
            id: 4,
            tags: const {
              'species': ['wolf'],
            },
            preview: '/preview/4',
          ),
        ],
      );

      final updated = await repository.get(follow.id);
      expect(updated.latest, 3);
      expect(updated.thumbnail, '/sample/3');
    });

    test('keeps the previous preview', () async {
      final follow = await seedFollow();
      await repository.replace(
        follow.copyWith(latest: 1000, thumbnail: '/preview/1000'),
      );

      await server.syncWith(
        id: follow.id,
        posts: [
          samplePost(
            tags: const {
              'species': ['wolf'],
            },
          ),
          samplePost(
            id: 2,
            tags: const {
              'species': ['wolf'],
            },
          ),
        ],
      );

      final updated = await repository.get(follow.id);
      expect(updated.latest, 1000);
      expect(updated.thumbnail, '/preview/1000');
    });

    test('filters no post', () async {
      traits.value = traits.value.copyWith(denylist: []);
      final follow = await seedFollow();

      await server.syncWith(
        id: follow.id,
        posts: [
          samplePost(preview: '/preview/1'),
          samplePost(
            id: 2,
            tags: const {
              'species': ['wolf'],
            },
            preview: '/preview/2',
          ),
        ],
      );

      final updated = await repository.get(follow.id);
      expect(updated.latest, 2);
      expect(updated.thumbnail, '/preview/2');
    });
  });
}
