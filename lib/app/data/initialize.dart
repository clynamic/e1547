import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift_flutter/drift_flutter.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/files/files.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/logs/logs.dart';
import 'package:e1547/query/query.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:notified_preferences/notified_preferences.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

export 'package:e1547/logs/logs.dart' show LogErrors, Logs;
export 'package:e1547/settings/settings.dart' show AppInfo;
export 'package:window_manager/window_manager.dart' show WindowManager;

/// Initializes an AppInfo with default production values.
Future<void> initializeAppInfo() => AppInfo.initializePlatform(
  developer: 'binaryfloof',
  github: 'clragon/e1547',
  discord: 'MRwKGqfmUz',
  website: 'e1547.clynamic.net',
  kofi: 'binaryfloof',
  email: 'support@clynamic.net',
  forumTopicId: 25854,
);

Future<String> getTemporaryAppDirectory() => getTemporaryDirectory().then(
  (dir) => join(dir.path, AppInfo.instance.appName),
);

Future<String> getAppDatabasePath() =>
    getApplicationSupportDirectory().then((dir) => join(dir.path, 'app.db'));

/// Initializes the logger used by the app with default production values.
Future<Logs> initializeLogger({
  String? path,
  String? postfix,
  List<LogPrinter>? printers,
  LogLevel? level,
}) async {
  setLogLevel(level ?? verboseLogLevel(verbose: false));
  path ??= await getTemporaryAppDirectory();

  final logFile = createLogFile(path, postfix);
  final logs = Logs(
    printers: [
      ...?printers,
      JsonLogPrinter(logFile),
      const ConsoleLogPrinter(),
    ],
  );

  logs.connect();

  registerFlutterErrorHandler(
    (error, trace) =>
        Logger('Flutter').error('Uncaught framework error', null, error, trace),
  );
  return logs;
}

LogLevel verboseLogLevel({required bool verbose}) {
  if (verbose) return LogLevel.trace;
  return kDebugMode ? LogLevel.debug : LogLevel.info;
}

File createLogFile(String directoryPath, String? postfix) {
  File logFile = File(
    join(
      directoryPath,
      '${logFileDateFormat.format(DateTime.now())}${postfix != null ? '.$postfix' : ''}$logFileExtension',
    ),
  );

  Directory dir = Directory(directoryPath);
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }
  List<({File file, DateTime date})> logFiles = [];
  for (final entity in dir.listSync().whereType<File>()) {
    if (!entity.path.endsWith(logFileExtension)) continue;
    try {
      logFiles.add((file: entity, date: LogFileInfo.parse(entity.path).date));
    } on FormatException {
      continue;
    }
  }

  logFiles.sort((a, b) => b.date.compareTo(a.date));

  if (logFiles.length > 50) {
    for (final old in logFiles.sublist(10)) {
      try {
        old.file.deleteSync();
      } on FileSystemException {
        continue;
      }
    }
  }

  return logFile;
}

/// Registers an error callback for uncaught exceptions and flutter errors.
void registerFlutterErrorHandler(
  void Function(Object error, StackTrace? trace) handler,
) {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding.instance.platformDispatcher.onError = (error, stack) {
    handler(error, stack);
    return false;
  };
  FlutterError.onError = (details) => handler(details.exception, details.stack);
}

/// Initializes the storages used by the app with default production values.
Future<AppStorage> initializeAppStorage() async {
  final String temporaryFiles = await getTemporaryAppDirectory();
  await completeDbImport();
  final AppDatabase sqlite = AppDatabase(
    driftDatabase(
      name: 'app',
      native: const DriftNativeOptions(
        shareAcrossIsolates: true,
        databasePath: getAppDatabasePath,
      ),
    ),
  );
  await discardLegacyFileCache();
  return AppStorage(
    preferences: await SharedPreferences.getInstance(),
    temporaryFiles: temporaryFiles,
    // TODO: query storage is disabled because a page of writes costs a frame
    queryCache: CachedQuery.asNewInstance()
      ..configFlutter(
        config: const GlobalQueryConfig(
          staleDuration: Duration(minutes: 5),
          refetchOnResume: false,
          refetchOnConnection: false,
        ),
      ),
    sqlite: sqlite,
  );
}

Future<void> backfillOnboardingSeen(AppStorage storage) async {
  if (storage.preferences.getBool('onboardingSeen') ?? false) return;
  final identities = await IdentityRepository(storage.sqlite).all();
  final defaultHost = ClientFactory().createDefaultIdentity().host;
  final existing =
      identities.length > 1 ||
      identities.any((identity) => identity.host != defaultHost);
  if (existing) {
    await storage.preferences.setBool('onboardingSeen', true);
  }
}

class DatabaseImportException implements Exception {
  DatabaseImportException.from(this.inner);

  final Object inner;

  @override
  String toString() => '$runtimeType: $inner';
}

Future<void> stageDbImport(String source, String target) async {
  final File copy = await File(source).copy('$target.tmp');
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final AppDatabase staged = AppDatabase(
    driftDatabase(
      name: 'import',
      native: DriftNativeOptions(databasePath: () async => copy.path),
    ),
  );
  try {
    await staged.customSelect('SELECT 1').get();
  } on Exception catch (e) {
    await staged.close();
    await copy.delete();
    throw DatabaseImportException.from(e);
  } finally {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = false;
  }
  await staged.close();
  await copy.rename(target);
}

Future<void> completeDbImport() async {
  final dbPath = await getAppDatabasePath();
  final newDbPath = '$dbPath.new';
  final newDbFile = File(newDbPath);

  if (newDbFile.existsSync()) {
    final oldDbFile = File(dbPath);
    try {
      if (oldDbFile.existsSync()) {
        await oldDbFile.delete();
      }
      await newDbFile.rename(dbPath);
    } on Exception {
      await newDbFile.copy(dbPath);
      await newDbFile.delete();
    }
  }
}

/// Returns an initialized WindowManager or null the current Platform is unsupported.
Future<WindowManager?> initializeWindowManager() async {
  if ([Platform.isWindows, Platform.isLinux, Platform.isMacOS].any((e) => e)) {
    WindowManager manager = WindowManager.instance;
    await manager.ensureInitialized();
    return manager;
  }
  return null;
}
