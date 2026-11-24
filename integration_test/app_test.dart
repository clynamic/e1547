import 'package:e1547/app/app.dart';
import 'package:e1547/post/post.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

Future<void> pumpUntil(
  WidgetTester tester,
  String description,
  bool Function() condition, {
  Duration timeout = const Duration(seconds: 60),
}) async {
  final end = DateTime.now().add(timeout);
  while (!condition()) {
    if (DateTime.now().isAfter(end)) {
      throw TestFailure('Timed out waiting for $description');
    }
    await tester.pump(const Duration(milliseconds: 200));
  }
}

bool found(Finder finder) => finder.evaluate().isNotEmpty;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app opens to home posts', (tester) async {
    final onError = FlutterError.onError;
    final skip = find.text('Skip').hitTestable();
    final home = find.byType(HomePage);

    try {
      await tester.pumpWidget(const App());

      await pumpUntil(
        tester,
        'onboarding or home',
        () => found(skip) || found(home),
      );
      if (found(skip)) {
        await tester.tap(skip);
        await pumpUntil(tester, 'home', () => found(home));
      }

      await pumpUntil(tester, 'post tiles', () => found(find.byType(PostTile)));

      final stayAlive = DateTime.now().add(const Duration(seconds: 60));
      await pumpUntil(
        tester,
        'a minute on home',
        () => DateTime.now().isAfter(stayAlive),
        timeout: const Duration(seconds: 90),
      );
      expect(home, findsOneWidget);
    } finally {
      FlutterError.onError = onError;
    }
  });
}
