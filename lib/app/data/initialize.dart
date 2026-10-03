import 'dart:io';

import 'package:drift_flutter/drift_flutter.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/files/files.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/logs/logs.dart';
import 'package:e1547/query/query.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
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
          // Leaving refetchOnConnection at its default (true), so queries
          // with active listeners refetch when the network returns.
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

/// Reads `PRAGMA user_version` (header offset 60, big endian) without
/// opening the database. Returns null if [path] is not a SQLite file.
Future<int?> readSqliteUserVersion(String path) async {
  final file = File(path);
  if (!file.existsSync()) return null;
  final handle = await file.open();
  try {
    final header = await handle.read(64);
    if (header.length < 64) return null;
    if (String.fromCharCodes(header.take(15)) != 'SQLite format 3') return null;
    // getUint32 reads big endian by default, which is the SQLite format.
    return ByteData.sublistView(header, 60, 64).getUint32(0);
  } finally {
    await handle.close();
  }
}

const MethodChannel _storageChannel = MethodChannel('e1547/storage');

Future<void> excludeFileFromBackup(String path) async {
  if (!Platform.isIOS) return;
  try {
    await _storageChannel.invokeMethod('excludeFromBackup', {'path': path});
  } on PlatformException catch (e, s) {
    Logger(
      'Storage',
    ).warn('Failed to exclude file from backup', {'path': path}, e, s);
  } on MissingPluginException {
    // platform without the handler; nothing to do
  }
}

/// Excludes the database and its sidecar/staging files from OS backups.
Future<void> excludeDatabaseFromBackup() async {
  final dbPath = await getAppDatabasePath();
  for (final suffix in ['', '-journal', '-wal', '-shm', '.new']) {
    final file = File('$dbPath$suffix');
    if (file.existsSync()) await excludeFileFromBackup(file.path);
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
