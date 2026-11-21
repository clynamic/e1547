import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'a skeleton page handles its back button and blocks its actions',
    (tester) async {
      int backs = 0;
      int actions = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Skeletonizer(
            ignorePointers: false,
            child: Scaffold(
              appBar: DefaultAppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => backs++,
                ),
                title: const Text('title'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () => actions++,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.tap(find.byIcon(Icons.info_outline), warnIfMissed: false);
      await tester.pump(const Duration(seconds: 1));

      expect(backs, 1);
      expect(actions, 0);
    },
  );
}
