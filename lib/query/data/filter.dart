import 'package:flutter/foundation.dart';

// TODO: Filter controllers should be moved into an own filter module
// together with all tag filters being rewritten as general utility that includes de/serialisation and moved to that folder.
abstract class FilterController<T> extends ChangeNotifier {
  FilterController();

  List<T> filter(List<T> items);
}

extension FilterControllerPages<T> on FilterController<T> {
  List<List<T>> filterPages(List<List<T>> pages) => pages.map(filter).toList();
}
