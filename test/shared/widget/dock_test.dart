import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<NavBarVisibility> pumpDock(
    WidgetTester tester, {
    ValueChanged<EdgeInsets>? padding,
    VoidCallback? onTap,
  }) async {
    final NavBarVisibility visibility = NavBarVisibility(height: 64);
    addTearDown(visibility.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NavBarScrollListener(
            controller: visibility,
            child: NavBarVisibilityScope(
              visibility: visibility,
              child: DockLayout(
                onTap: onTap ?? () {},
                mark: const Icon(Icons.search),
                content: const Text('dock query'),
                child: Builder(
                  builder: (context) {
                    padding?.call(MediaQuery.paddingOf(context));
                    return ListView(
                      children: [
                        for (int i = 0; i < 40; i++)
                          const SizedBox(height: 100),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
    return visibility;
  }

  Rect dock(WidgetTester tester) => tester.getRect(
    find
        .ancestor(of: find.byIcon(Icons.search), matching: find.byType(InkWell))
        .first,
  );

  testWidgets('the dock spans the width above the content', (tester) async {
    await pumpDock(tester);

    expect(
      dock(tester).width,
      tester.getSize(find.byType(Scaffold)).width - 24,
    );
    expect(find.text('dock query'), findsOneWidget);
  });

  testWidgets('the dock folds into its search mark as the bar leaves', (
    tester,
  ) async {
    await pumpDock(tester);

    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pumpAndSettle();

    expect(dock(tester).size, const Size(dockHeight, dockHeight));
    expect(find.text('dock query'), findsNothing);
  });

  testWidgets('the content leaves room for the dock', (tester) async {
    late EdgeInsets padding;
    await pumpDock(tester, padding: (value) => padding = value);

    expect(padding.bottom, dockSpace);
  });

  testWidgets('a folded dock still opens on a tap', (tester) async {
    int taps = 0;
    await pumpDock(tester, onTap: () => taps++);
    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.search));

    expect(taps, 1);
  });
}
