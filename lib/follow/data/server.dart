import 'dart:async';

import 'package:drift/drift.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class FollowServer with Disposable {
  FollowServer({
    required GeneratedDatabase database,
    required this.identity,
    required this.traits,
    required this.postsClient,
    this.poolsClient,
    this.tagsClient,
  }) : repository = FollowRepository(database: database);

  final FollowRepository repository;
  final Identity identity;
  final ValueNotifier<Traits> traits;
  final PostClient postsClient;
  final PoolClient? poolsClient;
  final TagClient? tagsClient;

  final StreamController<FollowSync?> _syncStream =
      BehaviorSubject<FollowSync?>();

  Stream<FollowSync?> get syncStream => _syncStream.stream;

  FollowSync? get currentSync => _currentSync;
  FollowSync? _currentSync;

  Future<void> sync({bool? force}) async {
    if (_currentSync != null) return;
    final sync = FollowSync(
      repository: repository,
      identity: identity,
      traits: traits,
      postsClient: postsClient,
      poolsClient: poolsClient,
      tagsClient: tagsClient,
      force: force,
    );
    _currentSync = sync;
    _syncStream.add(sync);
    await sync.run();
    _currentSync = null;
    _syncStream.add(null);
  }

  Future<void> syncWith({
    required int id,
    List<Post>? posts,
    Pool? pool,
    bool? seen,
  }) async {
    // The background sync filters denied posts, but this foreground path
    // used to write them straight into the follow preview, leaking
    // blacklisted thumbnails into the subscription list (issue #189).
    List<Post> allowed =
        posts?.where((e) => !e.isDeniedBy(traits.value.denylist)).toList() ??
        <Post>[];
    final latest = allowed.isEmpty
        ? null
        : allowed.reduce((a, b) => a.id > b.id ? a : b);
    await ((repository.update(
      repository.followsTable,
    ))..where((tbl) => tbl.id.equals(id))).write(
      FollowCompanion(
        latest: latest != null ? Value(latest.id) : const Value.absent(),
        thumbnail: latest != null
            ? Value(latest.sample ?? latest.preview)
            : const Value.absent(),
        title: pool != null
            ? Value(tagToName(pool.name))
            : const Value.absent(),
        unseen: seen ?? true ? const Value(0) : const Value.absent(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _currentSync?.cancel();
    _currentSync = null;
    _syncStream.add(_currentSync);
    _syncStream.close();
  }
}
