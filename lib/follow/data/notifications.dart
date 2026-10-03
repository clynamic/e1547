import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/files/files.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/logs/logs.dart';
import 'package:e1547/settings/data/language.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

const String followsBackgroundTaskKey = 'net.clynamic.e1547.follows';

Future<void> runFollowUpdates({
  required AppStorage storage,
  required FlutterLocalNotificationsPlugin notifications,
  CancelToken? cancelToken,
}) async {
  // this ensures continued scheduling on iOS.
  FollowRepository allFollows = FollowRepository(database: storage.sqlite);
  registerFollowBackgroundTask(
    await allFollows.all(types: [FollowType.notify]),
  );

  List<Identity> identities = await IdentityClient(
    database: storage.sqlite,
  ).all();

  final clientFactory = ClientFactory();

  for (final identity in identities) {
    TraitsClient traits = TraitsClient(database: storage.sqlite);
    await traits.activate(identity.id);

    final client = clientFactory.create(
      ClientConfig(
        identity: identity,
        traits: traits.notifier,
        storage: storage,
      ),
    );

    await runClientFollowUpdate(
      client: client,
      database: storage.sqlite,
      notifications: notifications,
      cancelToken: cancelToken,
    );
  }

  registerFollowBackgroundTask(
    await allFollows.all(types: [FollowType.notify]),
  );
}

Future<void> runClientFollowUpdate({
  required Client client,
  required GeneratedDatabase database,
  required FlutterLocalNotificationsPlugin notifications,
  CancelToken? cancelToken,
}) async {
  List<Follow> previous = await client.follows.all(
    query: FollowsQuery(types: [FollowType.notify]),
  );

  cancelToken?.whenCancel.then(
    (_) => client.followServer.currentSync?.cancel(),
  );

  await client.followServer.sync();

  List<Follow> updated = await client.follows.all(
    query: FollowsQuery(types: [FollowType.notify]),
  );

  final BaseCacheManager cache = createFileCache(
    dio: client.dio,
    database: database,
  );

  try {
    await updateFollowNotifications(
      identity: client.identity.id,
      previous: previous,
      updated: updated,
      notifications: notifications,
      cache: cache,
    );
  } finally {
    await cache.dispose();
  }
}

Future<void> updateFollowNotifications({
  required int identity,
  required List<Follow> previous,
  required List<Follow> updated,
  required FlutterLocalNotificationsPlugin notifications,
  required BaseCacheManager cache,
}) async {
  final Logger logger = Logger('FollowNotifications', {'identity': identity});

  Map<Follow, int> updates = {};
  List<Follow> seen = [];

  for (final update in updated) {
    Follow? old = previous.firstWhereOrNull((e) => e.tags == update.tags);
    if (old == null) continue;
    int previousUnseen = old.unseen ?? 0;
    int nextUnseen = update.unseen ?? 0;
    if (previousUnseen < nextUnseen) {
      updates[update] = nextUnseen - previousUnseen;
    } else if (previousUnseen > 0 && nextUnseen <= 0) {
      seen.add(update);
    }
  }

  // Loads localizations from the stored language preference; this runs
  // without a BuildContext, since it may run in a background isolate.
  //
  // This is also what keeps the notification channel's name and description
  // localized: Android only allows changing a channel's name and description
  // after creation, so re-registering it renames the channel for existing
  // users after they change the app language.
  final AppLocalizations localizations = await loadPreferenceLocalizations();

  if (Platform.isAndroid) {
    await notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          AndroidNotificationChannel(
            'follows',
            localizations.followChannelName,
            description: localizations.followChannelDescription,
          ),
        );
  }

  for (final MapEntry(key: follow, value: unseen) in updates.entries) {
    String? thumbnail = follow.thumbnail;
    String? picture;
    if (thumbnail != null) {
      try {
        picture = (await cache.getSingleFile(thumbnail)).path;
      } on Exception catch (e, s) {
        logger.warn(
          'Failed to load thumbnail for {tags}',
          {'tags': follow.tags},
          e,
          s,
        );
      }
    }

    logger.debug('{tags} has {unseen} new posts', {
      'tags': follow.tags,
      'unseen': unseen,
    });

    NotificationDetails notificationDetails = _createNotificationDetails(
      thumbnailPath: picture,
      localizations: localizations,
    );

    String title = follow.name;
    String description = localizations.followNotificationBody(unseen);

    await notifications.show(
      id: follow.id,
      title: title,
      body: description,
      notificationDetails: notificationDetails,
      payload: json.encode(
        NotificationPayload(
          identity: identity,
          type: 'follow',
          query: {'tags': follow.tags},
          id: unseen == 1 ? follow.latest : null,
        ),
      ),
    );

    if (Platform.isAndroid) {
      List<ActiveNotification> active = await notifications
          .getActiveNotifications();

      List<ActiveNotification> grouped = active
          .where((e) => e.groupKey == followsBackgroundTaskKey)
          .toList();

      if (grouped.length > 3) {
        NotificationDetails notificationDetails = _createNotificationDetails(
          summary: true,
          localizations: localizations,
        );
        await notifications.show(
          id: followsBackgroundTaskKey.hashCode,
          title: localizations.followNotificationSummary,
          notificationDetails: notificationDetails,
          payload: json.encode(
            NotificationPayload(identity: identity, type: 'follow'),
          ),
        );
      } else {
        notifications.cancel(id: followsBackgroundTaskKey.hashCode);
      }
    }

    logger.info('Notified: {title} {body}', {
      'title': title,
      'body': description,
    });
  }

  for (final follow in seen) {
    notifications.cancel(id: follow.id);
  }
}

NotificationDetails _createNotificationDetails({
  String? thumbnailPath,
  bool? summary,
  required AppLocalizations localizations,
}) {
  return NotificationDetails(
    android: AndroidNotificationDetails(
      'follows',
      localizations.followChannelName,
      channelDescription: localizations.followChannelDescription,
      largeIcon: thumbnailPath != null
          ? FilePathAndroidBitmap(thumbnailPath)
          : null,
      styleInformation: thumbnailPath != null
          ? BigPictureStyleInformation(
              FilePathAndroidBitmap(thumbnailPath),
              hideExpandedLargeIcon: true,
            )
          : null,
      groupKey: followsBackgroundTaskKey,
      setAsGroupSummary: summary ?? false,
    ),
    iOS: DarwinNotificationDetails(
      threadIdentifier: followsBackgroundTaskKey,
      attachments: [
        if (thumbnailPath != null) DarwinNotificationAttachment(thumbnailPath),
      ],
    ),
  );
}
