import 'dart:async';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/logs/logs.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:rxdart/rxdart.dart';

export 'package:media_kit_video/media_kit_video.dart';

class VideoPlayer extends Player {
  VideoPlayer({super.platformPlayer}) {
    _subscriptions.addAll([
      stream.videoParams.listen((event) {
        _hasParams = event.w != null && event.h != null;
        _update();
      }),
      stream.error.listen((_) {
        _failed = true;
        _update();
      }),
    ]);
    unawaited(
      controller.waitUntilFirstFrameRendered
          .then((_) {
            _rendered = true;
            _update();
          })
          .catchError((_) {}),
    );
  }

  late final VideoController _controller = VideoController(this);
  VideoController get controller => _controller;

  final List<StreamSubscription> _subscriptions = [];

  final BehaviorSubject<bool> _initialized = BehaviorSubject.seeded(false);
  Stream<bool> get initialized => _initialized.stream;

  bool get isInitialized => _initialized.value;

  bool _rendered = false;
  bool _hasParams = false;
  bool _failed = false;

  String? _media;
  String? get media => _media;

  int _leases = 0;

  bool get isLeased => _leases > 0;

  void _update() {
    if (_initialized.isClosed) return;
    bool value = _failed || (_rendered && _hasParams);
    if (_initialized.value == value) return;
    _initialized.add(value);
  }

  Future<void> load(String media) async {
    _media = media;
    _failed = false;
    _hasParams = false;
    _update();
    await open(Media(media), play: false);
  }

  Future<void> unload() async {
    _media = null;
    _failed = false;
    _hasParams = false;
    _update();
    await stop();
  }

  @override
  Future<void> dispose() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    await _initialized.close();
    await super.dispose();
  }
}

class VideoService extends ChangeNotifier {
  VideoService({bool muteVideos = false, VideoPlayer Function()? createPlayer})
    : _muteVideos = muteVideos,
      _createPlayer = createPlayer ?? VideoPlayer.new;

  static void ensureInitialized() => MediaKit.ensureInitialized();

  // To prevent the app from crashing due tue OutOfMemoryErrors,
  // the list of all loaded videos is global.
  static final Map<String, VideoPlayer> _videos = {};

  // Disposing a Player closes the mpv wakeup callback,
  // which mpv can still invoke afterwards, aborting the process.
  static final List<VideoPlayer> _idle = [];

  final Logger _logger = Logger('Videos');

  final int maxLoaded = 3;

  final VideoPlayer Function() _createPlayer;

  bool _muteVideos;

  bool get muteVideos => _muteVideos;

  set muteVideos(bool value) {
    _muteVideos = value;
    _videos.values.forEach((e) => e.setVolume(muteVideos ? 0 : 100));
    notifyListeners();
    _logger.debug('Videos muted: {muted}', {'muted': _muteVideos});
  }

  VideoPlayer? getVideo(String key) {
    // Re-inserting moves the key to the back of the map,
    // so that eviction walks from least to most recently used.
    VideoPlayer? player = _videos.remove(key);
    if (player != null) return _videos[key] = player;
    while (_videos.length >= maxLoaded) {
      String? spare;
      for (final MapEntry(:key, :value) in _videos.entries) {
        if (value.isLeased) continue;
        spare = key;
        break;
      }
      if (spare == null) break;
      _logger.debug('Evicting {spare}, {loaded} of {max} videos loaded', {
        'spare': spare,
        'loaded': _videos.length,
        'max': maxLoaded,
      });
      unloadVideo(spare);
    }
    if (_videos.length >= maxLoaded && _idle.isEmpty) {
      // Every player is leased and none can be evicted. Creating
      // another one would grow the pool past maxLoaded forever,
      // since players are never disposed (see above). Return no
      // player instead; callers show a placeholder and retry once
      // VideoService notifies them of a released lease.
      _logger.debug('Refusing {video}, all {max} videos in use', {
        'video': key,
        'max': maxLoaded,
      });
      return null;
    }
    player = _idle.isNotEmpty ? _idle.removeAt(0) : _createPlayer();
    _videos[key] = player;
    player.setPlaylistMode(PlaylistMode.single);
    player.setVolume(_muteVideos ? 0 : 100);
    // TODO: this is missing client auth headers
    player.load(key);
    _logger.debug('Loaded {video}', {'video': key});
    return player;
  }

  /// Keeps the player out of recycling until a matching [release].
  void acquire(VideoPlayer player) => player._leases++;

  void release(VideoPlayer player) {
    if (player._leases == 0) return;
    player._leases--;
    // Lets widgets that were refused a player in getVideo retry once
    // this build is over, now that this player can be evicted for them.
    // Deferred: notifyListeners here could mark a widget that is
    // currently building as needing rebuild, which asserts.
    scheduleMicrotask(notifyListeners);
  }

  void unloadVideo(String key) {
    VideoPlayer? player = _videos.remove(key);
    if (player == null) return;
    _idle.add(player);
    player.unload();
    _logger.debug('Unloaded {video}', {'video': key});
  }
}

class VideoServiceProvider
    extends SubChangeNotifierProvider<Settings, VideoService> {
  VideoServiceProvider({super.child, super.builder})
    : super(
        create: (context, settings) =>
            VideoService(muteVideos: settings.muteVideos.value),
      );
}

class VideoServiceVolumeControl extends StatelessWidget {
  const VideoServiceVolumeControl({super.key});

  @override
  Widget build(BuildContext context) {
    VideoService service = context.watch<VideoService>();
    bool muted = service.muteVideos;
    return InkWell(
      onTap: () => service.muteVideos = !muted,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(
          muted ? Icons.volume_off : Icons.volume_up,
          size: 24,
          color: Colors.white,
        ),
      ),
    );
  }
}

enum VideoResolution {
  standard,
  high,
  full,
  ultra,
  source;

  String get title => switch (this) {
    VideoResolution.standard => 'Standard (480p)',
    VideoResolution.high => 'High (720p)',
    VideoResolution.full => 'Full (1080p)',
    VideoResolution.ultra => 'Ultra (4K)',
    VideoResolution.source => 'Source',
  };

  /// Localized display name for pickers.
  String localizedTitle(BuildContext context) => switch (this) {
    VideoResolution.standard => AppLocalizations.of(context).videoResStandard,
    VideoResolution.high => AppLocalizations.of(context).videoResHigh,
    VideoResolution.full => AppLocalizations.of(context).videoResFull,
    VideoResolution.ultra => AppLocalizations.of(context).videoResUltra,
    VideoResolution.source => AppLocalizations.of(context).videoResSource,
  };

  int get pixels => switch (this) {
    VideoResolution.standard => 640 * 480,
    VideoResolution.high => 1280 * 720,
    VideoResolution.full => 1920 * 1080,
    VideoResolution.ultra => 3840 * 2160,
    VideoResolution.source => 4096 * 2160,
  };
}
