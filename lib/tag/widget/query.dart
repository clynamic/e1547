import 'dart:math';

import 'package:e1547/client/client.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:e1547/wiki/wiki.dart';
import 'package:flutter/material.dart';

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

TagCategory? tagCategoryOf(int? id) =>
    TagCategory.values.where((e) => e.id == id).firstOrNull;

class QueryField extends StatelessWidget {
  const QueryField({
    super.key,
    required this.controller,
    this.previews = const {},
    this.focusNode,
    this.onSubmit,
    this.onChipTap,
    this.color,
  });

  final QueryFieldController controller;
  final Map<String, TagPreview> previews;
  final FocusNode? focusNode;
  final VoidCallback? onSubmit;
  final ValueChanged<int>? onChipTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ListenableBuilder(
      listenable: Listenable.merge([controller, ?focusNode]),
      builder: (context, child) {
        final bool focused = focusNode?.hasFocus ?? false;
        return Container(
          constraints: const BoxConstraints(minHeight: 44, maxHeight: 112),
          decoration: BoxDecoration(
            color: color ?? theme.cardColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: focused
                  ? theme.colorScheme.primary.withValues(alpha: 0.6)
                  : theme.colorScheme.onSurface.withValues(alpha: 0.12),
            ),
          ),
          child: SingleChildScrollView(
            primary: false,
            padding: const EdgeInsets.all(6),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: focusNode?.requestFocus,
              child: LayoutBuilder(
                builder: (context, constraints) => Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    for (final (int index, String term)
                        in controller.terms.indexed)
                      QueryChip(
                        term: term,
                        preview: previews[tagWithoutPrefix(term)],
                        selected: controller.selected == index,
                        onTap: () => onChipTap != null
                            ? onChipTap!(index)
                            : controller.select(index),
                      ),
                    QueryFieldInput(
                      controller: controller,
                      focusNode: focusNode,
                      maxWidth: constraints.maxWidth,
                      onSubmit: onSubmit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

String tagWithoutPrefix(String term) =>
    term.startsWith('-') || term.startsWith('~') ? term.substring(1) : term;

class QueryFieldInput extends StatelessWidget {
  const QueryFieldInput({
    super.key,
    required this.controller,
    required this.maxWidth,
    this.focusNode,
    this.onSubmit,
  });

  final QueryFieldController controller;
  final double maxWidth;
  final FocusNode? focusNode;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle style = theme.textTheme.bodyLarge!.copyWith(fontSize: 15);
    final String hint = controller.terms.isEmpty ? 'Search tags' : '';
    final TextPainter painter = TextPainter(
      text: TextSpan(
        text: controller.typed.isEmpty ? hint : controller.typed,
        style: style,
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    return SizedBox(
      width: min(maxWidth, max(64, painter.width + 24)),
      height: 28,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          if (controller.typed.isEmpty && hint.isNotEmpty)
            IgnorePointer(
              child: Text(
                hint,
                style: style.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
                ),
              ),
            ),
          TextField(
            controller: controller.text,
            focusNode: focusNode,
            style: style,
            textInputAction: TextInputAction.search,
            autocorrect: false,
            enableSuggestions: false,
            onSubmitted: (_) => onSubmit?.call(),
            decoration: null,
          ),
        ],
      ),
    );
  }
}

class QueryChip extends StatelessWidget {
  const QueryChip({
    super.key,
    required this.term,
    required this.selected,
    this.onTap,
    this.preview,
    this.dense = false,
  });

  final String term;
  final TagPreview? preview;
  final bool selected;
  final VoidCallback? onTap;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String prefix = term.length > 1 && (term[0] == '-' || term[0] == '~')
        ? term[0]
        : '';
    final String name = term.substring(prefix.length);
    final bool meta = name.contains(':');
    final bool unknown = !meta && preview?.postCount == 0;
    final String? words = metaWords(name);
    final int? pool = poolIdOf(name);
    final MetaKind? kind = words == null && pool == null
        ? null
        : metaKindOf(name);
    Widget label(String text) => Text.rich(
      TextSpan(
        children: [
          if (prefix.isNotEmpty)
            TextSpan(
              text: prefix,
              style: TextStyle(
                color: prefix == '~'
                    ? Colors.orange.shade300
                    : Colors.red.shade300,
              ),
            ),
          TextSpan(
            text: text,
            style: unknown
                ? TextStyle(
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.wavy,
                    decorationColor: theme.colorScheme.error,
                  )
                : null,
          ),
        ],
      ),
      maxLines: 1,
      style: dense ? const TextStyle(fontSize: 13) : null,
    );
    final Color stripe = meta || unknown
        ? Colors.grey
        : tagCategoryOf(preview?.category)?.colorFor(theme.brightness) ??
              theme.colorScheme.onSurface.withValues(alpha: 0.38);
    return Material(
      color: selected
          ? theme.colorScheme.primary.withValues(alpha: 0.16)
          : theme.colorScheme.onSurface.withValues(alpha: 0.06),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(
          color: selected ? theme.colorScheme.primary : Colors.transparent,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: dense ? 26 : 28,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 3, color: stripe),
              if (kind != null)
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Icon(kind.icon, size: dense ? 13 : 14),
                ),
              Padding(
                padding: dense
                    ? const EdgeInsets.fromLTRB(6, 0, 7, 0)
                    : const EdgeInsets.symmetric(horizontal: 6),
                child: pool == null
                    ? label(words ?? name.replaceAll('_', ' '))
                    : QueryBuilder(
                        query: context.watch<Client>().pools.useGet(id: pool),
                        builder: (context, state) => label(
                          state.data == null
                              ? 'pool #$pool'
                              : tagToName(state.data!.name),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

int? poolIdOf(String term) {
  final meta = splitMeta(term);
  if (meta == null || meta.key != 'pool') return null;
  return int.tryParse(meta.value);
}

class QueryChipActions extends StatelessWidget {
  const QueryChipActions({
    super.key,
    required this.term,
    required this.onChange,
    required this.onRemove,
  });

  final String term;
  final ValueChanged<String> onChange;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String name = tagWithoutPrefix(term);
    final bool excluded = term.startsWith('-');
    final bool any = term.startsWith('~');
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          spacing: 6,
          children: [
            QueryChipAction(
              label: excluded ? 'Include' : 'Exclude',
              icon: excluded
                  ? Icons.add_circle_outline
                  : Icons.remove_circle_outline,
              color: excluded ? Colors.green.shade300 : Colors.red.shade300,
              onTap: () => onChange(excluded ? name : '-$name'),
            ),
            QueryChipAction(
              label: 'Any of',
              icon: any ? Icons.check : Icons.alt_route,
              color: Colors.orange.shade300,
              active: any,
              onTap: () => onChange(any ? name : '~$name'),
            ),
            if (!name.contains(':'))
              QueryChipAction(
                label: 'Wiki',
                icon: Icons.menu_book,
                color: theme.colorScheme.onSurface,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => WikiLoadingPage.title(name),
                  ),
                ),
              ),
            QueryChipAction(
              label: 'Remove',
              icon: Icons.close,
              color: theme.colorScheme.error,
              onTap: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}

class QueryChipAction extends StatelessWidget {
  const QueryChipAction({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.active = false,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Expanded(
      child: Material(
        color: active ? color.withValues(alpha: 0.16) : theme.cardColor,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 56,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 2,
              children: [
                Icon(icon, color: color, size: 20),
                Text(label, style: TextStyle(fontSize: 13, color: color)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
