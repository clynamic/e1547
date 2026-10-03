import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/harness.dart';

void main() {
  setUpAll(initializeTestApp);

  /// Pumps a page whose button opens a range dialog counting its submissions.
  Future<void> pumpPage(
    WidgetTester tester, {
    required ValueSetter<NumberRange?> onSubmit,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => RangeDialog(
                    title: const Text('range'),
                    max: 100,
                    onSubmit: onSubmit,
                  ),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
  }

  /// Fires the [text] button of the dialog twice without a frame between the
  /// calls, the tightest window a double tap can hit.
  Future<void> doubleTap(WidgetTester tester, String text) async {
    final button = tester.widget<TextButton>(
      find.widgetWithText(TextButton, text),
    );
    button.onPressed!();
    button.onPressed!();
    await tester.pumpAndSettle();
  }

  displayTest('a range dialog submits once for a double tap', (tester) async {
    int submissions = 0;
    await pumpPage(tester, onSubmit: (range) => submissions++);

    await doubleTap(tester, '确定');

    expect(submissions, 1);
    // The dialog only left the page itself behind.
    expect(find.text('open'), findsOneWidget);
    expect(find.text('range'), findsNothing);
  });

  displayTest('a range dialog cancels without submitting', (tester) async {
    int submissions = 0;
    await pumpPage(tester, onSubmit: (range) => submissions++);

    await doubleTap(tester, '取消');

    expect(submissions, 0);
    expect(find.text('open'), findsOneWidget);
    expect(find.text('range'), findsNothing);
  });
}
