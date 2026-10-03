import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/wiki/wiki.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/harness.dart';

/// Counts the material page routes pushed onto the navigator.
class _PushCounter extends NavigatorObserver {
  int get pages => pushed.whereType<MaterialPageRoute<dynamic>>().length;

  final List<Route<dynamic>> pushed = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      pushed.add(route);
}

void main() {
  setUpAll(initializeTestApp);

  testWidgets('a double tapped wiki prompt opens one posts page', (
    tester,
  ) async {
    final counter = _PushCounter();
    final wiki = Wiki(
      id: 1,
      title: 'canine',
      body: 'a wiki body',
      createdAt: DateTime(2024),
    );

    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [counter],
        locale: const Locale('zh'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => showWikiPrompt(context: context, wiki: wiki),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pump();
    // The sheet snaps into place over several frames.
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    // A double tap fires the title twice before a frame can come between.
    // The sheet's own gestures sit over its header, so the title is fired
    // directly, which also makes the two calls back to back.
    final header = tester.widget<InkWell>(
      find.ancestor(of: find.text('canine'), matching: find.byType(InkWell)),
    );
    // The pushed posts page is left unbuilt on purpose: routes push
    // synchronously, so counting them needs no frame, and an unbuilt
    // page needs none of the providers it would ask for.
    final pagesBefore = counter.pages;
    header.onTap!();
    header.onTap!();

    // The unguarded double tap would push a second posts page after
    // popping the first, which a lone count could not tell apart.
    expect(counter.pages - pagesBefore, 1);
  });
}
