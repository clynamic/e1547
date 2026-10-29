import 'dart:math';

import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';

const String _anchor = '​';

class QueryFieldController extends ChangeNotifier {
  QueryFieldController({String query = ''}) {
    _terms.addAll(_split(query));
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
      value.split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();

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
      _terms.addAll(parts.where((e) => e.isNotEmpty));
      _selected = null;
    }
    if (value.isNotEmpty) _selected = null;
    if (raw != '$_anchor$value') _write(value);
    notifyListeners();
  }

  void commit([String? term]) {
    _terms.addAll(_split(term ?? typed));
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

TagCategory? tagCategoryOf(int? id) =>
    TagCategory.values.where((e) => e.id == id).firstOrNull;

class QueryField extends StatelessWidget {
  const QueryField({
    super.key,
    required this.controller,
    this.previews = const {},
    this.focusNode,
    this.onSubmit,
  });

  final QueryFieldController controller;
  final Map<String, TagPreview> previews;
  final FocusNode? focusNode;
  final VoidCallback? onSubmit;

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
            color: theme.cardColor,
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
                      onTap: () => controller.select(index),
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
      child: TextField(
        controller: controller.text,
        focusNode: focusNode,
        style: style,
        textInputAction: TextInputAction.search,
        autocorrect: false,
        enableSuggestions: false,
        onSubmitted: (_) => onSubmit?.call(),
        decoration: InputDecoration.collapsed(
          hintText: hint,
          hintStyle: style.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
          ),
        ),
      ),
    );
  }
}

class QueryChip extends StatelessWidget {
  const QueryChip({
    super.key,
    required this.term,
    required this.selected,
    required this.onTap,
    this.preview,
  });

  final String term;
  final TagPreview? preview;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String prefix = term.length > 1 && (term[0] == '-' || term[0] == '~')
        ? term[0]
        : '';
    final String name = term.substring(prefix.length);
    final bool meta = name.contains(':');
    final Color stripe = meta
        ? Colors.grey
        : tagCategoryOf(preview?.category)?.color ??
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
          height: 28,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 3, color: stripe),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text.rich(
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
                      TextSpan(text: name.replaceAll('_', ' ')),
                    ],
                  ),
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
