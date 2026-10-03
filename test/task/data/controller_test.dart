import 'dart:async';
import 'dart:io';

import 'package:cached_query/cached_query.dart';
import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/task/task.dart';
import 'package:e1547/traits/traits.dart';
// ignore: depend_on_referenced_packages
import 'package:file/local.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notified_preferences/notified_preferences.dart';

import '../../_support/harness.dart';

class FakeCacheManager implements BaseCacheManager {
  FakeCacheManager({FileInfo? cached}) : _cached = cached;

  final FileInfo? _cached;

  @override
  Future<FileInfo?> getFileFromCache(
    String url, {
    bool ignoreMemCache = false,
  }) async => _cached;

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}

class GatedTaskRepository extends TaskRepository {
  GatedTaskRepository({required super.database, required this.gate});

  final Completer<void> gate;

  @override
  Future<Task?> claimNext({int? identity, Set<TaskAction>? actions}) async {
    await gate.future;
    return super.claimNext(identity: identity, actions: actions);
  }
}

/// A fetcher that mimics an in-flight network transfer: it reports progress,
/// then stays put until its token is canceled, at which point it aborts with a
/// cancel exception like a real aborted transfer.
class FakeTransfer {
  final Completer<void> started = Completer<void>();
  final Completer<void> aborted = Completer<void>();

  DownloadFileFetcher get fetcher => (url, token, onProgress) async {
    onProgress?.call(0.3);
    started.complete();
    await token.whenCancel;
    if (!aborted.isCompleted) aborted.complete();
    throw DioException(
      requestOptions: RequestOptions(path: url),
      type: DioExceptionType.cancel,
    );
  };
}

void main() {
  late AppDatabase sqlite;
  late TaskRepository repository;
  late ValueNotifier<Traits> traits;
  late Client client;
  late Settings settings;
  late int identity;

  setUp(() async {
    await initializeTestApp();
    SharedPreferences.setMockInitialValues({});
    sqlite = AppDatabase(NativeDatabase.memory());
    repository = TaskRepository(database: sqlite);
    identity = (await IdentityRepository(
      sqlite,
    ).add(const IdentityRequest(host: 'e621.net', username: 'tester'))).id;
    traits = ValueNotifier(
      Traits(
        id: identity,
        userId: null,
        denylist: [],
        homeTags: '',
        avatar: null,
        perPage: null,
      ),
    );
    client = Client(
      identity: Identity(
        id: identity,
        host: 'e621.net',
        username: null,
        headers: null,
      ),
      traits: traits,
      storage: AppStorage(
        preferences: await SharedPreferences.getInstance(),
        temporaryFiles: '.',
        queryCache: CachedQuery.asNewInstance(),
        sqlite: sqlite,
      ),
    );
    // The fake clock would otherwise leave dio's timeout timers pending
    // on requests that are still in flight when the test ends.
    client.dio.options.connectTimeout = null;
    client.dio.options.receiveTimeout = null;
    settings = Settings(await SharedPreferences.getInstance());
  });

  tearDown(() async {
    traits.dispose();
    await sqlite.close();
  });

  TasksController controller({
    BaseCacheManager? cacheManager,
    TaskRepository? taskRepository,
    DownloadFileFetcher? fileFetcher,
  }) => TasksController(
    repository: taskRepository ?? repository,
    client: client,
    cacheManager: cacheManager ?? FakeCacheManager(),
    settings: settings,
    identity: identity,
    fileFetcher:
        fileFetcher ??
        (url, token, onProgress) =>
            fail('this test should not start a download'),
  );

  TaskRequest downloadRequest(String fileName) => TaskRequest(
    action: TaskAction.download,
    postId: 1,
    metadata: TaskMetadata(
      fileUrl: 'https://example.com/$fileName',
      fileName: fileName,
    ),
  );

  File fetchableFile(String path) {
    final file = File(path);
    file.createSync(recursive: true);
    file.writeAsBytesSync([1, 2, 3]);
    return file;
  }

  test('does not revive its active watch when disposed during init', () async {
    final instance = controller();
    instance.dispose();
    await pumpEventQueue();
  });

  test('returns claimed tasks when disposed mid-claim', () async {
    final gate = Completer<void>();
    final gated = GatedTaskRepository(database: sqlite, gate: gate);
    final instance = controller(taskRepository: gated);

    final task = await repository.add(
      downloadRequest('claimed.webm'),
      identity,
    );
    await pumpEventQueue();

    instance.dispose();
    gate.complete();
    await pumpEventQueue();

    expect(await repository.readStatus(task.id), TaskStatus.pending);
  });

  test('aborts in-flight transfers and returns them when disposed', () async {
    final transfer = FakeTransfer();
    final instance = controller(fileFetcher: transfer.fetcher);

    final task = await instance.enqueue(downloadRequest('in-flight.webm'));
    await transfer.started.future;

    instance.dispose();
    await transfer.aborted.future;
    await pumpEventQueue();

    expect(transfer.aborted.isCompleted, isTrue);
    expect(await repository.readStatus(task.id), TaskStatus.pending);
  });

  test('does not export canceled downloads', () async {
    final dir = await Directory.systemTemp.createTemp('task-cancel');
    addTearDown(() => dir.delete(recursive: true));
    settings.downloadPath.value = dir.path;

    final gate = Completer<void>();
    final source = fetchableFile('${dir.path}/source.bin');
    final fetched = File('${dir.path}/fetched.bin');
    addTearDown(() => source.delete());

    final instance = controller(
      fileFetcher: (url, token, onProgress) async {
        onProgress?.call(0.5);
        // the transfer completes even though the task was canceled, as can
        // happen when the cancellation races a finished download
        await gate.future;
        fetched.writeAsBytesSync([1, 2, 3]);
        return fetched;
      },
    );

    final task = await instance.enqueue(downloadRequest('canceled.webm'));
    await pumpEventQueue();

    await instance.cancel(task.id);
    await pumpEventQueue();

    gate.complete();
    await pumpEventQueue();
    await pumpEventQueue();

    expect(await repository.readStatus(task.id), TaskStatus.canceled);
    expect(File('${dir.path}/canceled.webm').existsSync(), isFalse);
    // the completed-but-canceled transfer is cleaned up with its temp file
    expect(fetched.existsSync(), isFalse);

    instance.dispose();
  });

  test('does not revive canceled tasks when released', () async {
    final task = await repository.add(
      downloadRequest('canceled-release.webm'),
      identity,
    );
    final claimed = await repository.claimNext(identity: identity);
    expect(claimed!.id, task.id);

    await repository.markCanceled(task.id);
    await repository.release(task.id);

    expect(await repository.readStatus(task.id), TaskStatus.canceled);
  });

  test(
    'does not revive canceled downloads when disposed mid-download',
    () async {
      final transfer = FakeTransfer();
      final instance = controller(fileFetcher: transfer.fetcher);

      final task = await instance.enqueue(
        downloadRequest('canceled-dispose.webm'),
      );
      await transfer.started.future;

      await instance.cancel(task.id);
      await transfer.aborted.future;

      instance.dispose();
      await pumpEventQueue();
      await pumpEventQueue();

      expect(await repository.readStatus(task.id), TaskStatus.canceled);
    },
  );

  test('canceling a download aborts its transfer', () async {
    final dir = await Directory.systemTemp.createTemp('task-abort');
    addTearDown(() => dir.delete(recursive: true));
    settings.downloadPath.value = dir.path;

    final transfer = FakeTransfer();
    final instance = controller(fileFetcher: transfer.fetcher);

    final task = await instance.enqueue(downloadRequest('abort.webm'));
    await transfer.started.future;

    await instance.cancel(task.id);
    await transfer.aborted.future;
    await pumpEventQueue();
    await pumpEventQueue();

    // the task is canceled, not failed, and nothing was exported
    expect(await repository.readStatus(task.id), TaskStatus.canceled);
    expect(File('${dir.path}/abort.webm').existsSync(), isFalse);

    instance.dispose();
  });

  test('canceling all tasks aborts their transfers', () async {
    final transfers = [FakeTransfer(), FakeTransfer()];
    int index = 0;
    final instance = controller(
      fileFetcher: (url, token, onProgress) {
        final FakeTransfer transfer = transfers[index++];
        return transfer.fetcher(url, token, onProgress);
      },
    );

    final tasks = [
      await instance.enqueue(downloadRequest('cancel-all-1.webm')),
      await instance.enqueue(downloadRequest('cancel-all-2.webm')),
    ];
    await transfers[0].started.future;
    await transfers[1].started.future;

    await instance.cancelAll();
    await transfers[0].aborted.future;
    await transfers[1].aborted.future;
    await pumpEventQueue();

    for (final task in tasks) {
      expect(await repository.readStatus(task.id), TaskStatus.canceled);
    }

    instance.dispose();
  });

  test('a completed download lands in the gallery folder', () async {
    final dir = await Directory.systemTemp.createTemp('task-complete');
    addTearDown(() => dir.delete(recursive: true));
    settings.downloadPath.value = dir.path;

    final source = fetchableFile('${dir.path}/source.bin');
    addTearDown(() => source.delete());

    final instance = controller(
      fileFetcher: (url, token, onProgress) async {
        onProgress?.call(0.5);
        onProgress?.call(1);
        return source;
      },
    );

    final task = await instance.enqueue(downloadRequest('completed.webm'));
    await pumpEventQueue();
    await pumpEventQueue();
    await pumpEventQueue();

    expect(await repository.readStatus(task.id), TaskStatus.completed);
    expect(File('${dir.path}/completed.webm').existsSync(), isTrue);

    instance.dispose();
  });

  test('a cached download skips the network transfer', () async {
    final dir = await Directory.systemTemp.createTemp('task-cached');
    addTearDown(() => dir.delete(recursive: true));
    settings.downloadPath.value = dir.path;

    final source = const LocalFileSystem().file('${dir.path}/source.bin');
    source.createSync(recursive: true);
    source.writeAsBytesSync([1, 2, 3]);
    addTearDown(() => source.delete());

    final instance = controller(
      cacheManager: FakeCacheManager(
        cached: FileInfo(
          source,
          FileSource.Cache,
          DateTime.now().add(const Duration(hours: 1)),
          'https://example.com/cached.webm',
        ),
      ),
      fileFetcher: (url, token, onProgress) {
        fail('a cached download must not start a network transfer');
      },
    );

    final task = await instance.enqueue(downloadRequest('cached.webm'));
    await pumpEventQueue();
    await pumpEventQueue();
    await pumpEventQueue();

    expect(await repository.readStatus(task.id), TaskStatus.completed);
    expect(File('${dir.path}/cached.webm').existsSync(), isTrue);

    instance.dispose();
  });

  test('a failed transfer marks the task failed', () async {
    final instance = controller(
      fileFetcher: (url, token, onProgress) async => throw DioException(
        requestOptions: RequestOptions(path: url),
        type: DioExceptionType.connectionError,
      ),
    );

    final task = await instance.enqueue(downloadRequest('error.webm'));
    await pumpEventQueue();
    await pumpEventQueue();

    expect(await repository.readStatus(task.id), TaskStatus.failed);

    instance.dispose();
  });
}
