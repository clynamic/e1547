import 'package:e1547/query/query.dart';
import 'package:e1547/settings/settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pub_semver/pub_semver.dart';

class ReleasedVersionsClient extends AppInfoClient {
  ReleasedVersionsClient(this.released)
    : super(queryCache: CachedQuery.asNewInstance());

  final List<AppVersion> released;

  @override
  Future<List<AppVersion>> getVersions() async => released;
}

void main() {
  void install(Source source) => AppInfo.initializeMock(
    developer: 'tester',
    github: null,
    discord: null,
    website: null,
    kofi: null,
    email: null,
    forumTopicId: null,
    appName: 'e1547',
    packageName: 'net.clynamic.e1547',
    version: '1.0.0',
    buildNumber: '1',
    source: source,
  );

  ReleasedVersionsClient released() {
    final DateTime now = DateTime.now();
    return ReleasedVersionsClient([
      AppVersion(
        version: Version.parse('1.2.0+3'),
        date: now.subtract(const Duration(days: 2)),
      ),
      AppVersion(
        version: Version.parse('1.1.0+2'),
        date: now.subtract(const Duration(days: 10)),
      ),
    ]);
  }

  test(
    'offers store installs only versions released over a week ago',
    () async {
      install(Source.IS_INSTALLED_FROM_PLAY_STORE);

      final List<AppVersion> offered = await released().getNewVersions();

      expect(offered.map((e) => e.version.toString()), ['1.1.0+2']);
    },
  );

  test('offers other installs every newer version', () async {
    install(Source.IS_INSTALLED_FROM_OTHER_SOURCE);

    final List<AppVersion> offered = await released().getNewVersions();

    expect(offered.map((e) => e.version.toString()), ['1.2.0+3', '1.1.0+2']);
  });
}
