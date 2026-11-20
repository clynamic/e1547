import 'dart:async';
import 'dart:io' as io;

import 'package:e1547/post/post.dart';
import 'package:e1547/task/task.dart';
import 'package:file/memory.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';

import '../../_support/environment.dart';
import '../../_support/harness.dart';
import '../../_support/posts.dart';

class HeldDownloads implements BaseCacheManager {
  final Map<String, StreamController<FileResponse>> transfers = {};
  final MemoryFileSystem _files = MemoryFileSystem();

  @override
  Stream<FileResponse> getFileStream(
    String url, {
    String? key,
    Map<String, String>? headers,
    bool? withProgress,
  }) => (transfers[url] = StreamController<FileResponse>()).stream;

  void report(String url, int received) =>
      transfers[url]!.add(DownloadProgress(url, 3, received));

  void finish(String url) => transfers[url]!
    ..add(
      FileInfo(
        _files.file(url.hashCode.toString())..writeAsBytesSync([1, 2, 3]),
        FileSource.Online,
        DateTime(9999),
        url,
      ),
    )
    ..close();

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} only holds downloads');
}

class CountingFolderPicker extends FilePicker {
  CountingFolderPicker(this.folder);

  final String? folder;
  int asked = 0;

  @override
  Future<String?> getDirectoryPath({
    String? dialogTitle,
    bool lockParentWindow = false,
    String? initialDirectory,
  }) async {
    asked++;
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return folder;
  }
}

void main() {
  late TestEnvironment env;
  late HeldDownloads downloads;
  late TasksController tasks;

  setUpAll(initializeTestApp);

  TasksController controller() => TasksController(
    repository: TaskRepository(database: env.sqlite),
    client: env.client,
    cacheManager: downloads,
    settings: env.settings,
    identity: env.client.identity.id,
  );

  setUp(() async {
    env = await TestEnvironment.start();
    env.settings.upvoteFavs.value = false;
    downloads = HeldDownloads();
    tasks = controller();
  });

  tearDown(() async {
    tasks.dispose();
    await env.dispose();
  });

  Future<void> until(bool Function() done) async {
    for (int i = 0; i < 40 && !done(); i++) {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
  }

  Future<Post?> cachedAfter(int id, bool Function(Post post) done) async {
    bool cached() => switch (env.client.posts.postCache.get(id)) {
      final Post post => done(post),
      null => false,
    };
    await until(cached);
    return env.client.posts.postCache.get(id);
  }

  test('favorite tasks update the cached post both ways', () async {
    env.client.posts.postCache.savePage([samplePost(id: 1000, favCount: 3)]);

    await tasks.enqueueAll([
      const TaskRequest(action: TaskAction.favorite, postId: 1000),
    ]);
    final Post? favorited = await cachedAfter(
      1000,
      (e) => e.isFavorited && env.fake.state.favorites.isNotEmpty,
    );

    expect(favorited?.isFavorited, isTrue);
    expect(favorited?.favCount, 4);
    expect(env.fake.state.favorites, {1000});

    await tasks.enqueueAll([
      const TaskRequest(action: TaskAction.unfavorite, postId: 1000),
    ]);
    final Post? unfavorited = await cachedAfter(
      1000,
      (e) => !e.isFavorited && env.fake.state.favorites.isEmpty,
    );

    expect(unfavorited?.isFavorited, isFalse);
    expect(unfavorited?.favCount, 3);
    expect(env.fake.state.favorites, isEmpty);
  });

  test('a favorite task that upvotes updates the cached score', () async {
    env.settings.upvoteFavs.value = true;
    env.client.posts.postCache.savePage([samplePost(id: 1000, score: 5)]);

    await tasks.enqueueAll([
      const TaskRequest(action: TaskAction.favorite, postId: 1000),
    ]);
    final Post? voted = await cachedAfter(1000, (e) => e.vote == 1);

    expect(voted?.vote, 1);
    expect(voted?.score, 6);
  });

  group('downloads', () {
    late io.Directory folder;

    setUp(() {
      folder = io.Directory.systemTemp.createTempSync('downloads');
      env.settings.downloadPath.value = folder.path;
    });

    tearDown(() => folder.deleteSync(recursive: true));

    String urlOf(int id) => 'http://example.invalid/$id.png';

    TaskRequest download(int id) => TaskRequest(
      action: TaskAction.download,
      postId: id,
      metadata: TaskMetadata(fileUrl: urlOf(id), fileName: '$id.png'),
    );

    bool saved(int id) => io.File(join(folder.path, '$id.png')).existsSync();

    test(
      'a download canceled while it transfers stops and is not saved',
      () async {
        final Task task = await tasks.enqueue(download(1));
        await until(() => downloads.transfers.length == 1);

        await tasks.cancel(task.id);
        downloads.report(urlOf(1), 1);
        await until(() => !tasks.isRunning(task.id));

        expect(downloads.transfers[urlOf(1)]!.hasListener, isFalse);
        expect(saved(1), isFalse);
      },
    );

    test('a download canceled as a worker picks it up is not saved', () async {
      final Task task = await tasks.enqueue(download(1));
      await tasks.cancel(task.id);
      await until(() => downloads.transfers.length == 1);

      downloads.finish(urlOf(1));
      await until(() => !tasks.isRunning(task.id));

      expect(saved(1), isFalse);
    });

    test('asks for a download folder once for a whole batch', () async {
      final CountingFolderPicker picker = CountingFolderPicker(folder.path);
      FilePicker.platform = picker;
      env.settings.downloadPath.value = null;

      await tasks.enqueueAll([download(1), download(2), download(3)]);
      await until(() => downloads.transfers.length == 3);
      downloads
        ..finish(urlOf(1))
        ..finish(urlOf(2))
        ..finish(urlOf(3));
      await until(() => [1, 2, 3].every(saved));

      expect([1, 2, 3].every(saved), isTrue);
      expect(picker.asked, 1);
    });

    test('queues no downloads when no folder is picked', () async {
      FilePicker.platform = CountingFolderPicker(null);
      env.settings.downloadPath.value = null;

      final List<Task> queued = await tasks.enqueueAll([
        download(1),
        download(2),
      ]);

      expect(queued, isEmpty);
      expect(await TaskRepository(database: env.sqlite).length(), 0);
    });

    test(
      'downloads canceled together as workers pick them up are not saved',
      () async {
        final List<Task> started = await tasks.enqueueAll([
          download(1),
          download(2),
        ]);
        await tasks.cancelAll();
        await until(() => downloads.transfers.length == 2);

        downloads
          ..finish(urlOf(1))
          ..finish(urlOf(2));
        await until(() => started.every((e) => !tasks.isRunning(e.id)));

        expect(saved(1), isFalse);
        expect(saved(2), isFalse);
      },
    );

    test(
      'a finished transfer reports saving until the file is in place',
      () async {
        final Task task = await tasks.enqueue(download(1));
        await until(() => downloads.transfers.length == 1);
        final ValueListenable<double?> progress = tasks.progressOf(task.id)!;
        final List<(double?, bool)> seen = [];
        progress.addListener(() => seen.add((progress.value, saved(1))));

        downloads
          ..report(urlOf(1), 3)
          ..finish(urlOf(1));
        await until(() => !tasks.isRunning(task.id));

        expect(seen, [(1.0, false), (null, false)]);
        expect(saved(1), isTrue);
      },
    );

    test('a saving download counts as fully transferred overall', () async {
      final Task task = await tasks.enqueue(download(1));
      await until(() => downloads.transfers.length == 1);
      final List<double> overall = [];
      tasks.currentProgress.addListener(
        () => overall.add(tasks.currentProgress.value),
      );

      downloads.report(urlOf(1), 1);
      await until(() => overall.isNotEmpty);
      downloads.finish(urlOf(1));
      await until(() => !tasks.isRunning(task.id));

      expect(overall.take(2), [closeTo(1 / 3, 0.01), 1.0]);
    });

    test(
      'a replaced controller stops its downloads and the next one finishes them',
      () async {
        final Task task = await tasks.enqueue(download(1));
        await until(() => downloads.transfers.length == 1);
        final StreamController<FileResponse> replaced = downloads.transfers
            .remove(urlOf(1))!;
        addTearDown(replaced.close);

        final List<LogRecord> warnings = [];
        final StreamSubscription<LogRecord> logs = Logger.root.onRecord
            .where((e) => e.level >= Level.WARNING)
            .listen(warnings.add);
        addTearDown(logs.cancel);
        tasks.dispose();
        tasks = controller();
        await until(() => downloads.transfers.length == 1);
        replaced.add(DownloadProgress(urlOf(1), 3, 1));
        downloads.finish(urlOf(1));
        await until(() => !tasks.isRunning(task.id));

        expect(replaced.hasListener, isFalse);
        expect(warnings, isEmpty);
        expect(
          await tasks.repository.readStatus(task.id),
          TaskStatus.completed,
        );
        expect(saved(1), isTrue);
      },
    );

    test('downloads added while one transfers start alongside it', () async {
      await tasks.enqueue(download(1));
      await until(() => downloads.transfers.length == 1);

      await tasks.enqueueAll([download(2), download(3), download(4)]);
      await until(() => downloads.transfers.length == 4);

      expect(downloads.transfers, hasLength(4));
    });
  });
}
