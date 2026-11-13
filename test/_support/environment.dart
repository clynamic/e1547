import 'package:dio/dio.dart';
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

class TestEnvironment {
  TestEnvironment._({
    required this.fake,
    required this.sqlite,
    required this.traits,
    required this.settings,
  });

  int _inFlight = 0;

  final AnyRouteObserver routeObserver = AnyRouteObserver();
  final VideoService videos = fakeVideoService();

  final FakeE621 fake;
  final AppDatabase sqlite;
  final ValueNotifier<Traits> traits;
  late Client client;
  final Settings settings;

  static Future<TestEnvironment> start({
    List<String> denylist = const [],
  }) async {
    SharedPreferences.setMockInitialValues({});
    final AppDatabase sqlite = AppDatabase(NativeDatabase.memory());
    final FakeE621 fake = await FakeE621.start();
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
    final TestEnvironment env = TestEnvironment._(
      fake: fake,
      sqlite: sqlite,
      traits: traits,
      settings: Settings(await SharedPreferences.getInstance()),
    );
    await env._connect();
    return env;
  }

  Future<void> _connect() async {
    client = Client(
      identity: await IdentityRepository(
        sqlite,
      ).add(IdentityRequest(host: fake.url)),
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
    client.dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _inFlight++;
          handler.next(options);
        },
        onResponse: (response, handler) {
          _inFlight--;
          handler.next(response);
        },
        onError: (error, handler) {
          _inFlight--;
          handler.next(error);
        },
      ),
    );
  }

  Future<void> settle(WidgetTester tester, {bool animating = false}) async {
    await tester.runAsync(() async {
      for (int round = 0; round < 100; round++) {
        await tester.pump(const Duration(milliseconds: 50));
        await Future<void>.delayed(const Duration(milliseconds: 50));
        if (round >= 5 && _inFlight == 0) break;
      }
    });
    if (animating) {
      await tester.pump(const Duration(milliseconds: 300));
    } else {
      await tester.pumpAndSettle();
    }
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
