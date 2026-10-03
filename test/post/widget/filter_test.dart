import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notified_preferences/notified_preferences.dart';
import 'package:provider/provider.dart';

import '../../_support/fake_e621.dart';
import '../../_support/harness.dart';
import '../../_support/images.dart';

void main() {
  late FakeE621 fake;
  late Client client;
  late ValueNotifier<Traits> traits;
  late AppDatabase sqlite;
  late Settings settings;

  setUpAll(() async {
    await initializeTestApp();
    sqlite = AppDatabase(NativeDatabase.memory());
  });

  tearDownAll(() => sqlite.close());

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    fake = await FakeE621.start();
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
    await fake.stop();
  });

  /// The posts page query lands on the fake server, so requests have to
  /// settle while the test still owns the clock. The tall surface keeps the
  /// whole filter prompt on screen.
  Future<PostParamsController> pumpPage(
    WidgetTester tester, {
    Widget? home,
    Size size = const Size(800, 1600),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.runAsync(() async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<Client>.value(value: client),
            Provider<BaseCacheManager>.value(
              value: const NoImageCacheManager(),
            ),
            Provider<Settings>.value(value: settings),
          ],
          child: MaterialApp(
            locale: const Locale('zh'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: home ?? const PostsPage(),
          ),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await tester.pump();
    // Both the app bar button and the search button watch the page's
    // controller, so either hands it out.
    return tester
        .element(find.byType(PostsPageFab))
        .read<PostParamsController>();
  }

  /// Opens the filter prompt and lets its sheet settle.
  Future<void> openFilterPrompt(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.filter_list));
    await tester.pump();
    for (int i = 0; i < 12; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  /// Lets the requests a filter change started land before the test ends.
  Future<void> settle(WidgetTester tester) async {
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 400));
    });
    await tester.pump();
  }

  /// Picks [option] in the dropdown of the filter with [icon].
  ///
  /// The dropdown menu opens in its own route, below the prompt's, so its
  /// items are the last of their texts in the tree.
  Future<void> pickFilterOption(
    WidgetTester tester, {
    required IconData icon,
    required String option,
  }) async {
    await tester.tap(find.byIcon(icon));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(find.text(option).last);
    await tester.pump();
    // The panel applies filter changes debounced, so the pick has to
    // outlast the debounce before anything can observe it.
    await tester.pump(const Duration(milliseconds: 400));
  }

  Color? buttonColor(WidgetTester tester) =>
      tester.widget<Icon>(find.byIcon(Icons.filter_list)).color;

  Color primaryColor(WidgetTester tester) =>
      Theme.of(tester.element(find.byType(PostPageAppBar))).colorScheme.primary;

  /// The query the filter prompt previews.
  ///
  /// The app bar title can show the same words, so the preview is keyed.
  String queryPreview(WidgetTester tester) => tester
      .widget<Text>(find.byKey(const Key('PostsFilterPanel/Query')))
      .data!;

  displayTest('a posts page offers filters in its app bar', (tester) async {
    await pumpPage(tester);

    expect(find.byIcon(Icons.filter_list), findsOneWidget);
    expect(find.byIcon(Icons.tune), findsOneWidget);
    // The search button stays put, the app bar only adds to it.
    expect(find.byType(PostsPageFab), findsOneWidget);
    // Nothing filters an empty search.
    expect(buttonColor(tester), isNull);

    await openFilterPrompt(tester);

    expect(find.text('筛选'), findsOneWidget);
    expect(find.text('当前查询：'), findsOneWidget);
    expect(queryPreview(tester), '—');
    expect(find.text('评分'), findsOneWidget);
    expect(find.text('收藏数'), findsOneWidget);
    expect(find.text('排序方式'), findsOneWidget);
    expect(find.text('分级'), findsOneWidget);
    expect(find.text('含图集'), findsOneWidget);
    expect(find.text('是子帖'), findsOneWidget);
    expect(find.text('是父帖'), findsOneWidget);
    expect(find.text('上传日期'), findsOneWidget);
    expect(find.text('状态'), findsOneWidget);
    expect(find.text('文件类型'), findsOneWidget);
    expect(find.text('上传者'), findsOneWidget);
    expect(find.text('宽度'), findsOneWidget);
    expect(find.text('高度'), findsOneWidget);
    expect(find.text('标签数'), findsOneWidget);
  });

  displayTest('the home page offers filters in its app bar', (tester) async {
    await pumpPage(tester, home: const HomePage());

    expect(find.byIcon(Icons.filter_list), findsOneWidget);
    expect(find.byIcon(Icons.tune), findsOneWidget);
    expect(find.byType(PostsPageFab), findsOneWidget);
  });

  displayTest('the home page app bar icon stays centered', (tester) async {
    await pumpPage(tester, home: const HomePage());

    final Rect icon = tester.getRect(find.byType(AppIcon).first);
    // The 800 wide surface has its center at 400; an uncentered title
    // would sit left of it, behind the asymmetric action buttons.
    expect(icon.center.dx, moreOrLessEquals(400, epsilon: 0.5));
  });

  displayTest('the home page app bar icon stays centered on wide screens', (
    tester,
  ) async {
    // Wide, but below the 1200 breakpoint that swaps the drawer in beside
    // the body, which the bare test harness does not provide for.
    await pumpPage(tester, home: const HomePage(), size: const Size(1100, 800));

    final Rect icon = tester.getRect(find.byType(AppIcon).first);
    expect(icon.center.dx, moreOrLessEquals(550, epsilon: 0.5));
  });

  displayTest('filter changes apply to the search live', (tester) async {
    final controller = await pumpPage(tester);

    await openFilterPrompt(tester);
    await pickFilterOption(tester, icon: Icons.question_mark, option: '露骨');

    expect(controller.value.tags, 'rating:e');
    expect(queryPreview(tester), 'rating:e');
    expect(buttonColor(tester), primaryColor(tester));

    await pickFilterOption(tester, icon: Icons.question_mark, option: '全部');
    await settle(tester);

    expect(controller.value.tags, isNull);
    expect(queryPreview(tester), '—');
    expect(buttonColor(tester), isNull);
  });

  displayTest('filter changes carry bare tags over', (tester) async {
    final controller = await pumpPage(
      tester,
      home: const PostsPage(params: PostParams(tags: 'wolf')),
    );

    await openFilterPrompt(tester);
    expect(queryPreview(tester), 'wolf');
    await pickFilterOption(tester, icon: Icons.sort, option: '排名');

    expect(controller.value.tags, 'wolf order:rank');
    expect(queryPreview(tester), 'wolf order:rank');
    expect(buttonColor(tester), primaryColor(tester));

    await pickFilterOption(tester, icon: Icons.sort, option: '默认');
    await settle(tester);

    expect(controller.value.tags, 'wolf');
    expect(queryPreview(tester), 'wolf');
    expect(buttonColor(tester), isNull);
  });

  displayTest('the order filter offers an oldest order', (tester) async {
    final controller = await pumpPage(tester);

    await openFilterPrompt(tester);
    await pickFilterOption(tester, icon: Icons.sort, option: '最旧优先');

    expect(controller.value.tags, 'order:id_asc');
    expect(TagMap(controller.value.tags)['order'], 'id_asc');
    expect(queryPreview(tester), 'order:id_asc');
    expect(buttonColor(tester), primaryColor(tester));

    await pickFilterOption(tester, icon: Icons.sort, option: '默认');
    await settle(tester);

    expect(controller.value.tags, isNull);
    expect(queryPreview(tester), '—');
    expect(buttonColor(tester), isNull);
  });

  displayTest('filter edits keep repeated tokens of other filters', (
    tester,
  ) async {
    final controller = await pumpPage(
      tester,
      home: const PostsPage(
        params: PostParams(tags: '-type:webm -type:mp4 -type:swf'),
      ),
    );

    await openFilterPrompt(tester);
    await pickFilterOption(tester, icon: Icons.question_mark, option: '露骨');
    await settle(tester);

    expect(controller.value.tags, '-type:webm -type:mp4 -type:swf rating:e');
  });

  displayTest('the file type filter writes type group tags', (tester) async {
    final controller = await pumpPage(tester);

    await openFilterPrompt(tester);
    await pickFilterOption(tester, icon: Icons.image, option: '视频');

    expect(controller.value.tags, PostFileType.video.token);
    expect(queryPreview(tester), PostFileType.video.token!);
    expect(buttonColor(tester), primaryColor(tester));

    await pickFilterOption(tester, icon: Icons.image, option: '图片');

    expect(controller.value.tags, PostFileType.image.token);

    await pickFilterOption(tester, icon: Icons.image, option: '全部');
    await settle(tester);

    expect(controller.value.tags, isNull);
    expect(queryPreview(tester), '—');
    expect(buttonColor(tester), isNull);
  });

  displayTest('the file type filter adopts plain type tags', (tester) async {
    final controller = await pumpPage(
      tester,
      home: const PostsPage(params: PostParams(tags: 'type:jpg wolf')),
    );

    await openFilterPrompt(tester);

    // The plain tag of an older query shows as its category, stays in the
    // query untouched, and lights the filter button.
    expect(find.text('图片'), findsOneWidget);
    expect(controller.value.tags, 'type:jpg wolf');
    expect(buttonColor(tester), primaryColor(tester));

    // Picking a category replaces the whole family of type tags.
    await pickFilterOption(tester, icon: Icons.image, option: '视频');
    await settle(tester);

    expect(controller.value.tags, 'wolf ${PostFileType.video.token}');
  });

  displayTest('the uploader filter writes a user tag', (tester) async {
    final controller = await pumpPage(tester);

    await openFilterPrompt(tester);
    await tester.enterText(find.byKey(const Key('FilterList/user')), 'alice');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(controller.value.tags, 'user:alice');
    expect(queryPreview(tester), 'user:alice');
    expect(buttonColor(tester), primaryColor(tester));

    await tester.enterText(find.byKey(const Key('FilterList/user')), '');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await settle(tester);

    expect(controller.value.tags, isNull);
    expect(queryPreview(tester), '—');
    expect(buttonColor(tester), isNull);
  });

  /// Pumps the bare filter panel with its own controller,
  /// without a posts page behind it.
  Future<PostParamsController> pumpPanel(WidgetTester tester) async {
    final controller = PostParamsController();
    addTearDown(controller.dispose);
    // The panel is taller than the default surface.
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<Client>.value(value: client),
          Provider<Settings>.value(value: settings),
          ChangeNotifierProvider<PostParamsController>.value(value: controller),
        ],
        child: const MaterialApp(
          locale: Locale('zh'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: PostsFilterPanel()),
        ),
      ),
    );
    await tester.pump();
    return controller;
  }

  displayTest('the uploader filter does not update on every keystroke', (
    tester,
  ) async {
    final controller = await pumpPanel(tester);

    // Typing a whole name must not apply per character.
    for (var i = 1; i <= 'alice'.length; i++) {
      await tester.enterText(
        find.byKey(const Key('FilterList/user')),
        'alice'.substring(0, i),
      );
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(controller.value.tags, isNull);

    await tester.pump(const Duration(milliseconds: 400));
    expect(controller.value.tags, 'user:alice');
  });

  displayTest('closing the prompt flushes a pending filter change', (
    tester,
  ) async {
    final controller = await pumpPanel(tester);

    await tester.enterText(find.byKey(const Key('FilterList/user')), 'alice');
    await tester.pump(const Duration(milliseconds: 100));
    expect(controller.value.tags, isNull);

    // Unmounting the panel, like closing the sheet does, applies the
    // pending change right away instead of dropping it.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();

    expect(controller.value.tags, 'user:alice');
  });

  displayTest('the width filter writes a number range tag', (tester) async {
    final controller = await pumpPage(tester);

    await openFilterPrompt(tester);
    await tester.tap(find.byKey(const Key('FilterList/width:null')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // A range the formatter lets through, but the parser rejects, shows the
    // dialog's error state.
    final dialogField = find.descendant(
      of: find.byType(AlertDialog),
      matching: find.byType(TextField),
    );
    await tester.enterText(dialogField, '>=');
    await tester.tap(find.text('确定'));
    await tester.pump();
    expect(find.text('格式无效'), findsOneWidget);

    await tester.enterText(dialogField, '>=1000');
    await tester.pump();
    expect(find.text('格式无效'), findsNothing);

    await tester.tap(find.text('确定'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await settle(tester);

    expect(controller.value.tags, 'width:>=1000');
    expect(queryPreview(tester), 'width:>=1000');
    expect(buttonColor(tester), primaryColor(tester));
  });

  displayTest('the tag count filter steps its slider by five', (tester) async {
    await pumpPage(tester);

    await openFilterPrompt(tester);
    // The tag count row ends the panel, below the sheet's fold.
    await tester.ensureVisible(
      find.byKey(const Key('FilterList/tagcount:null')),
    );
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.byKey(const Key('FilterList/tagcount:null')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    final slider = tester.widget<Slider>(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(Slider),
      ),
    );
    expect(slider.divisions, 10);
    expect(slider.max, 50);
  });
}
