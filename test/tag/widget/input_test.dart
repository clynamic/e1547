import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/environment.dart';
import '../../_support/harness.dart';

void main() {
  setUpAll(initializeTestApp);

  late TestEnvironment env;

  setUp(() async => env = await TestEnvironment.start());

  tearDown(() => env.dispose());

  displayTest('a picked metatag name waits for its value, a picked value ends '
      'the term', (tester) async {
    tester.binding.defaultBinaryMessenger.setMockStreamHandler(
      const EventChannel('flutter_keyboard_visibility'),
      MockStreamHandler.inline(onListen: (arguments, events) {}),
    );
    final TextEditingController controller = TextEditingController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      env.app(
        Scaffold(body: TagInput(controller: controller, cutoutForFab: false)),
      ),
    );

    await tester.enterText(find.byType(TextField), 'tag_1 ord');
    await env.settle(tester, animating: true);
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.text('order:'));
    await tester.pump();

    expect(controller.text, 'tag_1 order:');

    await tester.enterText(find.byType(TextField), 'tag_1 -order:sc');
    await env.settle(tester, animating: true);
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.text('-order:score_asc'));
    await tester.pump();

    expect(controller.text, 'tag_1 -order:score_asc ');
  });

  test('finds the term at the cursor when an earlier term is the same', () {
    const TagInput input = TagInput(controller: null);

    expect(input.findTag(['ca', 'dog', 'ca'], 9), 2);
  });
}
