import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

/// Tests the localized date formatting helpers against the raw intl formats,
/// locking the app-language (not platform-locale) behavior and the zh_Hant
/// mapping onto the shared zh date symbols.
void main() {
  Future<void> pumpLocale(
    WidgetTester tester,
    Locale locale,
    void Function(BuildContext context) probe,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            probe(context);
            return const SizedBox();
          },
        ),
      ),
    );
  }

  final date = DateTime(2026, 9, 30, 14, 5);

  testWidgets('localized datetimes follow the app language', (tester) async {
    await pumpLocale(tester, const Locale('zh'), (context) {
      final formatted = localizedDateTime(context, date);
      expect(formatted, DateFormat.yMd('zh').add_jm().format(date));
      expect(formatted, isNot(DateFormat.yMd('en_US').add_jm().format(date)));
    });
  });

  testWidgets(
    'localized datetimes map traditional chinese onto shared zh symbols',
    (tester) async {
      await pumpLocale(
        tester,
        const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
        (context) {
          final formatted = localizedDateTime(context, date);
          expect(formatted, DateFormat.yMd('zh').add_jm().format(date));
          expect(
            formatted,
            isNot(DateFormat.yMd('en_US').add_jm().format(date)),
          );
        },
      );
    },
  );

  testWidgets('localized dates follow the app language', (tester) async {
    await pumpLocale(tester, const Locale('zh'), (context) {
      final formatted = localizedDate(context, date);
      expect(formatted, DateFormat.yMd('zh').format(date));
      expect(formatted, isNot(DateFormat.yMd('en_US').format(date)));
    });
  });

  testWidgets('localized date names fall back to localized dates', (
    tester,
  ) async {
    await pumpLocale(tester, const Locale('zh'), (context) {
      final old = DateTime.now().subtract(const Duration(days: 30));
      expect(localizedDateName(context, old), localizedDate(context, old));
    });
  });
}
