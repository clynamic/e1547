import 'package:e1547/set/set.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('each set order asks e621 for the sort it names', () {
    expect(
      {
        for (final PostSetOrder order in PostSetOrder.values)
          order: PostSetParams(order: order).toQuery()['search[order]'],
      },
      {
        PostSetOrder.updatedAt: 'updated_at',
        PostSetOrder.name: 'name',
        PostSetOrder.createdAt: 'id_desc',
        PostSetOrder.postCount: 'post_count',
      },
    );
  });
}
