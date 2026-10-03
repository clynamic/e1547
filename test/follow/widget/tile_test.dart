import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notified_preferences/notified_preferences.dart';
import 'package:provider/provider.dart';

import '../../_support/harness.dart';
import '../../_support/images.dart';

Follow sampleFollow({String? thumbnail, int? latest}) => Follow(
  id: 1,
  tags: 'canine',
  title: null,
  alias: null,
  type: FollowType.bookmark,
  latest: latest,
  unseen: 0,
  thumbnail: thumbnail,
  updated: null,
);

void main() {
  late Client client;
  late ValueNotifier<Traits> traits;
  late AppDatabase sqlite;

  setUpAll(() async {
    await initializeTestApp();
    sqlite = AppDatabase(NativeDatabase.memory());
  });

  tearDownAll(() => sqlite.close());

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    traits = ValueNotifier(
      const Traits(
        id: 1,
        userId: null,
        denylist: [],
        homeTags: '',
        avatar: null,
        perPage: null,
      ),
    );
    client = Client(
      identity: const Identity(
        id: 1,
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
  });

  tearDown(() => traits.dispose());

  Future<void> show(WidgetTester tester, Follow follow) => tester.pumpWidget(
    MultiProvider(
      providers: [
        Provider<Client>.value(value: client),
        Provider<BaseCacheManager>.value(value: const NoImageCacheManager()),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(
            child: SizedBox(width: 200, child: FollowTile(follow: follow)),
          ),
        ),
      ),
    ),
  );

  group('FollowTile', () {
    displayTest('shows a placeholder icon without a thumbnail', (tester) async {
      await show(tester, sampleFollow(latest: 10));

      expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
    });

    displayTest('shows the thumbnail when it has one', (tester) async {
      await show(tester, sampleFollow(latest: 10, thumbnail: '/preview/10'));

      expect(find.byIcon(Icons.image_not_supported_outlined), findsNothing);
      expect(find.byType(Hero), findsOneWidget);
    });
  });
}
