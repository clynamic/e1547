import 'dart:ui';

import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/settings/settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notified_preferences/notified_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const Locale traditional = Locale.fromSubtags(
    languageCode: 'zh',
    scriptCode: 'Hant',
  );

  group('resolveAppLocale', () {
    test('matches supported locales and falls back to the first one', () {
      expect(resolveAppLocale(const [Locale('en')]), const Locale('en'));
      expect(resolveAppLocale(const [Locale('zh')]), const Locale('zh'));
      expect(resolveAppLocale(const [traditional]), traditional);
      expect(resolveAppLocale(const [Locale('en', 'US')]), const Locale('en'));
      expect(resolveAppLocale(const [Locale('zh', 'CN')]), const Locale('zh'));
      expect(resolveAppLocale(const [Locale('de')]), const Locale('de'));
      expect(resolveAppLocale(const [Locale('de', 'DE')]), const Locale('de'));
      expect(resolveAppLocale(const [Locale('fr')]), const Locale('en'));
      expect(resolveAppLocale(null), const Locale('en'));
      expect(resolveAppLocale(const []), const Locale('en'));
    });

    test(
      'upgrades generic zh to the traditional script for regions using it',
      () {
        expect(resolveAppLocale(const [Locale('zh', 'TW')]), traditional);
        expect(resolveAppLocale(const [Locale('zh', 'HK')]), traditional);
        expect(resolveAppLocale(const [Locale('zh', 'MO')]), traditional);
        expect(
          resolveAppLocale(const [Locale('zh', 'CN')]),
          const Locale('zh'),
        );
        expect(
          resolveAppLocale(const [Locale('zh', 'SG')]),
          const Locale('zh'),
        );
      },
    );

    test('resolves the japanese and russian languages generically', () {
      expect(parseLanguage('ja'), const Locale('ja'));
      expect(parseLanguage('ru'), const Locale('ru'));
      expect(resolveAppLocale(const [Locale('ja')]), const Locale('ja'));
      expect(resolveAppLocale(const [Locale('ru')]), const Locale('ru'));
      expect(resolveAppLocale(const [Locale('ja', 'JP')]), const Locale('ja'));
      expect(resolveAppLocale(const [Locale('ru', 'RU')]), const Locale('ru'));
      // an unsupported preferred language falls back to a supported one
      expect(
        resolveAppLocale(const [Locale('fi'), Locale('ru')]),
        const Locale('ru'),
      );
    });

    test('resolves the german and spanish languages generically', () {
      expect(parseLanguage('de'), const Locale('de'));
      expect(parseLanguage('es'), const Locale('es'));
      expect(resolveAppLocale(const [Locale('de')]), const Locale('de'));
      expect(resolveAppLocale(const [Locale('es')]), const Locale('es'));
      expect(resolveAppLocale(const [Locale('de', 'AT')]), const Locale('de'));
      expect(resolveAppLocale(const [Locale('es', 'MX')]), const Locale('es'));
    });
  });

  group('loadPreferenceLocalizations', () {
    test('loads the stored language', () async {
      SharedPreferences.setMockInitialValues({'language': 'en'});
      AppLocalizations localizations = await loadPreferenceLocalizations();
      expect(localizations.followNotificationBody(1), 'has a new post!');
      expect(localizations.followNotificationBody(2), 'has 2 new posts!');
      expect(localizations.followNotificationSummary, 'New posts!');
      expect(localizations.followChannelName, 'Followed Tags');

      SharedPreferences.setMockInitialValues({'language': 'zh'});
      localizations = await loadPreferenceLocalizations();
      expect(localizations.followNotificationBody(3), '有 3 个新帖子！');
      expect(localizations.followChannelName, '已关注标签');

      SharedPreferences.setMockInitialValues({'language': 'zh_Hant'});
      localizations = await loadPreferenceLocalizations();
      expect(localizations.followNotificationBody(1), '有 1 則新貼文！');
      expect(localizations.followChannelName, '已追蹤標籤');
    });

    test('loads the stored japanese and russian localizations', () async {
      SharedPreferences.setMockInitialValues({'language': 'ja'});
      AppLocalizations localizations = await loadPreferenceLocalizations();
      expect(localizations.followNotificationBody(1), '新しい投稿が 1 件あります！');
      expect(localizations.followNotificationBody(2), '新しい投稿が 2 件あります！');
      expect(localizations.followChannelName, 'フォロー中のタグ');

      SharedPreferences.setMockInitialValues({'language': 'ru'});
      localizations = await loadPreferenceLocalizations();
      // covers all four russian plural categories
      expect(localizations.followNotificationBody(1), '1 новый пост!');
      expect(localizations.followNotificationBody(2), '2 новых поста!');
      expect(localizations.followNotificationBody(5), '5 новых постов!');
      expect(localizations.followNotificationBody(21), '21 новый пост!');
      expect(localizations.followChannelName, 'Подписки на теги');
    });

    test('falls back to the platform locales when nothing is stored', () async {
      SharedPreferences.setMockInitialValues({});
      final List<Locale> platformLocales = PlatformDispatcher.instance.locales
          .toList();
      final AppLocalizations expected = await AppLocalizations.delegate.load(
        resolveAppLocale(platformLocales),
      );
      final AppLocalizations localizations =
          await loadPreferenceLocalizations();
      expect(
        localizations.followNotificationSummary,
        expected.followNotificationSummary,
      );
    });
  });
}
