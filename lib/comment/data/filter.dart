import 'package:collection/collection.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/comment/comment.dart';
import 'package:e1547/query/query.dart';

class CommentFilter extends FilterController<Comment> {
  CommentFilter(this.client);

  final Client client;

  @override
  List<Comment> filter(List<Comment> items) => items
      .whereNot(
        (e) => client.traits.value.denylist.contains('user:${e.creatorId}'),
      )
      .toList();

  @override
  void dispose() {
    client.traits.removeListener(notifyListeners);
    super.dispose();
  }
}
