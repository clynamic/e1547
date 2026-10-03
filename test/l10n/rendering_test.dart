import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/onboarding/onboarding.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notified_preferences/notified_preferences.dart';
import 'package:provider/provider.dart';
import 'package:relative_time/relative_time.dart';

import '../_support/fake_e621.dart';
import '../_support/harness.dart';
import '../_support/images.dart';

/// Renders localized pages under a chinese [Locale] and asserts their
/// localized strings against the values of the app arb files.
///
/// English originals are asserted to be absent, so untranslated strings cannot
/// leak through silently.
void main() {
  late FakeE621 fake;
  late Client client;
  late ValueNotifier<Traits> traits;
  late AppDatabase sqlite;
  late Settings settings;
  late IdentityClient identities;
  late TraitsClient identityTraits;

  setUpAll(() => initializeTestApp());

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    sqlite = AppDatabase(NativeDatabase.memory());
    fake = await FakeE621.start();
    identities = IdentityClient(database: sqlite);
    final identity = await identities.add(IdentityRequest(host: fake.url));
    await identities.activate(identity.id);
    identityTraits = TraitsClient(database: sqlite);
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
      identity: Identity(id: 1, host: fake.url, username: null, headers: null),
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
    // The fake clock would otherwise leave dio's timeout timers pending
    // on requests that are still in flight when the test ends.
    client.dio.options.connectTimeout = null;
    client.dio.options.receiveTimeout = null;
    settings = Settings(await SharedPreferences.getInstance());
  });

  tearDown(() async {
    traits.dispose();
    identities.dispose();
    identityTraits.dispose();
    client.dispose();
    await fake.stop();
    await sqlite.close();
  });

  /// Gives the page a surface tall enough for all of its tiles.
  void tallSurface(WidgetTester tester, {Size size = const Size(800, 3600)}) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  /// Pumps [home] under the providers the app pages expect, in [locale].
  ///
  /// With [wait], real async work like database streams and requests is given
  /// time to land before the next frame.
  Future<void> pumpApp(
    WidgetTester tester, {
    required Locale locale,
    Widget? home,
    bool wait = true,
    bool pump = true,
  }) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<Client>.value(value: client),
            Provider<Settings>.value(value: settings),
            ChangeNotifierProvider<IdentityClient>.value(value: identities),
            ChangeNotifierProvider<TraitsClient>.value(value: identityTraits),
            Provider<BaseCacheManager>.value(
              value: const NoImageCacheManager(),
            ),
          ],
          child: MaterialApp(
            locale: locale,
            localizationsDelegates: const [
              ...AppLocalizations.localizationsDelegates,
              GlobalCupertinoLocalizations.delegate,
              RelativeTimeLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: home,
          ),
        ),
      );
      if (wait) {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
    });
    if (pump) {
      await tester.pump();
    }
  }

  /// Lets requests and animations started by an interaction land.
  Future<void> settle(WidgetTester tester) async {
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await tester.pump();
  }

  /// Closes the bottom sheet a prompt opened.
  ///
  /// Persistent bottom sheets are local history entries, so popping the
  /// navigator removes them.
  Future<void> popSheet(WidgetTester tester) async {
    tester.state<NavigatorState>(find.byType(Navigator).first).pop();
    await tester.pumpAndSettle();
  }

  displayTest('the settings page renders its tiles in chinese', (tester) async {
    traits.value = traits.value.copyWith(denylist: ['wolf']);
    tallSurface(tester);
    await pumpApp(
      tester,
      locale: const Locale('zh'),
      home: const SettingsPage(),
    );

    expect(find.text('设置'), findsOneWidget);
    for (final title in ['账户', '用户', '外观', '交互', '安全', '开发']) {
      expect(find.text(title), findsOneWidget, reason: title);
    }
    for (final title in [
      '黑名单',
      '关注',
      '历史',
      '主题',
      '语言',
      '格子大小',
      '帖子信息',
      '下载位置',
      '收藏时点赞',
      '视频音量',
      '视频分辨率',
      'PIN 锁',
      '生物识别锁',
      '布局',
    ]) {
      expect(find.text(title), findsOneWidget, reason: title);
    }

    // the identity tile
    expect(find.text('匿名'), findsOneWidget);

    // subtitles follow the default settings
    expect(find.text('深色'), findsOneWidget);
    expect(find.text('跟随系统'), findsOneWidget);
    expect(find.text('已屏蔽 1 个标签'), findsOneWidget);
    expect(find.text('仅显示图片'), findsOneWidget);
    expect(find.text('仅收藏'), findsOneWidget);
    expect(find.text('静音'), findsOneWidget);
    expect(find.text('原始画质'), findsOneWidget);
    expect(find.text('PIN 已禁用'), findsOneWidget);
    expect(find.text('生物识别已禁用'), findsOneWidget);
    expect(find.text('方形格子'), findsOneWidget);

    // no english leaks through
    for (final leak in [
      'Settings',
      'Account',
      'User',
      'Appearance',
      'Interactions',
      'Security',
      'Development',
      'Blacklist',
      'Follows',
      'History',
      'Theme',
      'Language',
      'Tile size',
      'Post info',
      'Download location',
      'Upvote favorites',
      'Video volume',
      'Video resolution',
      'PIN lock',
      'Biometric lock',
      'Quilt',
      'Anonymous',
      'dark',
      'system',
    ]) {
      expect(find.text(leak), findsNothing, reason: leak);
    }
  });

  displayTest(
    'the settings page renders its theme and language dialogs in chinese',
    (tester) async {
      tallSurface(tester);
      await pumpApp(
        tester,
        locale: const Locale('zh'),
        home: const SettingsPage(),
      );

      await tester.tap(find.text('主题').first);
      await tester.pumpAndSettle();

      // the theme tile's subtitle shows the current theme, so it appears twice
      expect(find.text('深色'), findsNWidgets(2));
      expect(find.text('纯黑'), findsOneWidget);
      expect(find.text('浅色'), findsOneWidget);
      expect(find.text('蓝色'), findsOneWidget);
      // the language tile's subtitle collides with the system theme name
      expect(find.text('跟随系统'), findsNWidgets(2));
      expect(find.text('Theme'), findsNothing);

      await tester.tapAt(const Offset(400, 20));
      await tester.pumpAndSettle();

      await tester.tap(find.text('语言').first);
      await tester.pumpAndSettle();

      // the tile subtitle collides with the system default entry
      expect(find.text('跟随系统'), findsNWidgets(2));
      // language names stay in their own language by design
      expect(find.text('English'), findsOneWidget);
      expect(find.text('简体中文'), findsOneWidget);
      expect(find.text('繁體中文'), findsOneWidget);
      expect(find.text('Language'), findsNothing);
    },
  );

  displayTest('the settings page renders in traditional chinese', (
    tester,
  ) async {
    traits.value = traits.value.copyWith(denylist: ['wolf']);
    tallSurface(tester);
    await pumpApp(
      tester,
      locale: const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
      home: const SettingsPage(),
    );

    expect(find.text('設定'), findsOneWidget);
    for (final title in ['帳戶', '使用者', '外觀', '互動', '安全性', '開發']) {
      expect(find.text(title), findsOneWidget, reason: title);
    }
    for (final title in [
      '黑名單',
      '追蹤',
      '歷史',
      '主題',
      '語言',
      '格子大小',
      '貼文資訊',
      '下載位置',
      '收藏時按讚',
      '影片音量',
      '影片解析度',
      'PIN 鎖',
      '生物辨識鎖',
      '版面',
    ]) {
      expect(find.text(title), findsOneWidget, reason: title);
    }

    expect(find.text('匿名'), findsOneWidget);
    expect(find.text('深色'), findsOneWidget);
    expect(find.text('跟隨系統'), findsOneWidget);
    expect(find.text('已封鎖 1 個標籤'), findsOneWidget);
    expect(find.text('僅顯示圖片'), findsOneWidget);
    expect(find.text('僅收藏'), findsOneWidget);
    expect(find.text('靜音'), findsOneWidget);
    expect(find.text('原始畫質'), findsOneWidget);
    expect(find.text('PIN 已停用'), findsOneWidget);
    expect(find.text('生物辨識已停用'), findsOneWidget);
    expect(find.text('方形格子'), findsOneWidget);

    // the theme tile name was reworded for traditional chinese
    expect(find.text('佈景主題'), findsNothing);
    // no english leaks through
    for (final leak in ['Settings', 'Theme', 'Blacklist', 'Anonymous']) {
      expect(find.text(leak), findsNothing, reason: leak);
    }
  });

  displayTest('the denylist page renders in chinese', (tester) async {
    await pumpApp(
      tester,
      locale: const Locale('zh'),
      home: const DenyListPage(),
    );

    expect(find.text('黑名单'), findsOneWidget);

    // an entry
    traits.value = traits.value.copyWith(denylist: ['wolf']);
    await tester.pump();
    expect(find.text('wolf'), findsOneWidget);
    expect(find.text('你的黑名单为空'), findsNothing);

    // its popup menu
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    expect(find.text('编辑'), findsOneWidget);
    expect(find.text('删除'), findsOneWidget);
    expect(find.text('Edit'), findsNothing);
    expect(find.text('Delete'), findsNothing);

    // the edit prompt
    await tester.tap(find.text('编辑').last);
    await tester.pumpAndSettle();
    expect(find.text('编辑标签'), findsOneWidget);
    await popSheet(tester);

    // the empty state
    traits.value = traits.value.copyWith(denylist: []);
    await tester.pump();
    expect(find.text('你的黑名单为空'), findsOneWidget);
    expect(find.text('wolf'), findsNothing);

    // the add prompt
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('添加标签'), findsOneWidget);
    expect(find.text('Add tag'), findsNothing);
  });

  displayTest(
    'the denylist page renders its empty state in traditional chinese',
    (tester) async {
      await pumpApp(
        tester,
        locale: const Locale.fromSubtags(
          languageCode: 'zh',
          scriptCode: 'Hant',
        ),
        home: const DenyListPage(),
      );

      expect(find.text('黑名單'), findsOneWidget);
      expect(find.text('你的黑名單是空的'), findsOneWidget);
      expect(find.text('Your blacklist is empty'), findsNothing);
    },
  );

  displayTest(
    'a post loading page renders its empty and error states in chinese',
    (tester) async {
      await pumpApp(
        tester,
        locale: const Locale('zh'),
        home: const PostLoadingPage(999999),
        wait: false,
        pump: false,
      );

      // the request has not landed yet, so the page starts out "empty"
      expect(find.text('找不到帖子'), findsOneWidget);

      // a missing post turns the page into its error state
      await settle(tester);
      expect(find.text('帖子加载失败'), findsOneWidget);
      expect(find.text('Failed to load post'), findsNothing);
      expect(find.text('Post not found'), findsNothing);
    },
  );

  displayTest(
    'a post loading page renders its error state in traditional chinese',
    (tester) async {
      await pumpApp(
        tester,
        locale: const Locale.fromSubtags(
          languageCode: 'zh',
          scriptCode: 'Hant',
        ),
        home: const PostLoadingPage(999999),
      );

      expect(find.text('貼文載入失敗'), findsOneWidget);
      expect(find.text('找不到貼文'), findsNothing);
      expect(find.text('Failed to load post'), findsNothing);
    },
  );

  displayTest('the onboarding flow renders in chinese', (tester) async {
    await pumpApp(
      tester,
      locale: const Locale('zh'),
      home: const OnboardingScreen(),
    );

    // the first step offers languages
    expect(find.text('选择语言'), findsOneWidget);
    expect(find.text('跟随系统'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('简体中文'), findsOneWidget);
    expect(find.text('繁體中文'), findsOneWidget);
    expect(find.text('跳过'), findsOneWidget);
    expect(find.text('下一步'), findsOneWidget);
    expect(find.text('上一步'), findsNothing);
    expect(find.text('Choose a language'), findsNothing);
    expect(find.text('System default'), findsNothing);

    await tester.tap(find.text('下一步'));
    await tester.pumpAndSettle();

    // the second step welcomes
    expect(find.text('欢迎使用 e1547'), findsOneWidget);
    expect(find.text('一款精致的 booru 浏览器。'), findsOneWidget);
    expect(find.text('上一步'), findsOneWidget);
    expect(find.text('Welcome to e1547'), findsNothing);

    await tester.tap(find.text('下一步'));
    await tester.pumpAndSettle();

    // the third step offers themes
    expect(find.text('选个外观'), findsOneWidget);
    expect(find.text('先试试看。以后随时可以更换。'), findsOneWidget);
    expect(find.text('深色'), findsOneWidget);
    expect(find.text('纯黑'), findsOneWidget);
    expect(find.text('浅色'), findsOneWidget);
    expect(find.text('蓝色'), findsOneWidget);
    expect(find.text('跟随系统'), findsOneWidget);
    expect(find.text('Pick a look'), findsNothing);

    await tester.tap(find.text('下一步'));
    await tester.pumpAndSettle();

    // the fourth step connects an account
    expect(find.text('连接账户'), findsOneWidget);
    expect(find.text('站点'), findsOneWidget);
    expect(find.text('登录'), findsOneWidget);
    expect(find.text('访客'), findsOneWidget);
    // the last page hides the next button
    expect(find.text('下一步'), findsNothing);
    expect(find.text('Connect an account'), findsNothing);
    expect(find.text('Skip'), findsNothing);
  });

  displayTest('the posts filter renders in chinese', (tester) async {
    tallSurface(tester, size: const Size(800, 1600));
    await pumpApp(
      tester,
      locale: const Locale('zh'),
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: FilterList(
              tags: TagMap(''),
              onChanged: (_) {},
              filters: [PostParams.tagsFilter],
            ),
          ),
        ),
      ),
    );

    // filter labels
    for (final label in [
      '评分',
      '收藏数',
      '排序方式',
      '分级',
      '上传日期',
      '状态',
      '文件类型',
      '上传者',
      '宽度',
      '高度',
      '标签数',
    ]) {
      expect(find.text(label), findsOneWidget, reason: label);
    }
    // checkbox labels and descriptions
    for (final label in ['图集', '含图集', '子帖', '是子帖', '父帖', '是父帖']) {
      expect(find.text(label), findsOneWidget, reason: label);
    }
    // the order and status dropdowns show their default values,
    // as do the rating, upload date and file type dropdowns
    expect(find.text('默认'), findsNWidgets(2));
    expect(find.text('全部'), findsNWidgets(3));
    expect(find.text('Sort by'), findsNothing);
    expect(find.text('Rating'), findsNothing);

    // the sort dropdown's options
    await tester.tap(find.byIcon(Icons.sort));
    await tester.pumpAndSettle();
    expect(find.text('最新'), findsOneWidget);
    expect(find.text('最旧优先'), findsOneWidget);
    expect(find.text('收藏'), findsOneWidget);
    expect(find.text('排名'), findsOneWidget);
    expect(find.text('随机'), findsOneWidget);
    // the menu repeats the current value and the score label
    expect(find.text('默认'), findsNWidgets(3));
    expect(find.text('评分'), findsNWidgets(2));

    await tester.tap(find.text('随机').last);
    await tester.pumpAndSettle();

    // the rating dropdown's options
    await tester.tap(find.byIcon(Icons.question_mark));
    await tester.pumpAndSettle();
    expect(find.text('安全'), findsOneWidget);
    expect(find.text('存疑'), findsOneWidget);
    expect(find.text('露骨'), findsOneWidget);
    // the menu repeats the current value
    expect(find.text('全部'), findsNWidgets(4));

    await tester.tap(find.text('露骨').last);
    await tester.pumpAndSettle();

    // the file type dropdown's categories are translated
    await tester.tap(find.byIcon(Icons.image));
    await tester.pumpAndSettle();
    expect(find.text('图片'), findsOneWidget);
    expect(find.text('视频'), findsOneWidget);

    await tester.tap(find.text('视频').last);
    await tester.pumpAndSettle();

    // the picked options stick
    expect(find.text('随机'), findsOneWidget);
    expect(find.text('露骨'), findsOneWidget);
    expect(find.text('默认'), findsOneWidget);
    expect(find.text('全部'), findsOneWidget);
    expect(find.text('视频'), findsOneWidget);
  });
}
