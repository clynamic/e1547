import 'package:e1547/post/post.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class NameSearchSheet<P> extends StatefulWidget {
  const NameSearchSheet({
    super.key,
    required this.params,
    required this.name,
    required this.hint,
    required this.suggestions,
    required this.filters,
    required this.onSubmit,
  });

  final P params;
  final String? name;
  final String hint;
  final Widget Function(P params, String typed) suggestions;
  final Widget Function(
    P params,
    ValueChanged<P> onChange,
    VoidCallback onClose,
  )
  filters;
  final void Function(P params, String? name) onSubmit;

  @override
  State<NameSearchSheet<P>> createState() => _NameSearchSheetState<P>();
}

class _NameSearchSheetState<P> extends State<NameSearchSheet<P>> {
  late final TextEditingController text = TextEditingController(
    text: widget.name,
  );
  final FocusNode focus = FocusNode();
  late P params = widget.params;
  bool filters = false;

  @override
  void initState() {
    super.initState();
    focus.addListener(_onFocus);
  }

  void _onFocus() {
    if (focus.hasFocus && filters) setState(() => filters = false);
  }

  @override
  void dispose() {
    focus.removeListener(_onFocus);
    text.dispose();
    focus.dispose();
    super.dispose();
  }

  void submit() {
    final String name = text.text.trim();
    widget.onSubmit(params, name.isEmpty ? null : name);
    Navigator.of(context).pop();
  }

  void _toggleFilters() {
    if (!filters) focus.unfocus();
    setState(() => filters = !filters);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool typing = MediaQuery.viewInsetsOf(context).bottom > 0;
    final bool left = Handedness.of(context) == Handedness.left;
    final Color well = wellColor(theme);
    return ListenableBuilder(
      listenable: Listenable.merge([text, focus]),
      builder: (context, child) {
        final String typed = text.text.trim();
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SheetGrip(),
            if (!filters && typed.isNotEmpty)
              Debounced(
                value: typed,
                builder: (context, typed) => widget.suggestions(params, typed),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
              child: Row(
                textDirection: left ? TextDirection.rtl : TextDirection.ltr,
                spacing: 6,
                children: [
                  SheetButton(
                    color: well,
                    selected: filters,
                    onTap: _toggleFilters,
                    icon: Icons.tune,
                    tooltip: 'Filters',
                  ),
                  const Spacer(),
                  SheetSearchButton(typing: typing, onTap: submit),
                ],
              ),
            ),
            Padding(
              key: const ValueKey('field'),
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
              child: SheetTextField(
                controller: text,
                focusNode: focus,
                hint: widget.hint,
                color: well,
                onSubmit: submit,
              ),
            ),
            if (filters)
              Flexible(
                child: SingleChildScrollView(
                  primary: false,
                  child: widget.filters(
                    params,
                    (value) => setState(() => params = value),
                    _toggleFilters,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class SheetTextField extends StatelessWidget {
  const SheetTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.color,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final Color color;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    OutlineInputBorder border(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(color: color),
    );
    return TextField(
      controller: controller,
      focusNode: focusNode,
      autocorrect: false,
      enableSuggestions: false,
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => onSubmit(),
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: color,
        hintText: hint,
        hintStyle: TextStyle(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 13,
        ),
        enabledBorder: border(
          theme.colorScheme.onSurface.withValues(alpha: 0.12),
        ),
        focusedBorder: border(theme.colorScheme.primary.withValues(alpha: 0.6)),
      ),
    );
  }
}

class NameSearchDock extends StatelessWidget {
  const NameSearchDock({
    super.key,
    required this.params,
    required this.name,
    required this.hint,
    required this.words,
    required this.onOpen,
  });

  final Listenable params;
  final String? Function() name;
  final String hint;
  final String Function() words;
  final Future<void> Function(AnimationController? transition) onOpen;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SearchDock(
      onOpen: onOpen,
      child: ListenableBuilder(
        listenable: params,
        builder: (context, child) {
          final String name = this.name() ?? '';
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name.isEmpty ? hint : name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  color: name.isEmpty
                      ? theme.colorScheme.onSurface.withValues(alpha: 0.45)
                      : null,
                ),
              ),
              Text(
                words(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Future<void> showFloatingSearchSheet(
  BuildContext context, {
  required WidgetBuilder builder,
  AnimationController? transition,
}) => showModalBottomSheet<void>(
  context: context,
  useRootNavigator: true,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  elevation: 0,
  transitionAnimationController: transition,
  builder: (sheetContext) => FloatingSheet(child: builder(sheetContext)),
);
