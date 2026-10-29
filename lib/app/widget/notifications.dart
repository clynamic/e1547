import 'dart:async';
import 'dart:convert';

import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/logs/logs.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_sub/flutter_sub.dart';

class NotificationHandler extends StatefulWidget {
  const NotificationHandler({super.key, required this.child});

  final Widget child;

  @override
  State<NotificationHandler> createState() => _NotificationHandlerState();
}

class _NotificationHandlerState extends State<NotificationHandler> {
  late Future<FlutterLocalNotificationsPlugin> notifications =
      initializeNotifications(onDidReceiveNotificationResponse: handle);
  List<Follow>? previousFollows;
  Logger logger = Logger('NotificationRouter');

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    if (!PlatformCapabilities.hasNotifications) return;
    NotificationAppLaunchDetails? details = await (await notifications)
        .getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      NotificationResponse? response = details.notificationResponse;
      if (response != null) {
        handle(response);
      }
    }
  }

  Future<void> setupFollowBackground(List<Follow> follows) async {
    if (!PlatformCapabilities.hasNotifications) return;
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
    registerFollowBackgroundTask(follows);
  }

  Future<void> sendNotifications(List<Follow> follows, int identity) async {
    if (!PlatformCapabilities.hasNotifications) return;
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

  Future<void> handle(NotificationResponse response) async {
    if (!context.mounted) return;
    String? payload = response.payload;
    if (payload == null) return;
    NotificationPayload? notification;
    try {
      notification = NotificationPayload.fromJson(json.decode(payload));
    } on FormatException catch (e, s) {
      logger.error('Failed to parse notification payload', null, e, s);
      return;
    }

    switch (notification.type) {
      case 'follow':
        final NavigatorState? navigator = await context
            .read<ShellController>()
            .reset(ShellTab.library);
        if (navigator == null || !navigator.mounted) return;
        navigator.push(
          MaterialPageRoute(
            builder: (context) => const FollowsSubscriptionsPage(),
          ),
        );
        if (notification.query != null) {
          final String? tags = notification.query!['tags'];
          final poolId = tags != null
              ? poolRegex().firstMatch(tags)?.namedGroup('id')
              : null;
          navigator.push(
            MaterialPageRoute(
              builder: (context) => poolId != null
                  ? PoolLoadingPage(int.parse(poolId), orderByOldest: false)
                  : PostsPage(params: PostParams(tags: tags)),
            ),
          );
        }
        if (notification.id != null) {
          navigator.push(
            MaterialPageRoute(
              builder: (context) => PostLoadingPage(notification!.id!),
            ),
          );
        }
        break;
      default:
        logger.warn('Unknown notification type {type}', {
          'type': notification.type,
        });
        return;
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
