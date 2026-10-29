import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnyRouteObserver extends RouteObserver<Route<Object?>> {}

class DefaultRouteObserver extends Provider<AnyRouteObserver> {
  DefaultRouteObserver({super.key, super.child})
    : super(create: (context) => AnyRouteObserver());
}

mixin DefaultRouteAware<T extends StatefulWidget> on State<T>
    implements RouteAware {
  AnyRouteObserver? _routeObserver;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _routeObserver?.unsubscribe(this);
    _routeObserver = context.watch<AnyRouteObserver>();
    _routeObserver!.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void reassemble() {
    super.reassemble();
    _routeObserver?.unsubscribe(this);
    _routeObserver = context.read<AnyRouteObserver>();
    _routeObserver!.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    _routeObserver?.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {}

  @override
  void didPush() {}

  @override
  void didPop() {}

  @override
  void didPushNext() {}
}
