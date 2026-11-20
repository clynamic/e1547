import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('removes its link overlay when it is removed from the tree', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: LinkPreviewProvider(child: SizedBox())),
    );
    await tester.pump();
    expect(find.byType(LinkOverlay), findsOneWidget);

    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    await tester.pump();

    expect(find.byType(LinkOverlay), findsNothing);
  });
}
