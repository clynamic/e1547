import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift_flutter/drift_flutter.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/app/widget/initialize.dart';
import 'package:e1547/logs/logs.dart';
import 'package:e1547/shared/shared.dart';
import 'package:file_picker/file_picker.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sub/flutter_sub.dart';

typedef DatabaseInfo = ({String name, String size});

final _logger = Logger('DbManagement');

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
    final size = dbFile.existsSync()
        ? filesize(dbFile.lengthSync())
        : t('Unknown');

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
                ? (name: t('Error loading database'), size: 'N/A')
                : (name: t('Loading...'), size: '...'));

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
                  dbInfo.size,
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

  Future<void> _exportDatabase(BuildContext context) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

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
                child: Text(t('Exporting database...')),
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

      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: t('Export Database'),
        fileName: 'e1547_database_backup.db',
        type: FileType.custom,
        allowedExtensions: ['db'],
        bytes: await dbFile.readAsBytes(),
      );

      navigator.pop();
      if (outputFile != null) {
        messenger.showSnackBar(
          SnackBar(content: Text(t('Database exported successfully'))),
        );
      }
    } on Exception catch (e) {
      navigator.pop();
      messenger.showSnackBar(SnackBar(content: Text(t('Export failed'))));
      _logger.warn('Database export failed', null, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.file_download),
      title: Text(t('Export')),
      subtitle: Text(
        t('Save a backup copy of your database'),
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

    final confirmed = await _showImportWarning(context);
    if (!confirmed) return;

    try {
      // iOS needs custom file type declarations but we are lazy so we pick any
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        dialogTitle: t('Import Database'),
        type: Platform.isIOS ? FileType.any : FileType.custom,
        allowedExtensions: Platform.isIOS ? null : ['db'],
      );

      final path = result?.files.single.path;

      if (path == null) return;
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
                child: Text(t('Importing database...')),
              ),
            ],
          ),
        ),
      );

      try {
        driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
        final importDb = AppDatabase(
          driftDatabase(
            name: 'import',
            native: DriftNativeOptions(databasePath: () async => path),
          ),
        );
        await importDb.customSelect('SELECT 1').get();
        await importDb.close();
      } on Exception catch (e) {
        navigator.pop();
        messenger.showSnackBar(
          SnackBar(
            content: Text(tf('Invalid database file: {error}', params: {'error': e})),
          ),
        );
        _logger.warn('Database validation failed', null, e);
        return;
      } finally {
        driftRuntimeOptions.dontWarnAboutMultipleDatabases = false;
      }

      final importFile = File(path);
      final dbPath = await getAppDatabasePath();
      final newDbPath = '$dbPath.new';
      await importFile.copy(newDbPath);

      navigator.pop();
      if (context.mounted) {
        await _showRestartDialog(context);
      }
    } on Exception catch (e) {
      navigator.pop();
      messenger.showSnackBar(
        SnackBar(content: Text(tf('Import failed: {error}', params: {'error': e}))),
      );
    }
  }

  Future<bool> _showImportWarning(BuildContext context) => showDialog<bool>(
    context: context,
    builder: (context) => Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: AlertDialog(
          title: Text(t('Import Database')),
          content: Text(
            t(
              'This will replace your current database. \n'
              'All data will be lost. This cannot be undone!',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(t('CANCEL')),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(t('IMPORT')),
            ),
          ],
        ),
      ),
    ),
  ).then((value) => value ?? false);

  Future<void> _showRestartDialog(BuildContext context) => showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text(t('Restart Required')),
      content: Text(t('The app needs to restart to apply changes.')),
      actions: [
        TextButton(
          onPressed: () => AppInit.of(context).reinitialize(),
          child: Text(t('RESTART NOW')),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.file_upload),
      title: Text(t('Import')),
      subtitle: Text(
        t('Replace current database with imported one'),
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () => _importDatabase(context),
    );
  }
}
