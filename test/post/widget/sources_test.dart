import 'package:e1547/post/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> show(WidgetTester tester, String url) => tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: SourceCard(url: url)),
    ),
  );

  testWidgets('a source shows the favicon of its site', (tester) async {
    await show(tester, 'https://pbs.twimg.com/media/a.png');

    final Image image = tester.widget(find.byType(Image));
    expect(
      (image.image as AssetImage).assetName,
      'assets/icon/favicons/twitter.com.png',
    );
  });

  testWidgets('a source of an unknown site shows a globe', (tester) async {
    await show(tester, 'https://example.org/a');

    expect(find.byType(Image), findsNothing);
    expect(find.byIcon(Icons.public), findsOneWidget);
  });
}
