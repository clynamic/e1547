import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/identity/identity.dart';
import 'package:flutter_test/flutter_test.dart';

/// Decodes file bytes 1:1 so byte substrings become string substrings.
String asBytesString(List<int> bytes) => latin1.decode(bytes);

void main() {
  late AppDatabase sqlite;
  late IdentityRepository repository;

  Future<void> addIdentity(
    String host,
    String? username,
    Map<String, String>? headers,
  ) => repository.add(
    IdentityRequest(host: host, username: username, headers: headers),
  );

  setUp(() async {
    sqlite = AppDatabase(NativeDatabase.memory());
    repository = IdentityRepository(sqlite);
  });

  tearDown(() => sqlite.close());

  group('IdentityRepository.removeCredentials', () {
    test('strips secret headers and keeps the rest', () async {
      await addIdentity('e621.net', 'tester', {
        'authorization': 'Basic secret',
        'cookie': 'cf_clearance=dead',
        'x-api-key': 'hunter2',
        'user-agent': 'e1547/1.0',
      });

      final changed = await repository.removeCredentials();

      expect(changed, 1);
      final identity = (await repository.all()).single;
      expect(identity.headers, {'user-agent': 'e1547/1.0'});
    });

    test('writes an empty map instead of null', () async {
      await addIdentity('e621.net', 'tester', {
        'authorization': 'Basic secret',
      });

      await repository.removeCredentials();

      final identity = (await repository.all()).single;
      expect(identity.headers, isNotNull);
      expect(identity.headers, isEmpty);
    });

    test('counts only rows that change', () async {
      await addIdentity('e621.net', 'tester', {'authorization': 'Basic a'});
      await addIdentity('e621.net', null, null);
      await addIdentity('e926.net', 'other', {'user-agent': 'x'});

      final changed = await repository.removeCredentials();

      expect(changed, 1);
    });

    test('leaves null headers alone', () async {
      await addIdentity('e621.net', null, null);

      final changed = await repository.removeCredentials();

      expect(changed, 0);
    });
  });

  group('IdentityRepository.hosts', () {
    test('returns the normalized host set', () async {
      await addIdentity('e621.net', 'tester', null);
      await addIdentity('https://e926.net/', 'other', null);

      final hosts = await repository.hosts();

      expect(hosts, {'https://e621.net', 'https://e926.net'});
    });
  });

  group('credential remnants', () {
    test('a vacuumed rewrite leaves no recoverable bytes', () async {
      final dir = await Directory.systemTemp.createTemp('e1547_identity');
      addTearDown(() => dir.delete(recursive: true));
      final path = '${dir.path}${Platform.pathSeparator}app.db';

      final fileDb = AppDatabase(
        NativeDatabase(
          File(path),
          setup: (db) => db.execute('PRAGMA journal_mode = DELETE'),
        ),
      );
      await IdentityRepository(fileDb).add(
        const IdentityRequest(
          host: 'e621.net',
          username: 'tester',
          headers: {'authorization': 'Basic SUPERSECRETKEY'},
        ),
      );
      await fileDb.close();

      // A plain file copy must still contain the secret,
      // proving the marker is actually in the file.
      final rawBytes = await File(path).readAsBytes();
      expect(asBytesString(rawBytes), contains('SUPERSECRETKEY'));

      final rewriteDb = AppDatabase(NativeDatabase(File(path)));
      await IdentityRepository(rewriteDb).removeCredentials();
      await rewriteDb.customStatement('VACUUM');
      await rewriteDb.close();

      final rewritten = await File(path).readAsBytes();
      expect(asBytesString(rewritten), isNot(contains('SUPERSECRETKEY')));
    });
  });
}
