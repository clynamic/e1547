import 'dart:io';

import 'package:e1547/app/app.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory dir;
  late File picked;
  late String target;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('import_test');
    picked = File(join(dir.path, 'backup.db'));
    target = join(dir.path, 'app.db.new');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (call) async => dir.path,
        );
  });

  tearDown(() => dir.deleteSync(recursive: true));

  test(
    'validates a copy of the import and leaves the picked file as it was',
    () async {
      picked.writeAsBytesSync([]);

      await stageDbImport(picked.path, target);

      expect(picked.readAsBytesSync(), isEmpty);
      expect(File(target).readAsBytesSync(), isNotEmpty);
    },
  );

  test('discards the copy of an import that is no database', () async {
    picked.writeAsStringSync('no database in here, only text');

    await expectLater(
      stageDbImport(picked.path, target),
      throwsA(isA<DatabaseImportException>()),
    );
    expect(dir.listSync().map((e) => e.path), [picked.path]);
  });
}
