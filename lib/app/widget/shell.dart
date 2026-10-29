import 'dart:async';

import 'package:e1547/app/app.dart';
import 'package:e1547/logs/logs.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const double navBarHeight = 64;

class ShellController extends ChangeNotifier {
  ShellTab _tab = ShellTab.browse;

  ShellTab get tab => _tab;

  final Map<ShellTab, GlobalKey<NavigatorState>> _navigators = {
    for (final ShellTab tab in ShellTab.values) tab: GlobalKey(),
  };

  GlobalKey<NavigatorState> navigatorOf(ShellTab tab) => _navigators[tab]!;

  NavigatorState? get navigator => navigatorOf(_tab).currentState;

  void select(ShellTab tab) {
    if (_tab == tab) return;
    _tab = tab;
    notifyListeners();
  }

  Future<NavigatorState?> reset(ShellTab tab) async {
    select(tab);
    if (navigatorOf(tab).currentState == null) {
      await WidgetsBinding.instance.endOfFrame;
    }
    final NavigatorState? navigator = navigatorOf(tab).currentState;
    if (navigator == null || !navigator.mounted) return null;
    Navigator.of(
      navigator.context,
      rootNavigator: true,
    ).popUntil((route) => route.isFirst);
    navigator.popUntil((route) => route.isFirst);
    return navigator;
  }
}

class ShellProvider extends ChangeNotifierProvider<ShellController> {
  ShellProvider({super.key, super.child})
    : super(create: (context) => ShellController());
}

Widget shellRoot(BuildContext context, ShellTab tab) => tab.build(context);

Route<void> shellRoute(RouteSettings settings) => PageRouteBuilder<void>(
  settings: settings,
  pageBuilder: (context, animation, secondaryAnimation) => const AppShell(),
);

class AppShell extends StatefulWidget {
  const AppShell({super.key, this.root = shellRoot});

  final Widget Function(BuildContext context, ShellTab tab) root;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final NavBarVisibility visibility = NavBarVisibility(height: navBarHeight);
  final NavBarCover cover = NavBarCover();
  final Set<ShellTab> visited = {};
  final Map<ShellTab, ScrollController> scrolls = {};
  final Map<ShellTab, NavBarReselectController> reselects = {};

  ScrollController scrollOf(ShellTab tab) =>
      scrolls.putIfAbsent(tab, ScrollController.new);

  NavBarReselectController reselectOf(ShellTab tab) =>
      reselects.putIfAbsent(tab, NavBarReselectController.new);

  @override
  void dispose() {
    for (final ScrollController controller in scrolls.values) {
      controller.dispose();
    }
    visibility.dispose();
    cover.dispose();
    super.dispose();
  }

  void _go(ShellController shell, ShellTab tab) {
    visibility.show();
    if (tab != shell.tab) {
      shell.select(tab);
      return;
    }
    final NavigatorState? navigator = shell.navigatorOf(tab).currentState;
    if (navigator != null && navigator.canPop()) {
      navigator.popUntil((route) => route.isFirst);
      return;
    }
    final ScrollController scroll = scrollOf(tab);
    if (scroll.positions.length == 1) {
      final ScrollPosition listing = scroll.positions.first;
      if (listing.pixels > listing.minScrollExtent) {
        unawaited(
          listing.animateTo(
            listing.minScrollExtent,
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
          ),
        );
      }
    }
    unawaited(reselectOf(tab).reselect());
  }

  Future<void> _back(ShellController shell) async {
    final NavigatorState? navigator = shell.navigator;
    if (navigator != null && await navigator.maybePop()) return;
    if (shell.tab != ShellTab.browse) {
      shell.select(ShellTab.browse);
      return;
    }
    await SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final ShellController shell = context.watch<ShellController>();
    visited.add(shell.tab);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _back(shell);
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: NavBarPadding(
              space: navBarHeight,
              child: NavBarScrollListener(
                controller: visibility,
                cover: cover,
                child: NavBarCoverScope(
                  cover: cover,
                  child: AnimatedIndexedStack(
                    index: shell.tab.index,
                    children: [
                      for (final ShellTab tab in ShellTab.values)
                        if (visited.contains(tab))
                          ShellNavigator(
                            navigatorKey: shell.navigatorOf(tab),
                            scroll: scrollOf(tab),
                            reselect: reselectOf(tab),
                            active: tab == shell.tab,
                            builder: (context) => widget.root(context, tab),
                          )
                        else
                          const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ListenableBuilder(
              listenable: cover,
              builder: (context, child) {
                final double coverage = cover.coverage;
                if (coverage >= 1) return const SizedBox.shrink();
                return FractionalTranslation(
                  translation: Offset(
                    0,
                    1.4 * Curves.easeInOut.transform(coverage),
                  ),
                  child: IgnorePointer(ignoring: coverage > 0, child: child),
                );
              },
              child: NavBarSlide(
                controller: visibility,
                child: NavBar(
                  selected: shell.tab,
                  onGo: (tab) => _go(shell, tab),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShellNavigator extends StatefulWidget {
  const ShellNavigator({
    super.key,
    required this.navigatorKey,
    required this.scroll,
    required this.reselect,
    required this.active,
    required this.builder,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final ScrollController scroll;
  final NavBarReselectController reselect;
  final bool active;
  final WidgetBuilder builder;

  @override
  State<ShellNavigator> createState() => _ShellNavigatorState();
}

class _ShellNavigatorState extends State<ShellNavigator> {
  final AnyRouteObserver observer = AnyRouteObserver();
  final RouteLoggerObserver logger = RouteLoggerObserver();
  final HeroController heroes = MaterialApp.createMaterialHeroController();
  late final ShellPopGate gate = ShellPopGate(active: widget.active);

  @override
  void didUpdateWidget(covariant ShellNavigator oldWidget) {
    super.didUpdateWidget(oldWidget);
    gate.active = widget.active;
  }

  @override
  void dispose() {
    gate.dispose();
    heroes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Provider<AnyRouteObserver>.value(
    value: observer,
    child: HeroControllerScope(
      controller: heroes,
      child: Navigator(
        key: widget.navigatorKey,
        observers: [observer, logger, gate],
        onGenerateRoute: (settings) => MaterialPageRoute(
          settings: settings,
          builder: (context) => NavBarReselect(
            controller: widget.reselect,
            child: PrimaryScrollController(
              controller: widget.scroll,
              automaticallyInheritForPlatforms: TargetPlatform.values.toSet(),
              child: widget.builder(context),
            ),
          ),
        ),
      ),
    ),
  );
}

class ShellPopGate extends NavigatorObserver implements PopEntry<Object?> {
  ShellPopGate({required bool active}) : _canPop = ValueNotifier(active);

  final ValueNotifier<bool> _canPop;

  bool get active => _canPop.value;

  set active(bool value) => _canPop.value = value;

  @override
  ValueListenable<bool> get canPopNotifier => _canPop;

  @override
  void onPopInvoked(bool didPop) {}

  @override
  void onPopInvokedWithResult(bool didPop, Object? result) {}

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is ModalRoute) route.registerPopEntry(this);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute is ModalRoute) oldRoute.unregisterPopEntry(this);
    if (newRoute is ModalRoute) newRoute.registerPopEntry(this);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is ModalRoute) route.unregisterPopEntry(this);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is ModalRoute) route.unregisterPopEntry(this);
  }

  void dispose() => _canPop.dispose();
}

class NavBar extends StatelessWidget {
  const NavBar({super.key, required this.selected, required this.onGo});

  final ShellTab selected;
  final ValueChanged<ShellTab> onGo;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      color: theme.canvasColor,
      shape: Border(
        top: BorderSide(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: navBarHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final ShellTab tab in ShellTab.values)
                Expanded(
                  child: NavBarTab(
                    tab: tab,
                    chosen: tab == selected,
                    onTap: () => onGo(tab),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavBarTab extends StatelessWidget {
  const NavBarTab({
    super.key,
    required this.tab,
    required this.chosen,
    required this.onTap,
  });

  final ShellTab tab;
  final bool chosen;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color tint = chosen
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface.withValues(alpha: 0.6);
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(tab.icon, color: tint, size: 24),
          const SizedBox(height: 4),
          Text(
            tab.label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: tint,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
