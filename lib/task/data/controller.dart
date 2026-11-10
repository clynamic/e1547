import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/logs/logs.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/task/task.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

enum TaskKind { none, download, favorite, unfavorite, mixed, done }

const Duration _lingerAfterDone = Duration(seconds: 2);

class TasksController extends ChangeNotifier {
  TasksController({
    required this.repository,
    required this.client,
    required this.cacheManager,
    required this.settings,
    required this.identity,
    this.fileFetcher = fetchFileToTemp,
  }) {
    _init();
  }

  final TaskRepository repository;
  final Client client;
  final BaseCacheManager cacheManager;
  final Settings settings;
  final int identity;

  /// Fetches download files over the network; canceling its token aborts the
  /// transfer itself, not just the listening side.
  final DownloadFileFetcher fileFetcher;

  late final Logger _logger = Logger('TasksController', {'identity': identity});

  List<Task> _active = const [];
  List<Task> get active => _active;

  int _runningTotal = 0;
  int _runningDone = 0;
  int get runningTotal => _runningTotal;
  int get runningDone => _runningDone;

  final Set<int> _runningIds = {};
  bool isRunning(int taskId) => _runningIds.contains(taskId);

  /// Live download workers; each exits when the queue is empty, and any
  /// enqueue spawns replacements up to the concurrency limit. Without this,
  /// tasks arriving while every worker is busy would wait for a worker to
  /// free up, collapsing the queue to a single lane.
  int _downloadWorkers = 0;

  /// Whether the sequential api lane has a worker.
  bool _apiWorkerActive = false;

  /// Cancel tokens of in-flight download transfers, so canceling a task
  /// aborts its network transfer.
  final Map<int, CancelToken> _cancelTokens = {};

  /// Sum of in-flight progress across all running tasks (0..n), driving the
  /// aggregate bubble progress.
  final ValueNotifier<double> currentProgress = ValueNotifier(0);

  /// Per-task download progress, so each running tile updates on its own
  /// without rebuilding the others.
  final Map<int, ValueNotifier<double>> _progress = {};
  ValueListenable<double>? progressOf(int taskId) => _progress[taskId];

  StreamSubscription<List<Task>>? _activeSub;
  Timer? _hideTimer;
  bool _seeded = false;
  bool _disposed = false;

  // Downloads hit the CDN, which is free of the API rate limit, so they run
  // concurrently. Favorites and unfavorites stay on a single sequential lane.
  static const int _maxConcurrentDownloads = 4;

  // Kept separate from the controller's own listeners so toggling doesn't
  // mark Provider scopes dirty mid-build.
  final ValueNotifier<bool> suppressBubble = ValueNotifier<bool>(false);

  TaskKind get kind {
    if (_active.isEmpty) {
      return _runningTotal > 0 ? TaskKind.done : TaskKind.none;
    }
    final actions = _active.map((e) => e.action).toSet();
    if (actions.length > 1) return TaskKind.mixed;
    return switch (actions.first) {
      TaskAction.download => TaskKind.download,
      TaskAction.favorite => TaskKind.favorite,
      TaskAction.unfavorite => TaskKind.unfavorite,
    };
  }

  double get progress {
    if (_runningTotal == 0) return 0;
    return ((_runningDone + currentProgress.value) / _runningTotal).clamp(0, 1);
  }

  void _recomputeProgress() {
    if (_disposed) return;
    double inFlight = 0;
    for (final notifier in _progress.values) {
      inFlight += notifier.value;
    }
    currentProgress.value = inFlight;
  }

  Future<void> _init() async {
    await repository.resetRunning(identity: identity);
    // the controller may be disposed while the reset is in flight; leaving
    // now keeps the active watch from outliving the controller
    if (_disposed) return;
    _activeSub = repository.active(identity: identity).stream.listen((list) {
      final bool wasActive = _active.isNotEmpty;
      _active = list;
      if (!_seeded) {
        _seeded = true;
        if (list.isNotEmpty) {
          _runningTotal = list.length;
          _runningDone = 0;
        }
      }
      if (list.isNotEmpty) {
        _hideTimer?.cancel();
        _hideTimer = null;
        // a task may have been enqueued by a controller that was disposed
        // before the insert landed; picking work up again here keeps such
        // tasks from waiting for the next user action
        if (!wasActive) _kick();
      } else if (wasActive) {
        _hideTimer?.cancel();
        _hideTimer = Timer(_lingerAfterDone, _resetCounters);
      }
      notifyListeners();
    });
    unawaited(_runSweep());
    _kick();
  }

  void _resetCounters() {
    if (_disposed) return;
    _runningTotal = 0;
    _runningDone = 0;
    notifyListeners();
  }

  Future<void> _runSweep() async {
    try {
      await repository.sweep(
        action: TaskAction.download,
        status: TaskStatus.completed,
        maxAge: const Duration(days: 7),
      );
      for (final action in const [TaskAction.favorite, TaskAction.unfavorite]) {
        await repository.sweep(
          action: action,
          status: TaskStatus.completed,
          maxAge: const Duration(days: 1),
        );
      }
      for (final action in TaskAction.values) {
        for (final status in const [TaskStatus.failed, TaskStatus.canceled]) {
          await repository.sweep(
            action: action,
            status: status,
            maxAge: const Duration(days: 1),
          );
        }
      }
    } on Object catch (e, s) {
      _logger.warn('Task sweep failed', null, e, s);
    }
  }

  Future<Task> enqueue(TaskRequest request) async {
    _hideTimer?.cancel();
    _hideTimer = null;
    final task = await repository.add(request, identity);
    if (!_disposed) {
      _runningTotal++;
      notifyListeners();
      _kick();
    }
    return task;
  }

  Future<List<Task>> enqueueAll(Iterable<TaskRequest> requests) async {
    final List<TaskRequest> list = requests.toList();
    if (list.isEmpty) return const [];
    _hideTimer?.cancel();
    _hideTimer = null;
    final List<Task> created = await repository.addAll(list, identity);
    if (!_disposed) {
      _runningTotal += created.length;
      notifyListeners();
      _kick();
    }
    return created;
  }

  void _kick() {
    // spawn download workers up to the concurrency limit; exiting workers
    // free their slot, so new tasks always find a fresh worker
    while (!_disposed && _downloadWorkers < _maxConcurrentDownloads) {
      _downloadWorkers++;
      unawaited(_downloadWorker().whenComplete(() => _downloadWorkers--));
    }
    if (!_disposed && !_apiWorkerActive) {
      _apiWorkerActive = true;
      unawaited(_drainApi().whenComplete(() => _apiWorkerActive = false));
    }
  }

  Future<void> _downloadWorker() async {
    while (!_disposed) {
      final Task? next = await repository.claimNext(
        identity: identity,
        actions: const {TaskAction.download},
      );
      if (next == null) break;
      if (_disposed) {
        // give the claimed task back so the next controller can pick it up
        await repository.release(next.id);
        break;
      }
      await _process(next);
    }
  }

  Future<void> _drainApi() async {
    while (!_disposed) {
      final Task? next = await repository.claimNext(
        identity: identity,
        actions: const {TaskAction.favorite, TaskAction.unfavorite},
      );
      if (next == null) break;
      if (_disposed) {
        // give the claimed task back so the next controller can pick it up
        await repository.release(next.id);
        break;
      }
      await _process(next);
    }
  }

  Future<void> _process(Task task) async {
    _runningIds.add(task.id);
    _progress[task.id] = ValueNotifier<double>(0);
    notifyListeners();
    try {
      await _runOne(task);
      final TaskStatus? current = await repository.readStatus(task.id);
      if (current == TaskStatus.running) {
        await repository.markCompleted(task.id);
      }
    } on Object catch (e, s) {
      _logger.warn(
        'Task {task} ({action}) failed',
        {'task': task.id, 'action': task.action.name},
        e,
        s,
      );
      final TaskStatus? current = await repository.readStatus(task.id);
      if (current == TaskStatus.running) {
        await repository.markFailed(task.id, e.toString());
      }
    } finally {
      _runningDone++;
      _runningIds.remove(task.id);
      _progress.remove(task.id)?.dispose();
      if (!_disposed) {
        _recomputeProgress();
        notifyListeners();
      }
    }
  }

  Future<void> _runOne(Task task) async {
    switch (task.action) {
      case TaskAction.download:
        await _runDownload(task);
      case TaskAction.favorite:
        await client.posts.addFavorite(task.postId);
        if (settings.upvoteFavs.value) {
          try {
            await client.posts.vote(
              id: task.postId,
              upvote: true,
              replace: true,
            );
          } on Object catch (e, s) {
            // upvote is best-effort once the favorite succeeded
            _logger.warn(
              'Upvote after favorite failed for post {post}',
              {'post': task.postId},
              e,
              s,
            );
          }
        }
      case TaskAction.unfavorite:
        await client.posts.removeFavorite(task.postId);
    }
  }

  Future<void> _runDownload(Task task) async {
    final String? url = task.metadata?.fileUrl;
    final String? fileName = task.metadata?.fileName;
    if (url == null || fileName == null) {
      throw FileDownloadException(
        'Download task missing file metadata (post #${task.postId})',
      );
    }
    final ValueNotifier<double>? progress = _progress[task.id];
    final CancelToken cancelToken = CancelToken();
    _cancelTokens[task.id] = cancelToken;
    // the controller may have been disposed while this task waited for a
    // worker; canceling right away aborts the fetch before it starts
    if (_disposed) cancelToken.cancel();
    try {
      bool fromCache = false;
      File file;
      // a file that is already in the cache needs no network transfer
      FileInfo? cached;
      try {
        cached = await cacheManager.getFileFromCache(url);
      } on Object {
        // cache reads are best-effort; the network path still works
      }
      if (!_disposed && cached != null && cached.file.existsSync()) {
        fromCache = true;
        file = cached.file;
        progress?.value = 1;
        _recomputeProgress();
      } else {
        file = await fileFetcher(url, cancelToken, (double value) {
          progress?.value = value;
          _recomputeProgress();
        });
      }
      if (_disposed) {
        // the controller is gone; put the task back so the next controller
        // can pick it up again
        if (!fromCache) {
          _deleteQuietly(file);
        }
        await repository.release(task.id);
        return;
      }
      final TaskStatus? status = await repository.readStatus(task.id);
      if (status == TaskStatus.canceled) {
        // a canceled download must not land in the user's gallery
        if (!fromCache) {
          _deleteQuietly(file);
        }
        return;
      }
      try {
        await FileDownloader.downloadImage(
          file: file,
          directory: settings.downloadPath.value,
          folderName: AppInfo.instance.appName,
          fileName: fileName,
          onDirectoryChanged: (p) => settings.downloadPath.value = p,
        );
      } on FileDownloadException {
        rethrow;
      } on Exception catch (e) {
        throw FileDownloadException.from(e);
      }
      return;
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        if (_disposed) {
          // the transfer was aborted by disposal; the task goes back to the
          // queue instead of failing
          await repository.release(task.id);
          return;
        }
        final TaskStatus? status = await repository.readStatus(task.id);
        if (status == TaskStatus.canceled) {
          // the user canceled; the terminal status is already set
          return;
        }
        throw FileDownloadException('Download transfer was canceled');
      }
      throw FileDownloadException.from(e);
    } finally {
      _cancelTokens.remove(task.id);
    }
  }

  void _deleteQuietly(File file) {
    // the fetched file lives in a temporary directory; leaving it behind would
    // leak disk space until the system clears its cache
    file.delete().ignore();
  }

  Future<void> cancel(int taskId) async {
    await repository.markCanceled(taskId);
    _cancelTokens[taskId]?.cancel();
  }

  Future<void> dismiss(int taskId) => repository.remove(taskId);

  Future<void> retry(int taskId) async {
    final Task task = await repository.get(taskId);
    await repository.remove(taskId);
    await enqueue(
      TaskRequest(
        action: task.action,
        postId: task.postId,
        metadata: task.metadata,
      ),
    );
  }

  /// Cancels every queued and in-progress task. Canceled tasks stay in the
  /// list and can be retried.
  Future<void> cancelAll() async {
    await repository.cancelAll(identity: identity);
    for (final CancelToken token in _cancelTokens.values) {
      token.cancel();
    }
  }

  /// Removes completed and canceled tasks. Failed tasks are kept so they stay
  /// visible for retry.
  Future<void> clearDone() => repository.clear(
    statuses: const {TaskStatus.completed, TaskStatus.canceled},
    identity: identity,
  );

  @override
  void dispose() {
    _disposed = true;
    _activeSub?.cancel();
    _hideTimer?.cancel();
    // abort the transfers of in-flight downloads; their tasks are released
    // back to the queue instead of failing
    for (final CancelToken token in _cancelTokens.values) {
      token.cancel();
    }
    for (final notifier in _progress.values) {
      notifier.dispose();
    }
    _progress.clear();
    currentProgress.dispose();
    suppressBubble.dispose();
    super.dispose();
  }
}
