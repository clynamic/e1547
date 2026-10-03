import 'dart:async';

import 'package:e1547/shared/shared.dart';
import 'package:media_kit/media_kit.dart';

class FakePlatformPlayer extends PlatformPlayer {
  FakePlatformPlayer() : super(configuration: const PlayerConfiguration());

  /// Durations passed to [seek], in call order.
  final List<Duration> seeks = [];

  void _setPlaying(bool playing) {
    state = state.copyWith(playing: playing);
    playingController.add(playing);
  }

  /// Simulates the native player reporting a total duration.
  void setDuration(Duration value) {
    state = state.copyWith(duration: value);
    durationController.add(value);
  }

  /// Simulates the native player reporting the playback position.
  void setPosition(Duration value) {
    state = state.copyWith(position: value);
    positionController.add(value);
  }

  /// Simulates the native player reporting the buffered range.
  void setBuffer(Duration value) {
    state = state.copyWith(buffer: value);
    bufferController.add(value);
  }

  /// Simulates the native player reaching the end of the stream.
  void complete() {
    state = state.copyWith(completed: true);
    completedController.add(true);
  }

  // We have no ref to a native player so we pretend it never arrives
  @override
  Future<int> get handle => Completer<int>().future;

  @override
  Future<void> open(Playable playable, {bool play = true}) async =>
      _setPlaying(play);

  @override
  Future<void> stop() async => _setPlaying(false);

  @override
  Future<void> play() async => _setPlaying(true);

  @override
  Future<void> pause() async => _setPlaying(false);

  @override
  Future<void> seek(Duration position) async => seeks.add(position);

  @override
  Future<void> setPlaylistMode(PlaylistMode playlistMode) async {}

  @override
  Future<void> setVolume(double volume) async {}
}

VideoService fakeVideoService() => VideoService(
  createPlayer: () => VideoPlayer(platformPlayer: FakePlatformPlayer()),
);
