import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_sub/flutter_sub.dart';

class FollowConnector extends StatelessWidget {
  const FollowConnector({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    return SubEffect(
      effect: () {
        client.followServer.sync();
        return null;
      },
      keys: [client],
      child: SubStream<List<Follow>>(
        create: () => client.follows.all().streamed,
        keys: [client],
        listener: (event) => client.followServer.sync(),
        builder: (context, _) => child,
      ),
    );
  }
}

class FollowSeenConnector extends StatelessWidget {
  const FollowSeenConnector({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    final controller = context.watch<PostParamsController>();
    final query = client.posts.usePage(query: controller.value.toQuery());

    return QueryOnceConnector<
      InfiniteQueryStatus<List<int>, int>,
      FollowSeenRequest
    >(
      query: query,
      getRequest: (context, state) {
        final data = state.data;
        if (data == null || data.pages.isEmpty) return null;
        final params = controller.value;
        final poolId = params.poolId;
        final tags = poolId != null
            ? 'pool:$poolId'
            : params.tags?.nullWhenEmpty;
        if (tags == null) return null;
        final filter = context.read<FilterController<Post>?>();
        final posts = data.pages
            .expand((p) => p)
            .map((id) => client.posts.postCache.get(id))
            .whereType<Post>()
            .where((post) => filter?.filter(post) ?? true)
            .toList();
        return (
          tags: tags,
          posts: posts,
          pool: poolId != null ? client.pools.poolCache.get(poolId) : null,
        );
      },
      onRequest: (context, request) => client.useFollowSeen().mutate(request),
      child: child,
    );
  }
}

class FollowNotificationConnector extends StatefulWidget {
  const FollowNotificationConnector({super.key, required this.child});

  final Widget child;

  @override
  State<FollowNotificationConnector> createState() =>
      _FollowNotificationConnectorState();
}

class _FollowNotificationConnectorState
    extends State<FollowNotificationConnector> {
  List<Follow>? previousFollows;

  Future<void> setupFollowBackground(List<Follow> follows) async {
    if (!PlatformCapabilities.hasNotifications) return;
    final Future<FlutterLocalNotificationsPlugin> notifications =
        NotificationHandler.of(context).notifications;
    final FollowRepository repository = context
        .read<Client>()
        .follows
        .repository;
    bool wasNotifying =
        previousFollows != null &&
        previousFollows!.where((e) => e.type == FollowType.notify).isNotEmpty;
    bool isNotifying = follows
        .where((e) => e.type == FollowType.notify)
        .isNotEmpty;
    if (wasNotifying == isNotifying) return;

    if (isNotifying) {
      bool? result;
      result = await (await notifications)
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      result = await (await notifications)
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
      if (!(result ?? true)) return;
    }
    registerFollowBackgroundTask(repository);
  }

  Future<void> sendNotifications(List<Follow> follows, int identity) async {
    if (!PlatformCapabilities.hasNotifications) return;
    final Future<FlutterLocalNotificationsPlugin> notifications =
        NotificationHandler.of(context).notifications;
    if (previousFollows != null) {
      final BaseCacheManager cache = context.read<BaseCacheManager>();
      await updateFollowNotifications(
        identity: identity,
        previous: previousFollows!,
        updated: follows,
        notifications: await notifications,
        cache: cache,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    return SubStream<List<Follow>>(
      create: () => client.follows
          .all(query: FollowsQuery(types: [FollowType.notify]))
          .streamed,
      keys: [client],
      listener: (event) async {
        await Future.wait([
          setupFollowBackground(event),
          sendNotifications(event, client.identity.id),
        ]);
        previousFollows = event;
      },
      builder: (context, stream) => widget.child,
    );
  }
}
