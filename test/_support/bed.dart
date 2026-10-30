import 'dart:io';

import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notified_preferences/notified_preferences.dart';
import 'package:provider/single_child_widget.dart';

import 'fake_e621.dart';
import 'harness.dart';
import 'images.dart';
import 'video.dart';

class TestBed {
  TestBed._({
    required this.fake,
    required this.sqlite,
    required this.traits,
    required this.settings,
  });

  final AnyRouteObserver routeObserver = AnyRouteObserver();
  final VideoService videos = fakeVideoService();

  final FakeE621 fake;
  final AppDatabase sqlite;
  final ValueNotifier<Traits> traits;
  late Client client;
  final Settings settings;

  static Future<TestBed> start({
    String? username,
    bool signedIn = false,
    List<String> denylist = const [],
    FakeE621State? state,
  }) async {
    SharedPreferences.setMockInitialValues({});
    final AppDatabase sqlite = AppDatabase(NativeDatabase.memory());
    final FakeE621 fake = await FakeE621.start(state: state);
    final ValueNotifier<Traits> traits = ValueNotifier(
      Traits(
        id: 1,
        userId: null,
        denylist: denylist,
        homeTags: '',
        avatar: null,
        perPage: null,
      ),
    );
    final TestBed bed = TestBed._(
      fake: fake,
      sqlite: sqlite,
      traits: traits,
      settings: Settings(await SharedPreferences.getInstance()),
    );
    await bed.signIn(username: username, credentials: signedIn);
    return bed;
  }

  Future<void> signIn({String? username, bool credentials = false}) async {
    final String? name = username ?? (credentials ? 'tester' : null);
    client = Client(
      identity: await IdentityRepository(sqlite).add(
        IdentityRequest(
          host: fake.url,
          username: name,
          headers: credentials
              ? {
                  HttpHeaders.authorizationHeader: Credentials(
                    username: name!,
                    password: 'key',
                  ).basicAuth,
                }
              : null,
        ),
      ),
      traits: traits,
      storage: AppStorage(
        preferences: await SharedPreferences.getInstance(),
        temporaryFiles: '.',
        queryCache: CachedQuery.asNewInstance()
          ..config(
            config: const GlobalQueryConfig(
              cacheDuration: Duration(milliseconds: 1),
            ),
          ),
        sqlite: sqlite,
      ),
    );
  }

  Widget app(
    Widget home, {
    ThemeData? theme,
    List<SingleChildWidget> providers = const [],
  }) => MultiProvider(
    providers: [
      Provider<Client>.value(value: client),
      Provider<Settings>.value(value: settings),
      Provider<BaseCacheManager>.value(value: const NoImageCacheManager()),
      Provider<AnyRouteObserver>.value(value: routeObserver),
      ChangeNotifierProvider<VideoService>.value(value: videos),
      ...providers,
    ],
    child: MaterialApp(
      theme: theme,
      navigatorObservers: [routeObserver],
      localizationsDelegates: testLocalizations,
      home: home,
    ),
  );

  Future<void> dispose() async {
    videos.dispose();
    traits.dispose();
    await fake.stop();
    await sqlite.close();
  }
}

Future<void> settle(WidgetTester tester, {bool animating = false}) async {
  await tester.runAsync(() async {
    for (int i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 50));
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
  });
  if (animating) {
    await tester.pump(const Duration(milliseconds: 300));
  } else {
    await tester.pumpAndSettle();
  }
}
