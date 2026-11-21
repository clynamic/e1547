import 'dart:async';
import 'dart:io';

import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/logs/logs.dart';
import 'package:workmanager/workmanager.dart';

export 'package:flutter_local_notifications/flutter_local_notifications.dart';

final Logger _logger = Logger('BackgroundTasks');

/// Registers background tasks for the app.
Future<void> initializeBackgroundTasks() async {
  if (!PlatformCapabilities.hasBackgroundWorker) return;
  await Workmanager().initialize(executeBackgroundTasks);
  _logger.debug('Background worker initialized');
}

CancelToken createBackgroundCancelToken(String task) {
  final cancelToken = CancelToken();

  Timer(
    // Android forces a 10 minute timeout on background tasks.
    // We generally don't want to run for that long, so we'll
    // cancel any task that runs for more than 9 minutes.
    // This gives us enough time to shut down gracefully.
    const Duration(minutes: 9),
    () => cancelToken.cancel('Took too long to complete'),
  );

  return cancelToken;
}

Future<void> registerFollowBackgroundTask(FollowRepository follows) async {
  if (!PlatformCapabilities.hasBackgroundWorker) return;
  if ((await follows.all(types: [FollowType.notify])).isEmpty) {
    _logger.debug('Unregistered {task}', {'task': followsBackgroundTaskKey});
    return Workmanager().cancelByUniqueName(followsBackgroundTaskKey);
  }
  if (Platform.isIOS) {
    _logger.debug('Registered {schedule} {task} on {platform}', {
      'task': followsBackgroundTaskKey,
      'platform': 'ios',
      'schedule': 'one_off',
    });
    Workmanager().registerProcessingTask(
      followsBackgroundTaskKey,
      followsBackgroundTaskKey,
      initialDelay: const Duration(hours: 1),
      constraints: Constraints(networkType: NetworkType.connected),
    );
  } else if (Platform.isAndroid) {
    _logger.debug('Registered {schedule} {task} on {platform}', {
      'task': followsBackgroundTaskKey,
      'platform': 'android',
      'schedule': 'periodic',
    });
    await Workmanager().registerPeriodicTask(
      followsBackgroundTaskKey,
      followsBackgroundTaskKey,
      initialDelay: const Duration(hours: 1),
      frequency: const Duration(hours: 1),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }
}

Future<FlutterLocalNotificationsPlugin> initializeNotifications({
  DidReceiveNotificationResponseCallback? onDidReceiveNotificationResponse,
  DidReceiveBackgroundNotificationResponseCallback?
  onDidReceiveBackgroundNotificationResponse,
}) async {
  FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();
  await notifications.initialize(
    settings: const InitializationSettings(
      android: AndroidInitializationSettings('splash'),
      iOS: DarwinInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
      ),
    ),
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    onDidReceiveBackgroundNotificationResponse:
        onDidReceiveBackgroundNotificationResponse,
  );
  return notifications;
}
