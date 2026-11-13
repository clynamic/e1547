import 'dart:async';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

typedef QueryRequestBuilder<S, R> = R? Function(BuildContext context, S state);

typedef QueryRequestCallback<R> =
    void Function(BuildContext context, R request);

class QueryOnceConnector<S, R> extends StatefulWidget {
  const QueryOnceConnector({
    super.key,
    required this.query,
    required this.getRequest,
    required this.onRequest,
    required this.child,
  });

  final Cacheable<S> query;
  final QueryRequestBuilder<S, R> getRequest;
  final QueryRequestCallback<R> onRequest;
  final Widget child;

  @override
  State<QueryOnceConnector<S, R>> createState() =>
      _QueryOnceConnectorState<S, R>();
}

class _QueryOnceConnectorState<S, R> extends State<QueryOnceConnector<S, R>> {
  StreamSubscription<S>? _sub;
  bool _sent = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_sub == null && !isSkeleton(context)) _subscribe();
  }

  @override
  void didUpdateWidget(covariant QueryOnceConnector<S, R> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(widget.query, oldWidget.query) && _sub != null) {
      _sub?.cancel();
      _sent = false;
      _subscribe();
    }
  }

  void _subscribe() {
    _try(widget.query.state);
    _sub = widget.query.stream.listen(_try);
  }

  void _try(S state) {
    if (_sent || !mounted) return;
    final request = widget.getRequest(context, state);
    if (request == null) return;
    _sent = true;
    widget.onRequest(context, request);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
