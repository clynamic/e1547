import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notified_preferences/notified_preferences.dart';

void main() {
  late Settings settings;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    settings = await Settings.getInstance();
  });

  Widget scoped(Widget child) => Provider<Settings>.value(
    value: settings,
    child: HandednessScope(child: MaterialApp(home: child)),
  );

  Future<double> fabLeft(WidgetTester tester) async {
    await tester.pumpWidget(
      scoped(
        AdaptiveScaffold(
          body: const SizedBox.expand(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return tester.getTopLeft(find.byType(FloatingActionButton)).dx;
  }

  testWidgets('the fab floats at the end for right handed use', (tester) async {
    final double screenWidth =
        tester.view.physicalSize.width / tester.view.devicePixelRatio;
    expect(await fabLeft(tester), greaterThan(screenWidth / 2));
  });

  testWidgets('the fab floats at the start for left handed use', (
    tester,
  ) async {
    settings.handedness.value = Handedness.left;
    final double screenWidth =
        tester.view.physicalSize.width / tester.view.devicePixelRatio;
    expect(await fabLeft(tester), lessThan(screenWidth / 2));
  });
}
