import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/logs/logs.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sub/flutter_sub.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  LogFileInfo? _file;

  @override
  Widget build(BuildContext context) {
    final LogErrors? errors = context.watch<LogErrors?>();
    final LogFileInfo? file = _file;
    return SubValue<LogSource>(
      create: () =>
          (file == null
                ? LiveLogSource(context.read<Logs>())
                : LogFileSource(File(file.path), date: file.date))
            ..load(),
      keys: [file?.path],
      dispose: (source) => source.dispose(),
      builder: (context, source) => SubEffect(
        effect: () {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => errors?.suppressBubble.value = true,
          );
          return () => WidgetsBinding.instance.addPostFrameCallback(
            (_) => errors?.suppressBubble.value = false,
          );
        },
        keys: [errors],
        child: LogPage(
          source: source,
          onShowAll: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => LogFileList(
                // Closing the list is the tile's own job: its guard pops
                // the list's route before handing over the selection.
                onSelected: (file) {
                  setState(() => _file = file);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LogFileList extends StatefulWidget {
  const LogFileList({super.key, required this.onSelected});

  final ValueSetter<LogFileInfo?> onSelected;

  @override
  State<LogFileList> createState() => _LogFileListState();
}

class _LogFileListState extends State<LogFileList> {
  Key _key = UniqueKey();

  Future<List<LogFileInfo>> _read(String path) => Directory(path)
      .list()
      .where(
        (e) =>
            FileSystemEntity.isFileSync(e.path) &&
            e.path.endsWith(logFileExtension),
      )
      .map((e) => LogFileInfo.parse(e.path))
      .toList();

  @override
  Widget build(BuildContext context) {
    final String path = context.read<AppStorage>().temporaryFiles;
    final l10n = AppLocalizations.of(context);
    return TileLayout(
      tileSize: 160,
      child: SubFuture<List<LogFileInfo>>(
        create: () => _read(path),
        keys: [_key, path],
        builder: (context, snapshot) {
          final List<LogFileInfo>? files = snapshot.data
              ?.sorted((a, b) => b.date.compareTo(a.date))
              .toList();
          return SelectionLayout<LogFileInfo>(
            items: files,
            child: Scaffold(
              appBar: LogFileSelectionAppBar(
                child: DefaultAppBar(title: Text(l10n.logFilesTitle)),
                onDelete: (files) async {
                  await Future.wait(files.map((e) => File(e.path).delete()));
                  if (!context.mounted) return;
                  setState(() => _key = UniqueKey());
                },
              ),
              body: Builder(
                builder: (context) {
                  if (snapshot.hasError) {
                    return IconMessage(
                      icon: const Icon(Icons.warning_amber),
                      title: Text(l10n.failedToLoadLogFiles),
                    );
                  }
                  if (files == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (files.isEmpty) {
                    return IconMessage(
                      icon: const Icon(Icons.close),
                      title: Text(l10n.noLogFiles),
                    );
                  }
                  return GridView.custom(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: TileLayout.of(context).crossAxisCount,
                      childAspectRatio:
                          1 / TileLayout.of(context).tileHeightFactor,
                    ),
                    childrenDelegate: SliverChildBuilderDelegate(
                      childCount: files.length + 1,
                      (context, index) {
                        if (index == 0) {
                          return InkWell(
                            onTap: () {
                              if (popDialog(context)) {
                                widget.onSelected(null);
                              }
                            },
                            child: Column(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Icon(
                                      Icons.videocam,
                                      size: 38,
                                      color: dimTextColor(context),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    l10n.logsLive,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        index--;
                        return LogFileTile(
                          file: files[index],
                          onSelected: widget.onSelected,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class LogFileTile extends StatelessWidget {
  const LogFileTile({super.key, required this.file, this.onSelected});

  final LogFileInfo file;
  final void Function(LogFileInfo file)? onSelected;

  @override
  Widget build(BuildContext context) {
    return SelectionItemOverlay<LogFileInfo>(
      item: file,
      child: InkWell(
        onTap: onSelected != null
            ? () {
                if (popDialog(context)) {
                  onSelected!(file);
                }
              }
            : null,
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Icon(
                  file.type == 'background' ? Icons.cloud : Icons.description,
                  size: 38,
                  color: dimTextColor(context),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    DateFormatting.date(file.date),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    DateFormatting.time(file.date),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LogPage extends StatefulWidget {
  const LogPage({super.key, required this.source, this.onShowAll});

  final LogSource source;
  final VoidCallback? onShowAll;

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  final ScrollController _scrollController = ScrollController();

  Set<LogLevel> _levels = LogLevel.values.toSet();
  int? _head;

  /// Distance from the newest entry within which the log keeps following.
  static const double _followRange = 4;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant LogPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.source != oldWidget.source) _head = null;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Older pages arrive at the end, where they disturb nothing. New entries
  /// arrive at the head, which would slide whatever is being read across the
  /// screen. While scrolled away from it, they wait behind [_head].
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels <= _followRange) {
      if (_head == null) return;
      setState(() => _head = null);
    } else {
      if (_head != null) return;
      final int? head = widget.source.entries.lastOrNull?.id;
      if (head == null) return;
      setState(() => _head = head);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Settings? settings = widget.source.live
        ? context.watch<Settings?>()
        : null;
    if (settings == null) return _body();
    return ValueListenableBuilder<bool>(
      valueListenable: settings.verboseLogs,
      builder: (context, verbose, child) => _body(
        recording: verboseLogLevel(verbose: verbose),
        verbose: verbose,
        onVerbose: (value) => settings.verboseLogs.value = value,
      ),
    );
  }

  Widget _body({
    LogLevel? recording,
    bool verbose = false,
    ValueSetter<bool>? onVerbose,
  }) => ListenableBuilder(
    listenable: widget.source,
    builder: (context, _) {
      final Set<LogLevel> levels = recording == null
          ? _levels
          : _levels.where((e) => e.isAtLeast(recording)).toSet();
      final List<LogEntry> filtered = widget.source.entries.reversed
          .where((e) => levels.contains(e.level))
          .toList();
      final int? head = _head;
      List<LogEntry> items = head == null
          ? filtered
          : filtered.where((e) => (e.id ?? head) <= head).toList();
      if (items.isEmpty) items = filtered;
      final DateTime? date = widget.source.date;
      return SelectionLayout<LogEntry>(
        items: items,
        child: Expandables(
          child: Scaffold(
            appBar: LogSelectionAppBar(
              child: DefaultAppBar(
                title: Text(
                  date != null
                      ? AppLocalizations.of(
                          context,
                        ).logsTitleDate(DateFormatting.date(date))
                      : AppLocalizations.of(context).logsTitle,
                ),
                actions: [
                  if (widget.onShowAll != null)
                    IconButton(
                      icon: const Icon(Icons.folder),
                      onPressed: widget.onShowAll,
                    ),
                  const ContextDrawerButton(),
                ],
              ),
            ),
            body: LimitedWidthLayout.builder(
              maxWidth: 1200,
              builder: (context) => CustomScrollView(
                controller: _scrollController,
                reverse: true,
                slivers: [
                  SliverPadding(
                    padding: LimitedWidthLayout.of(
                      context,
                    ).padding.add(defaultActionListPadding),
                    sliver: PagedSliverList<int, LogEntry>(
                      state: PagingState(
                        pages: items.isEmpty ? null : [items],
                        keys: items.isEmpty ? null : const [0],
                        hasNextPage: widget.source.hasEarlier,
                        isLoading:
                            widget.source.loading ||
                            widget.source.loadingEarlier,
                      ),
                      fetchNextPage: widget.source.loadEarlier,
                      builderDelegate:
                          defaultPagedChildBuilderDelegate<LogEntry>(
                            itemBuilder: (context, item, index) =>
                                SelectionRowOverlay<LogEntry>(
                                  key: ValueKey(item.id ?? item),
                                  item: item,
                                  child: LogEntryTile(item: item),
                                ),
                            onEmpty: Text(AppLocalizations.of(context).noLogs),
                            onError: Text(
                              AppLocalizations.of(context).failedToReadLog,
                            ),
                          ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: items.isEmpty
                ? null
                : FloatingActionButton(
                    onPressed: () => Share.asFile(
                      context,
                      items.map((e) => jsonEncode(e.toJson())).join('\n'),
                      '${logFileDateFormat.format(DateTime.now())}$logFileExtension',
                    ),
                    child: const Icon(Icons.file_download),
                  ),
            endDrawer: LogsDrawer(
              levels: _levels,
              onChanged: (value) => setState(() => _levels = value),
              recording: recording,
              verbose: verbose,
              onVerbose: onVerbose,
            ),
          ),
        ),
      );
    },
  );
}
