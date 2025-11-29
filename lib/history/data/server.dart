import 'dart:async';

import 'package:drift/drift.dart';
import 'package:e1547/history/history.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter/foundation.dart';

class HistoryServer with Disposable {
  HistoryServer({
    required GeneratedDatabase database,
    required this.identity,
    required this.traits,
  }) : repository = HistoryRepository(database: database);

  final HistoryRepository repository;
  final Identity identity;
  final ValueNotifier<Traits> traits;

  Timer? _trimTimer;

  static const int trimAmount = 5000;
  static const Duration trimAge = Duration(days: 30 * 3);

  Future<History> get({
    required int id,
    bool? force,
    CancelToken? cancelToken,
  }) => repository.get(id);

  Future<List<History>> page({
    int? page,
    int? limit,
    QueryMap? query,
    bool? force,
    CancelToken? cancelToken,
  }) {
    final search = HistoryParams(query);
    return repository.page(
      identity: identity.id,
      page: page,
      limit: limit,
      day: search.date,
      link: search.link?.infixRegex,
      category: search.categories,
      type: search.types,
      title: search.title?.infixRegex,
      subtitle: search.subtitle?.infixRegex,
    );
  }

  Future<void> removeAll(List<int>? ids) =>
      repository.removeAll(ids, identity: identity.id);

  Future<int> count() => repository.length(identity: identity.id);

  Future<List<DateTime>> days() => repository.days(identity: identity.id);

  Future<void> add(HistoryRequest request) async {
    if (!(traits.value.writeHistory ?? true)) return;

    await repository.transaction(() async {
      // TODO: replace this with a Provider above an Area that caches history in memory in the UI
      if (await repository.isDuplicate(request)) return;
      await repository.add(request, identity.id);
    });

    _scheduleTrim();
  }

  void _scheduleTrim() {
    if (!(traits.value.trimHistory ?? false)) return;
    if (_trimTimer != null) return;

    _trimTimer?.cancel();
    _trimTimer = Timer(const Duration(minutes: 1), () async {
      _trimTimer = null;
      await _performTrim();
    });
  }

  Future<void> _performTrim() async {
    if (!(traits.value.trimHistory ?? false)) return;

    await repository.trim(
      maxAmount: trimAmount,
      maxAge: trimAge,
      identity: identity.id,
    );
  }

  @override
  void dispose() {
    _trimTimer?.cancel();
    super.dispose();
  }
}
