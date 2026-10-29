import 'package:e1547/app/app.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final Map<ShellTab, EdgeInsets> paddings = {};

  Widget root(BuildContext context, ShellTab tab) {
    paddings[tab] = MediaQuery.paddingOf(context);
    final Widget page = Scaffold(
      body: ListView(
        primary: true,
        children: [
          Text('${tab.label} root'),
          TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    Scaffold(body: Text('${tab.label} detail')),
              ),
            ),
            child: Text('open ${tab.label}'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const NavBarCovered(
                  child: Scaffold(body: Text('covering')),
                ),
              ),
            ),
            child: Text('cover ${tab.label}'),
          ),
          for (int i = 0; i < 40; i++) const SizedBox(height: 100),
        ],
      ),
    );
    if (tab != ShellTab.search) return page;
    return NavBarDock(
      builder: (context) => const Text('search dock'),
      child: page,
    );
  }

  Future<ShellController> pumpShell(WidgetTester tester) async {
    late ShellController shell;
    await tester.pumpWidget(
      MaterialApp(
        home: ShellProvider(
          child: Builder(
            builder: (context) {
              shell = context.read<ShellController>();
              return AppShell(root: root);
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return shell;
  }

  Finder tab(ShellTab tab) => find.descendant(
    of: find.byType(NavBar),
    matching: find.byTooltip(tab.label),
  );

  double barTop(WidgetTester tester) =>
      tester.getTopLeft(find.byType(NavBar)).dy;

  double screenHeight(WidgetTester tester) =>
      tester.view.physicalSize.height / tester.view.devicePixelRatio;

  testWidgets('each tab keeps its own stack', (tester) async {
    await pumpShell(tester);

    await tester.tap(find.text('open Browse'));
    await tester.pumpAndSettle();
    await tester.tap(tab(ShellTab.search));
    await tester.pumpAndSettle();

    expect(find.text('Search root'), findsOneWidget);

    await tester.tap(tab(ShellTab.browse));
    await tester.pumpAndSettle();

    expect(find.text('Browse detail'), findsOneWidget);
  });

  testWidgets('a tab switch fades the old tab out before it leaves', (
    tester,
  ) async {
    await pumpShell(tester);

    await tester.tap(tab(ShellTab.search));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    final Iterable<double> fades = tester
        .widgetList<FadeTransition>(
          find.ancestor(
            of: find.text('Browse root'),
            matching: find.byType(FadeTransition),
          ),
        )
        .map((fade) => fade.opacity.value);
    expect(fades, contains(inExclusiveRange(0, 1)));

    await tester.pumpAndSettle();

    expect(find.text('Browse root'), findsNothing);
    expect(find.text('Search root'), findsOneWidget);
  });

  testWidgets('tapping the active tab returns it to its root', (tester) async {
    await pumpShell(tester);

    await tester.tap(find.text('open Browse'));
    await tester.pumpAndSettle();
    await tester.tap(tab(ShellTab.browse));
    await tester.pumpAndSettle();

    expect(find.text('Browse root'), findsOneWidget);
    expect(find.text('Browse detail'), findsNothing);
  });

  testWidgets('tapping the active tab at its root scrolls it to the top', (
    tester,
  ) async {
    await pumpShell(tester);

    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, 200));
    await tester.pumpAndSettle();
    final ScrollPosition position = tester
        .state<ScrollableState>(find.byType(Scrollable))
        .position;
    expect(position.pixels, greaterThan(0));

    await tester.tap(tab(ShellTab.browse));
    await tester.pumpAndSettle();

    expect(position.pixels, 0);
  });

  Future<void> backGesture(WidgetTester tester) async {
    const StandardMethodCodec codec = StandardMethodCodec();
    Future<void> send(String method, [Object? arguments]) =>
        tester.binding.defaultBinaryMessenger.handlePlatformMessage(
          'flutter/backgesture',
          codec.encodeMethodCall(MethodCall(method, arguments)),
          (_) {},
        );
    await send('startBackGesture', {
      'touchOffset': [5.0, 300.0],
      'progress': 0.0,
      'swipeEdge': 0,
    });
    await tester.pump();
    await send('updateBackGestureProgress', {
      'touchOffset': [150.0, 300.0],
      'progress': 0.5,
      'swipeEdge': 0,
    });
    await tester.pump();
    await send('commitBackGesture');
    await tester.pumpAndSettle();
  }

  testWidgets('a back gesture pops the open tab and leaves the others', (
    tester,
  ) async {
    final ShellController shell = await pumpShell(tester);
    await tester.tap(tab(ShellTab.library));
    await tester.pumpAndSettle();
    await tester.tap(find.text('open Library'));
    await tester.pumpAndSettle();
    await tester.tap(tab(ShellTab.search));
    await tester.pumpAndSettle();
    await tester.tap(find.text('open Search'));
    await tester.pumpAndSettle();

    await backGesture(tester);

    expect(shell.tab, ShellTab.search);
    expect(find.text('Search root'), findsOneWidget);
    await tester.tap(tab(ShellTab.library));
    await tester.pumpAndSettle();
    expect(find.text('Library detail'), findsOneWidget);
  });

  testWidgets('back pops the active tab, then goes to Browse', (tester) async {
    final ShellController shell = await pumpShell(tester);

    await tester.tap(tab(ShellTab.search));
    await tester.pumpAndSettle();
    await tester.tap(find.text('open Search'));
    await tester.pumpAndSettle();

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(shell.tab, ShellTab.search);
    expect(find.text('Search root'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(shell.tab, ShellTab.browse);
    expect(find.text('Browse root'), findsOneWidget);
  });

  testWidgets('the bar leaves on a scroll down and returns on a scroll up', (
    tester,
  ) async {
    await pumpShell(tester);
    final double shown = barTop(tester);

    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pumpAndSettle();

    expect(barTop(tester), greaterThanOrEqualTo(screenHeight(tester)));

    await tester.drag(find.byType(ListView), const Offset(0, 200));
    await tester.pumpAndSettle();

    expect(barTop(tester), shown);
  });

  testWidgets('a short scroll up leaves the bar hidden', (tester) async {
    await pumpShell(tester);

    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, 60));
    await tester.pumpAndSettle();

    expect(barTop(tester), greaterThanOrEqualTo(screenHeight(tester)));
  });

  testWidgets('the bar follows the finger and settles at the nearer edge', (
    tester,
  ) async {
    await pumpShell(tester);
    final double shown = barTop(tester);
    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.drag(find.byType(ListView), const Offset(0, 200));
    await tester.pumpAndSettle();

    final TestGesture gesture = await tester.startGesture(
      tester.getCenter(find.byType(ListView)),
    );
    await gesture.moveBy(const Offset(0, -20));
    await gesture.moveBy(const Offset(0, -4));
    await tester.pump();

    expect(barTop(tester), inExclusiveRange(shown, screenHeight(tester)));

    await tester.pump(const Duration(milliseconds: 500));
    await gesture.up();
    await tester.pumpAndSettle();

    expect(barTop(tester), shown);
  });

  testWidgets('a page with a dock shows it in the bar above the tabs', (
    tester,
  ) async {
    await pumpShell(tester);
    expect(find.text('search dock'), findsNothing);

    await tester.tap(tab(ShellTab.search));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(NavBar),
        matching: find.text('search dock'),
      ),
      findsOneWidget,
    );
    expect(
      tester.getBottomLeft(find.text('search dock')).dy,
      lessThan(tester.getTopLeft(tab(ShellTab.search)).dy),
    );
  });

  testWidgets('a pushed page without a dock leaves only the tabs', (
    tester,
  ) async {
    await pumpShell(tester);
    await tester.tap(tab(ShellTab.search));
    await tester.pumpAndSettle();

    await tester.tap(find.text('open Search'));
    await tester.pumpAndSettle();

    expect(find.text('search dock'), findsNothing);
  });

  testWidgets('a docked page gets room for the dock below its content', (
    tester,
  ) async {
    await pumpShell(tester);
    await tester.tap(tab(ShellTab.search));
    await tester.pumpAndSettle();
    final double docked = paddings[ShellTab.search]!.bottom;

    await tester.tap(tab(ShellTab.browse));
    await tester.pumpAndSettle();

    expect(docked - paddings[ShellTab.browse]!.bottom, navBarDockHeight + 1);
  });

  testWidgets('a covering page hides the bar until it closes', (tester) async {
    await pumpShell(tester);
    expect(find.byType(NavBar), findsOneWidget);

    await tester.tap(find.text('cover Browse'));
    await tester.pumpAndSettle();

    expect(find.byType(NavBar), findsNothing);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.byType(NavBar), findsOneWidget);
  });

  testWidgets('a reset selects a tab and returns it to its root', (
    tester,
  ) async {
    final ShellController shell = await pumpShell(tester);

    await tester.tap(find.text('open Browse'));
    await tester.pumpAndSettle();
    await tester.tap(tab(ShellTab.you));
    await tester.pumpAndSettle();
    showModalBottomSheet<void>(
      context: tester.element(find.text('You root')),
      useRootNavigator: true,
      builder: (context) => const Text('sheet'),
    );
    await tester.pumpAndSettle();

    final NavigatorState? navigator = await shell.reset(ShellTab.browse);
    await tester.pumpAndSettle();

    expect(shell.tab, ShellTab.browse);
    expect(navigator!.canPop(), isFalse);
    expect(find.text('Browse root'), findsOneWidget);
    expect(find.text('sheet'), findsNothing);
  });

  testWidgets('a reset opens a tab never visited before', (tester) async {
    final ShellController shell = await pumpShell(tester);

    final Future<NavigatorState?> reset = shell.reset(ShellTab.library);
    await tester.pumpAndSettle();
    final NavigatorState? navigator = await reset;

    expect(navigator, isNotNull);
    expect(find.text('Library root'), findsOneWidget);
  });

  testWidgets('an open keyboard covers the room kept for the bar', (
    tester,
  ) async {
    await pumpShell(tester);
    expect(paddings[ShellTab.browse]!.bottom, greaterThan(0));

    tester.view.viewInsets = FakeViewPadding(
      bottom: 300 * tester.view.devicePixelRatio,
    );
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpAndSettle();

    expect(paddings[ShellTab.browse]!.bottom, 0);
  });
}
