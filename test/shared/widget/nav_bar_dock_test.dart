import 'package:e1547/shared/shared.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('a new builder for a dock in place changes only its content', () {
    final NavBarDocks docks = NavBarDocks();
    addTearDown(docks.dispose);
    final Object page = Object();
    int layout = 0;
    int content = 0;
    docks.addListener(() => layout++);
    docks.content.addListener(() => content++);

    docks.dock(page, 1, (context) => const SizedBox());
    docks.dock(page, 1, (context) => const SizedBox());
    docks.dock(page, 1, (context) => const SizedBox(), full: true);

    expect(layout, 2);
    expect(content, 1);
  });
}
