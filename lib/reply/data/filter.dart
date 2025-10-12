import 'package:collection/collection.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/reply/reply.dart';

class ReplyFilter extends FilterController<Reply> {
  ReplyFilter(this.client) {
    client.traits.addListener(notifyListeners);
  }

  final Client client;

  @override
  List<Reply> filter(List<Reply> items) => items
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
