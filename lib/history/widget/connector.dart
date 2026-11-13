import 'package:e1547/client/client.dart';
import 'package:e1547/history/history.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

typedef HistoryConnector<T> =
    HistoryRequest Function(BuildContext context, T data);

class ItemHistoryConnector<T> extends StatefulWidget {
  const ItemHistoryConnector({
    super.key,
    required this.item,
    required this.getEntry,
    required this.child,
  });

  final T item;
  final HistoryConnector<T> getEntry;
  final Widget child;

  @override
  State<ItemHistoryConnector<T>> createState() =>
      _ItemHistoryConnectorState<T>();
}

class _ItemHistoryConnectorState<T> extends State<ItemHistoryConnector<T>> {
  T? added;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _add();
  }

  @override
  void didUpdateWidget(covariant ItemHistoryConnector<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _add();
  }

  void _add() {
    if (widget.item == added || isSkeleton(context)) return;
    added = widget.item;
    final client = context.read<Client>();
    final request = widget.getEntry(context, widget.item);
    client.histories.useAdd().mutate(request);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class QueryHistoryConnector<S> extends StatelessWidget {
  const QueryHistoryConnector({
    super.key,
    required this.query,
    required this.getEntry,
    required this.child,
  });

  final Cacheable<S> query;
  final HistoryRequest? Function(BuildContext context, S state) getEntry;
  final Widget child;

  @override
  Widget build(BuildContext context) => QueryOnceConnector<S, HistoryRequest>(
    query: query,
    getRequest: getEntry,
    onRequest: (context, request) =>
        context.read<Client>().histories.useAdd().mutate(request),
    child: child,
  );
}
