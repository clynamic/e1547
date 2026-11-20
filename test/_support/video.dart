import 'dart:async';

import 'package:e1547/shared/shared.dart';
import 'package:media_kit/media_kit.dart';

class FakePlatformPlayer extends PlatformPlayer {
  FakePlatformPlayer() : super(configuration: const PlayerConfiguration());

  void _setPlaying(bool playing) {
    state = state.copyWith(playing: playing);
    playingController.add(playing);
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
  Future<void> seek(Duration duration) async =>
      state = state.copyWith(position: duration);

  @override
  Future<void> setPlaylistMode(PlaylistMode playlistMode) async {}

  @override
  Future<void> setVolume(double volume) async {}
}

VideoService fakeVideoService() => VideoService(
  createPlayer: () => VideoPlayer(platformPlayer: FakePlatformPlayer()),
);
