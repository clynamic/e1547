import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('covers in one group count once and groups add up', () {
    final NavBarCover cover = NavBarCover();
    addTearDown(cover.dispose);
    final Object page = Object();

    cover.cover(Object(), 0.5, group: page);
    cover.cover(Object(), 0.4, group: page);
    expect(cover.coverage, 0.5);

    cover.cover(Object(), 0.3);
    expect(cover.coverage, 0.8);
  });

  testWidgets('a page nested in covered widgets hides the bar as it opens', (
    tester,
  ) async {
    final NavBarCover cover = NavBarCover();
    addTearDown(cover.dispose);
    final GlobalKey<NavigatorState> navigator = GlobalKey();
    await tester.pumpWidget(
      NavBarCoverScope(
        cover: cover,
        child: MaterialApp(navigatorKey: navigator, home: const SizedBox()),
      ),
    );

    final MaterialPageRoute<void> route = MaterialPageRoute(
      builder: (context) =>
          const NavBarCovered(child: NavBarCovered(child: SizedBox())),
    );
    navigator.currentState!.push(route);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(route.animation!.value, inExclusiveRange(0, 1));
    expect(cover.coverage, moreOrLessEquals(route.animation!.value));
    await tester.pumpAndSettle();
  });

  testWidgets('a dimmed popup taken away without closing frees the bar', (
    tester,
  ) async {
    final NavBarCover cover = NavBarCover();
    addTearDown(cover.dispose);
    final GlobalKey<NavigatorState> navigator = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigator,
        navigatorObservers: [NavBarOverlayObserver(cover)],
        home: const SizedBox(),
      ),
    );
    final DialogRoute<void> dialog = DialogRoute(
      context: navigator.currentContext!,
      builder: (context) => const Text('dialog'),
    );
    navigator.currentState!.push(dialog);
    await tester.pumpAndSettle();
    expect(cover.coverage, 1);

    navigator.currentState!.removeRoute(dialog);
    await tester.pumpAndSettle();

    expect(cover.coverage, 0);
  });
}
