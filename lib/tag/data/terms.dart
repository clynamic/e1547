import 'package:e1547/tag/tag.dart';
import 'package:flutter/widgets.dart';

const String _anchor = '​';

class QueryFieldController extends ChangeNotifier {
  QueryFieldController({String query = ''}) {
    _add(_split(query));
    text.addListener(_onText);
  }

  final TextEditingController text = TextEditingController(text: _anchor);

  final List<String> _terms = [];
  int? _selected;
  bool _writing = false;

  List<String> get terms => List.unmodifiable(_terms);

  int? get selected => _selected;

  String get typed => text.text.replaceAll(_anchor, '');

  String get query =>
      [..._terms, if (typed.trim().isNotEmpty) typed.trim()].join(' ');

  static List<String> _split(String value) =>
      splitQueryTerms(value.split(RegExp(r'\s+')));

  void _add(Iterable<String> terms) {
    for (final String term in terms) {
      final String name = tagWithoutPrefix(term);
      final int existing = _terms.indexWhere(
        (e) => tagWithoutPrefix(e) == name,
      );
      if (existing == -1) {
        _terms.add(term);
      } else {
        _terms[existing] = term;
      }
    }
  }

  void _write(String value) {
    _writing = true;
    text.value = TextEditingValue(
      text: '$_anchor$value',
      selection: TextSelection.collapsed(offset: value.length + 1),
    );
    _writing = false;
  }

  void _onText() {
    if (_writing) return;
    final String raw = text.text;
    String value = raw.replaceAll(_anchor, '');
    if (!raw.startsWith(_anchor) && value.isEmpty) {
      _write('');
      backspace();
      return;
    }
    if (value.contains(RegExp(r'\s'))) {
      final List<String> parts = value.split(RegExp(r'\s+'));
      value = parts.removeLast();
      _add(splitQueryTerms(parts));
      _selected = null;
    }
    if (value.isNotEmpty) _selected = null;
    if (raw != '$_anchor$value') _write(value);
    notifyListeners();
  }

  void commit([String? term]) {
    _add(_split(term ?? typed));
    _selected = null;
    _write('');
    notifyListeners();
  }

  void backspace() {
    if (_terms.isEmpty) return;
    if (_selected == null) {
      _selected = _terms.length - 1;
    } else {
      _terms.removeAt(_selected!);
      _selected = null;
    }
    notifyListeners();
  }

  void select(int? index) {
    _selected = index == _selected ? null : index;
    notifyListeners();
  }

  void remove(int index) {
    _terms.removeAt(index);
    _selected = null;
    notifyListeners();
  }

  void replaceWhere(bool Function(String term) test, List<String> terms) {
    final int at = _terms.indexWhere(test);
    _terms.removeWhere(test);
    _terms.insertAll(at == -1 ? _terms.length : at, terms);
    _selected = null;
    notifyListeners();
  }

  void replace(int index, String term) {
    _terms[index] = term;
    notifyListeners();
  }

  @override
  void dispose() {
    text.dispose();
    super.dispose();
  }
}

List<String> splitQueryTerms(Iterable<String> words) {
  final List<String> terms = [];
  List<String>? group;
  for (final String word in words.where((e) => e.isNotEmpty)) {
    if (group != null) {
      group.add(word);
      if (word == ')') {
        terms.add(group.join(' '));
        group = null;
      }
    } else if (word == '(' || word == '-(') {
      group = [word];
    } else {
      terms.add(word);
    }
  }
  if (group != null) terms.addAll(group);
  return terms;
}

String tagWithoutPrefix(String term) =>
    term.startsWith('-') || term.startsWith('~') ? term.substring(1) : term;

int? poolIdOf(String term) {
  final meta = splitMeta(term);
  if (meta == null || meta.key != 'pool') return null;
  return int.tryParse(meta.value);
}
