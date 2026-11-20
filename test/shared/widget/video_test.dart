import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notified_preferences/notified_preferences.dart';

void main() {
  testWidgets('mutes videos as soon as the setting is turned on', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'muteVideos': false});
    final Settings settings = Settings(await SharedPreferences.getInstance());
    late VideoService videos;

    await tester.pumpWidget(
      Provider<Settings>.value(
        value: settings,
        child: VideoServiceProvider(
          child: Builder(
            builder: (context) {
              videos = context.watch<VideoService>();
              return const SizedBox();
            },
          ),
        ),
      ),
    );
    expect(videos.muteVideos, isFalse);

    settings.muteVideos.value = true;
    await tester.pump();

    expect(videos.muteVideos, isTrue);
  });
}
