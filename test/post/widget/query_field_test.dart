import 'package:e1547/post/post.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('a chip takes its stripe from the tag category', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: QueryChip(
            term: 'riolu',
            selected: false,
            onTap: () {},
            preview: TagPreview(
              name: 'riolu',
              category: TagCategory.species.id,
            ),
          ),
        ),
      ),
    );

    final Container stripe = tester.widget<Container>(
      find.descendant(
        of: find.byType(QueryChip),
        matching: find.byType(Container),
      ),
    );
    expect(stripe.color, TagCategory.species.colorFor(Brightness.light));
  });

  testWidgets('typed text sits level with the chips', (tester) async {
    final QueryFieldController controller = QueryFieldController(
      query: 'riolu',
    );
    addTearDown(controller.dispose);
    controller.text.text = '${controller.text.text}sol';
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(child: QueryField(controller: controller)),
        ),
      ),
    );

    expect(
      tester.getCenter(find.byType(EditableText)).dy,
      moreOrLessEquals(tester.getCenter(find.byType(QueryChip)).dy, epsilon: 1),
    );
  });
}
