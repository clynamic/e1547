import 'dart:io';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/settings/settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class _FakePathProvider extends PathProviderPlatform {
  _FakePathProvider(this.support);

  final String support;
  final List<String> flagged = [];

  @override
  Future<String?> getApplicationSupportPath() async => support;
}

/// Builds a 64 byte SQLite header with [version] at the user_version offset.
Uint8List sqliteHeader(int version) {
  final bytes = Uint8List(64);
  'SQLite format 3'.codeUnits
      .take(15)
      .forEach((unit) => bytes[bytes.indexOf(0)] = unit);
  ByteData.sublistView(bytes, 60, 64).setUint32(0, version);
  return bytes;
}

Future<String> writeHeader(Directory dir, String name, List<int> bytes) async {
  final path = '${dir.path}${Platform.pathSeparator}$name';
  await File(path).writeAsBytes(bytes, flush: true);
  return path;
}

void main() {
  test('readSqliteUserVersion reads the big endian user_version', () async {
    final dir = await Directory.systemTemp.createTemp('e1547_version');
    addTearDown(() => dir.delete(recursive: true));

    final good = await writeHeader(dir, 'good.db', sqliteHeader(7));
    expect(await readSqliteUserVersion(good), 7);

    final zero = await writeHeader(dir, 'zero.db', sqliteHeader(0));
    expect(await readSqliteUserVersion(zero), 0);

    final wrongMagic = sqliteHeader(9);
    wrongMagic[0] = 88;
    final wrong = await writeHeader(dir, 'wrong.db', wrongMagic);
    expect(await readSqliteUserVersion(wrong), isNull);

    final short = await writeHeader(
      dir,
      'short.db',
      sqliteHeader(9).sublist(0, 63),
    );
    expect(await readSqliteUserVersion(short), isNull);

    final missing = '${dir.path}${Platform.pathSeparator}missing.db';
    expect(await readSqliteUserVersion(missing), isNull);
  });

  test('readSqliteUserVersion reads a real drift database', () async {
    final dir = await Directory.systemTemp.createTemp('e1547_real');
    addTearDown(() => dir.delete(recursive: true));
    final path = '${dir.path}${Platform.pathSeparator}app.db';

    final db = AppDatabase(NativeDatabase(File(path)));
    final version = db.schemaVersion;
    // Force the file onto disk before closing.
    await db.customSelect('SELECT 1').get();
    await db.close();

    expect(await readSqliteUserVersion(path), version);
  });

  test('the import gate stays in sync with the schema version', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    expect(supportedSchemaVersion, db.schemaVersion);
    expect(appTables, {
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
    });
  });

  test('excludeDatabaseFromBackup completes without a handler', () async {
    final support = await Directory.systemTemp.createTemp('e1547_backup');
    addTearDown(() => support.delete(recursive: true));
    final original = PathProviderPlatform.instance;
    final provider = _FakePathProvider(support.path);
    PathProviderPlatform.instance = provider;
    addTearDown(() => PathProviderPlatform.instance = original);

    // A staged import and sidecar files all exist next to the database.
    for (final suffix in ['.new', '-journal', '-wal', '-shm']) {
      await File(
        '${support.path}${Platform.pathSeparator}app.db$suffix',
      ).writeAsString('x');
    }

    // Without an iOS handler this must not throw;
    // on other platforms it returns before touching the channel.
    await excludeDatabaseFromBackup();
  });
}
