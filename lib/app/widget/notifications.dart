import 'dart:async';
import 'dart:convert';

import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/logs/logs.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sub/flutter_sub.dart';

class NotificationHandler extends StatefulWidget {
  const NotificationHandler({super.key, required this.child});

  final Widget child;

  static NotificationHandlerState of(BuildContext context) =>
      context.findAncestorStateOfType<NotificationHandlerState>()!;

  @override
  State<NotificationHandler> createState() => NotificationHandlerState();
}

class NotificationHandlerState extends State<NotificationHandler> {
  late Future<FlutterLocalNotificationsPlugin> notifications =
      initializeNotifications(onDidReceiveNotificationResponse: handle);
  Logger logger = Logger('NotificationRouter');
  final ValueNotifier<NotificationPayload?> pending = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    pending.dispose();
    super.dispose();
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

    final IdentityClient identities = context.read<IdentityClient>();
    if (identities.identity.id != notification.identity) {
      if (await identities.getOrNull(notification.identity) == null) return;
      await identities.activate(notification.identity);
    }
    if (!mounted) return;
    pending.value = notification;
  }

  void open(NavigatorState navigator, NotificationPayload notification) {
    switch (notification.type) {
      case 'follow':
        navigator.pushNamedAndRemoveUntil('/subscriptions', (_) => false);
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
              builder: (context) => PostLoadingPage(notification.id!),
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
  Widget build(BuildContext context) => widget.child;
}

class NotificationOpener extends StatelessWidget {
  const NotificationOpener({
    super.key,
    required this.child,
    required this.navigatorKey,
  });

  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    final NotificationHandlerState handler = NotificationHandler.of(context);
    final Client client = context.watch<Client>();
    void take() => WidgetsBinding.instance.addPostFrameCallback((_) {
      final NotificationPayload? notification = handler.pending.value;
      final NavigatorState? navigator = navigatorKey.currentState;
      if (notification == null || navigator == null) return;
      if (notification.identity != client.identity.id) return;
      handler.pending.value = null;
      handler.open(navigator, notification);
    });
    return SubListener(
      listenable: handler.pending,
      listener: take,
      builder: (context) {
        take();
        return child;
      },
    );
  }
}
