import 'dart:io';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift_flutter/drift_flutter.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/app/widget/initialize.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/logs/logs.dart';
import 'package:e1547/shared/shared.dart';
import 'package:file_picker/file_picker.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sub/flutter_sub.dart';
import 'package:path/path.dart';

typedef DatabaseInfo = ({String name, String? size});

final _logger = Logger('DbManagement');

/// The schema version this build understands.
///
/// Files from newer versions are rejected by the import. Keep in sync with
/// AppDatabase.schemaVersion; test/app/data/initialize_test.dart guards it.
const int supportedSchemaVersion = 9;

/// The tables a complete app database must have.
const Set<String> appTables = {
  'identities_table',
  'traits_table',
  'histories_table',
  'histories_identities_table',
  'follows_table',
  'follows_identities_table',
  'tasks_table',
  'tasks_identities_table',
  'query_storage_table',
  'file_cache_table',
};

/// The hosts identities are expected to live on.
///
/// Accounts on any other host are called out during imports: a crafted
/// database could otherwise quietly point the app, and its login form,
/// at a server the user never chose.
const Set<String> defaultHosts = {'https://e621.net', 'https://e926.net'};

class DatabaseManagementPage extends StatelessWidget {
  const DatabaseManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TransparentAppBar(
        child: DefaultAppBar(leading: CloseButton()),
      ),
      body: LimitedWidthLayout.builder(
        builder: (context) => ListView(
          padding: defaultActionListPadding.add(
            LimitedWidthLayout.of(context).padding,
          ),
          children: const [
            DatabaseInfoDisplay(),
            SizedBox(height: 64),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Card(
                child: Column(
                  children: [DatabaseExportTile(), DatabaseImportTile()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DatabaseInfoDisplay extends StatelessWidget {
  const DatabaseInfoDisplay({super.key});

  Future<DatabaseInfo> _loadDatabaseInfo() async {
    final dbPath = await getAppDatabasePath();
    final dbFile = File(dbPath);

    final name = dbPath.split(Platform.pathSeparator).last;
    final size = dbFile.existsSync() ? filesize(dbFile.lengthSync()) : null;

    return (name: name, size: size);
  }

  @override
  Widget build(BuildContext context) {
    return SubFuture<DatabaseInfo>(
      create: _loadDatabaseInfo,
      builder: (context, snapshot) {
        final dbInfo =
            snapshot.data ??
            (snapshot.error != null
                ? (
                    name: AppLocalizations.of(context).databaseErrorLoading,
                    size: 'N/A',
                  )
                : (name: AppLocalizations.of(context).loading, size: '...'));

        return Center(
          child: Column(
            children: [
              const SizedBox(height: 32),
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.surface,
                foregroundColor: Theme.of(context).colorScheme.primary,
                radius: 64,
                child: const Icon(Icons.storage, size: 64),
              ),
              const SizedBox(height: 16),
              Text(dbInfo.name, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Dimmed(
                child: Text(
                  dbInfo.size ??
                      AppLocalizations.of(context).databaseUnknownSize,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}

class DatabaseExportTile extends StatelessWidget {
  const DatabaseExportTile({super.key});

  Future<bool> _showExportWarning(BuildContext context) => showDialog<bool>(
    context: context,
    builder: (context) => Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: AlertDialog(
          title: Text(AppLocalizations.of(context).databaseExportTitle),
          content: Text(
            AppLocalizations.of(context).databaseExportSanitizedBody,
          ),
          actions: [
            TextButton(
              onPressed: () => popDialog(context, false),
              child: Text(AppLocalizations.of(context).actionCancel),
            ),
            TextButton(
              onPressed: () => popDialog(context, true),
              child: Text(AppLocalizations.of(context).actionExport),
            ),
          ],
        ),
      ),
    ),
  ).then((value) => value ?? false);

  Future<void> _exportDatabase(BuildContext context) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    final sqlite = context.read<AppStorage>().sqlite;

    if (!await _showExportWarning(context)) return;
    if (!context.mounted) return;

    File? tempFile;
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(4),
                child: SizedBox(
                  height: 28,
                  width: 28,
                  child: CircularProgressIndicator(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(l10n.databaseExporting),
              ),
            ],
          ),
        ),
      );

      final dbPath = await getAppDatabasePath();
      final dbFile = File(dbPath);
      if (!dbFile.existsSync()) {
        throw Exception('Database file does not exist');
      }

      final tempPath = join(
        await getTemporaryAppDirectory(),
        'e1547_export.db',
      );
      await Directory(dirname(tempPath)).create(recursive: true);
      tempFile = File(tempPath);
      if (tempFile.existsSync()) await tempFile.delete();

      // A consistent, compact snapshot through the live connection.
      try {
        await sqlite.customStatement('VACUUM INTO ?', [tempPath]);
      } on Exception {
        // Not worse than what a plain file copy would produce.
        await dbFile.copy(tempPath);
      }

      driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
      try {
        final sanitizeDb = AppDatabase(
          driftDatabase(
            name: 'export-sanitize',
            native: DriftNativeOptions(databasePath: () async => tempPath),
          ),
        );
        try {
          await IdentityRepository(sanitizeDb).removeCredentials();
          // Rebuild so removed credentials cannot be recovered
          // from free pages left behind by the UPDATE.
          await sanitizeDb.customStatement('VACUUM');
        } finally {
          await sanitizeDb.close();
        }
      } finally {
        driftRuntimeOptions.dontWarnAboutMultipleDatabases = false;
      }

      final bytes = await tempFile.readAsBytes();
      await tempFile.delete();
      tempFile = null;

      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: l10n.databaseExportTitle,
        fileName: 'e1547_database_backup.db',
        type: FileType.custom,
        allowedExtensions: ['db'],
        bytes: bytes,
      );

      navigator.pop();
      if (outputFile != null) {
        messenger.showSnackBar(SnackBar(content: Text(l10n.databaseExported)));
      }
    } on Exception catch (e) {
      navigator.pop();
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.databaseExportFailed)),
      );
      _logger.warn('Database export failed', null, e);
    } finally {
      if (tempFile != null && tempFile.existsSync()) {
        try {
          await tempFile.delete();
        } on FileSystemException {
          // already deleted elsewhere
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.file_download),
      title: Text(AppLocalizations.of(context).databaseExport),
      subtitle: Text(
        AppLocalizations.of(context).databaseExportSubtitle,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () => _exportDatabase(context),
    );
  }
}

class DatabaseImportTile extends StatelessWidget {
  const DatabaseImportTile({super.key});

  Future<void> _importDatabase(BuildContext context) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);

    final confirmed = await _showImportWarning(context);
    if (!confirmed) return;

    try {
      // iOS needs custom file type declarations but we are lazy so we pick any
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        dialogTitle: l10n.databaseImportTitle,
        type: Platform.isIOS ? FileType.any : FileType.custom,
        allowedExtensions: Platform.isIOS ? null : ['db'],
      );

      final path = result?.files.single.path;

      if (path == null) return;
      if (!context.mounted) return;

      // Reject newer-schema files before touching anything.
      final version = await readSqliteUserVersion(path);
      if (version != null && version > supportedSchemaVersion) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.databaseImportNewerFile)),
        );
        _logger.warn('Rejected database from a newer schema version', {
          'version': version,
        });
        return;
      }
      if (!context.mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(4),
                child: SizedBox(
                  height: 28,
                  width: 28,
                  child: CircularProgressIndicator(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(l10n.databaseImporting),
              ),
            ],
          ),
        ),
      );

      // Copy first, the picked file itself is never modified.
      final dbPath = await getAppDatabasePath();
      final newDbPath = '$dbPath.new';
      final newDbFile = File(newDbPath);
      if (newDbFile.existsSync()) await newDbFile.delete();
      await File(path).copy(newDbPath);

      Set<String> hosts;
      try {
        driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
        try {
          final importDb = AppDatabase(
            driftDatabase(
              name: 'import',
              native: DriftNativeOptions(databasePath: () async => newDbPath),
            ),
          );
          try {
            await importDb.customSelect('SELECT 1').get();
            final tables = await importDb
                .customSelect(
                  "SELECT name FROM sqlite_master WHERE type = 'table'",
                )
                .get();
            final present = tables
                .map((row) => row.read<String>('name'))
                .toSet();
            final missing = appTables.difference(present);
            if (missing.isNotEmpty) {
              throw Exception('Missing app tables: ${missing.join(', ')}');
            }
            // Strip untrusted credentials in the installed copy.
            await IdentityRepository(importDb).removeCredentials();
            hosts = await IdentityRepository(importDb).hosts();
            // No free-page remnants of the stripped credentials.
            await importDb.customStatement('VACUUM');
          } finally {
            await importDb.close();
          }
        } finally {
          driftRuntimeOptions.dontWarnAboutMultipleDatabases = false;
        }
        await excludeDatabaseFromBackup();

        navigator.pop();
        if (context.mounted) {
          await _showRestartDialog(context, hosts: hosts);
        }
      } on Exception catch (e) {
        if (newDbFile.existsSync()) await newDbFile.delete();
        navigator.pop();
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.databaseInvalidFile(e.toString()))),
        );
        _logger.warn('Database validation failed', null, e);
      }
    } on Exception catch (e) {
      navigator.pop();
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.databaseImportFailed(e.toString()))),
      );
    }
  }

  Future<bool> _showImportWarning(BuildContext context) => showDialog<bool>(
    context: context,
    builder: (context) => Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: AlertDialog(
          title: Text(AppLocalizations.of(context).databaseImportTitle),
          content: Text(AppLocalizations.of(context).databaseImportWarning),
          actions: [
            TextButton(
              onPressed: () => popDialog(context, false),
              child: Text(AppLocalizations.of(context).actionCancel),
            ),
            TextButton(
              onPressed: () => popDialog(context, true),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(AppLocalizations.of(context).actionImport),
            ),
          ],
        ),
      ),
    ),
  ).then((value) => value ?? false);

  Future<void> _showRestartDialog(
    BuildContext context, {
    required Set<String> hosts,
  }) => showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      final l10n = AppLocalizations.of(context);
      final foreignHosts = hosts.difference(defaultHosts);
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: AlertDialog(
            title: Text(l10n.databaseRestartTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.databaseRestartBody),
                const SizedBox(height: 12),
                Text(l10n.databaseImportSanitized),
                if (foreignHosts.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    l10n.databaseImportHostsWarning(foreignHosts.join(', ')),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  // Drop the staged import; the current database stays.
                  final messenger = ScaffoldMessenger.of(context);
                  final dbPath = await getAppDatabasePath();
                  final newDbFile = File('$dbPath.new');
                  if (newDbFile.existsSync()) await newDbFile.delete();
                  if (!context.mounted) return;
                  popDialog(context);
                  messenger.showSnackBar(
                    SnackBar(content: Text(l10n.databaseImportCancelled)),
                  );
                },
                child: Text(l10n.actionCancel),
              ),
              TextButton(
                onPressed: () => AppInit.of(context).reinitialize(),
                child: Text(l10n.actionRestartNow),
              ),
            ],
          ),
        ),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.file_upload),
      title: Text(AppLocalizations.of(context).databaseImport),
      subtitle: Text(
        AppLocalizations.of(context).databaseImportSubtitle,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () => _importDatabase(context),
    );
  }
}
