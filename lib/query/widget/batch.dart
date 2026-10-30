import 'package:collection/collection.dart';
import 'package:e1547/query/query.dart';
import 'package:flutter/widgets.dart';

class QueryBatchRequest<K> extends StatefulWidget {
  const QueryBatchRequest({
    super.key,
    required this.batch,
    required this.keys,
    required this.child,
  });

  final QueryBatch<K> batch;
  final List<K> keys;
  final Widget child;

  @override
  State<QueryBatchRequest<K>> createState() => _QueryBatchRequestState<K>();
}

class _QueryBatchRequestState<K> extends State<QueryBatchRequest<K>> {
  void _request() => widget.batch.request(widget.keys).ignore();

  @override
  void initState() {
    super.initState();
    _request();
  }

  @override
  void didUpdateWidget(covariant QueryBatchRequest<K> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.batch != widget.batch ||
        !const ListEquality<Object?>().equals(oldWidget.keys, widget.keys)) {
      _request();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
