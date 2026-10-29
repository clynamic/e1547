import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';

const Set<MetaKind> builtMetaKinds = {
  MetaKind.date,
  MetaKind.counts,
  MetaKind.order,
  MetaKind.rating,
};

Color metaWell(ThemeData theme) => Color.alphaBlend(
  theme.colorScheme.onSurface.withValues(alpha: 0.05),
  theme.cardColor,
);

class MetaPanel extends StatelessWidget {
  const MetaPanel({
    super.key,
    required this.controller,
    required this.kind,
    required this.onPick,
    required this.onBack,
  });

  final QueryFieldController controller;
  final MetaKind? kind;
  final ValueChanged<MetaKind> onPick;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final MetaKind? kind = this.kind;
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        final String raw = kind == null
            ? ''
            : controller.terms.where((e) => metaKindOf(e) == kind).join(' ');
        return ColoredBox(
          color: Color.alphaBlend(
            Colors.black.withValues(alpha: 0.15),
            theme.cardColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 44,
                padding: const EdgeInsets.fromLTRB(4, 0, 8, 0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.06,
                      ),
                    ),
                  ),
                ),
                child: Row(
                  spacing: 8,
                  children: [
                    IconButton(
                      tooltip: kind == null ? 'Close' : 'All filters',
                      onPressed: onBack,
                      icon: Icon(
                        kind == null ? Icons.keyboard : Icons.arrow_back,
                        size: 20,
                      ),
                    ),
                    Text(
                      kind?.label ?? 'Add a filter',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        raw,
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: switch (kind) {
                  null => MetaCatalog(onPick: onPick),
                  MetaKind.date => DateBuilder(controller: controller),
                  MetaKind.counts => CountsBuilder(controller: controller),
                  MetaKind.order => OrderBuilder(controller: controller),
                  MetaKind.rating => RatingBuilder(controller: controller),
                  _ => const SizedBox.shrink(),
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class MetaCatalog extends StatelessWidget {
  const MetaCatalog({super.key, required this.onPick});

  final ValueChanged<MetaKind> onPick;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<MetaKind> kinds = MetaKind.values
        .where(builtMetaKinds.contains)
        .toList();
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 6,
      crossAxisSpacing: 6,
      childAspectRatio: 2,
      children: [
        for (final MetaKind kind in kinds)
          Material(
            color: metaWell(theme),
            borderRadius: BorderRadius.circular(4),
            child: InkWell(
              onTap: () => onPick(kind),
              borderRadius: BorderRadius.circular(4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 3,
                children: [
                  Icon(kind.icon, size: 20),
                  Text(kind.label, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class MetaLabel extends StatelessWidget {
  const MetaLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontSize: 12,
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
    ),
  );
}

class MetaOption extends StatelessWidget {
  const MetaOption({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.sub,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final String? sub;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color accent = theme.colorScheme.primary;
    return Material(
      color: selected ? accent.withValues(alpha: 0.16) : metaWell(theme),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(color: selected ? accent : Colors.transparent),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          constraints: BoxConstraints(minHeight: sub == null ? 36 : 52),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: selected ? accent : null)),
              if (sub != null)
                Text(
                  sub!,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class MetaSegments<T> extends StatelessWidget {
  const MetaSegments({
    super.key,
    required this.values,
    required this.label,
    required this.selected,
    required this.onPick,
  });

  final List<T> values;
  final String Function(T value) label;
  final T? selected;
  final ValueChanged<T> onPick;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color accent = theme.colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: metaWell(theme),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        spacing: 3,
        children: [
          for (final T value in values)
            Expanded(
              child: Material(
                color: value == selected
                    ? accent.withValues(alpha: 0.16)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(3),
                child: InkWell(
                  onTap: () => onPick(value),
                  borderRadius: BorderRadius.circular(3),
                  child: SizedBox(
                    height: 32,
                    child: Center(
                      child: Text(
                        label(value),
                        style: TextStyle(
                          fontSize: 13,
                          color: value == selected
                              ? accent
                              : theme.colorScheme.onSurface.withValues(
                                  alpha: 0.7,
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class MetaField extends StatelessWidget {
  const MetaField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.placeholder = '',
  });

  final String label;
  final String? value;
  final String placeholder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color dim = theme.colorScheme.onSurface.withValues(alpha: 0.45);
    return Material(
      color: metaWell(theme),
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 11, color: dim)),
              Text(
                value ?? placeholder,
                style: TextStyle(
                  fontSize: 16,
                  color: value == null ? dim : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

bool isMetaKey(String term, Set<String> keys) {
  final meta = splitMeta(term);
  return meta != null && keys.contains(meta.key);
}

class DateBuilder extends StatelessWidget {
  const DateBuilder({super.key, required this.controller});

  final QueryFieldController controller;

  @override
  Widget build(BuildContext context) {
    final String? value = controller.terms
        .map(splitMeta)
        .where((e) => e?.key == 'date')
        .firstOrNull
        ?.value;
    final List<String> range = value != null && value.contains('..')
        ? value.split('..')
        : const [];
    final DateTime? from = range.isEmpty ? null : DateTime.tryParse(range[0]);
    final DateTime? to = range.isEmpty ? null : DateTime.tryParse(range[1]);

    void write(String? value) => controller.replaceWhere(
      (e) => isMetaKey(e, {'date'}),
      [if (value != null) 'date:$value'],
    );

    Future<void> pick({required bool start}) async {
      final DateTime now = DateTime.now();
      final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime(2007),
        lastDate: now,
        initialDate: (start ? from : to) ?? now,
      );
      if (picked == null) return;
      final DateTime begin = start ? picked : from ?? picked;
      final DateTime end = start ? to ?? now : picked;
      write('${metaDateFormat.format(begin)}..${metaDateFormat.format(end)}');
    }

    final String yesterday = metaDateFormat.format(
      DateTime.now().subtract(const Duration(days: 1)),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        const MetaLabel('Uploaded'),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final DatePreset preset in DatePreset.values.take(1))
              MetaOption(
                label: preset.label,
                selected: value == preset.value,
                onTap: () => write(value == preset.value ? null : preset.value),
              ),
            MetaOption(
              label: 'Yesterday',
              selected: value == yesterday,
              onTap: () => write(value == yesterday ? null : yesterday),
            ),
            for (final DatePreset preset in DatePreset.values.skip(1))
              MetaOption(
                label: preset.label,
                selected: value == preset.value,
                onTap: () => write(value == preset.value ? null : preset.value),
              ),
          ],
        ),
        const SizedBox(height: 4),
        const MetaLabel('Between'),
        Row(
          spacing: 8,
          children: [
            Expanded(
              child: MetaField(
                label: 'From',
                value: from == null ? null : metaDateWords.format(from),
                placeholder: 'Any',
                onTap: () => pick(start: true),
              ),
            ),
            Expanded(
              child: MetaField(
                label: 'To',
                value: to == null ? null : metaDateWords.format(to),
                placeholder: 'Today',
                onTap: () => pick(start: false),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CountsBuilder extends StatefulWidget {
  const CountsBuilder({super.key, required this.controller});

  final QueryFieldController controller;

  @override
  State<CountsBuilder> createState() => _CountsBuilderState();
}

class _CountsBuilderState extends State<CountsBuilder> {
  late CountKind kind =
      widget.controller.terms
          .map(splitMeta)
          .map((e) => e == null ? null : CountKind.byKey(e.key))
          .whereType<CountKind>()
          .firstOrNull ??
      CountKind.score;

  static const List<int> presets = [10, 50, 100, 500, 1000];

  ({int? min, int? max}) bounds() {
    final String? value = widget.controller.terms
        .map(splitMeta)
        .where((e) => e?.key == kind.key)
        .firstOrNull
        ?.value;
    if (value == null) return (min: null, max: null);
    if (value.startsWith('>=')) {
      return (min: int.tryParse(value.substring(2)), max: null);
    }
    if (value.startsWith('<=')) {
      return (min: null, max: int.tryParse(value.substring(2)));
    }
    if (value.contains('..')) {
      final List<String> parts = value.split('..');
      return (min: int.tryParse(parts[0]), max: int.tryParse(parts[1]));
    }
    final int? exact = int.tryParse(value);
    return (min: exact, max: exact);
  }

  void write(int? min, int? max) =>
      widget.controller.replaceWhere((e) => isMetaKey(e, {kind.key}), [
        if (min != null && max != null)
          '${kind.key}:$min..$max'
        else if (min != null)
          '${kind.key}:>=$min'
        else if (max != null)
          '${kind.key}:<=$max',
      ]);

  Future<void> edit({required bool lower}) async {
    final bounds = this.bounds();
    final TextEditingController text = TextEditingController(
      text: '${(lower ? bounds.min : bounds.max) ?? ''}',
    );
    final String? result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(lower ? 'At least' : 'At most'),
        content: TextField(
          controller: text,
          autofocus: true,
          keyboardType: TextInputType.number,
          onSubmitted: (value) => Navigator.of(context).pop(value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(''),
            child: const Text('No limit'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(text.text),
            child: const Text('Set'),
          ),
        ],
      ),
    );
    text.dispose();
    if (result == null) return;
    final int? value = int.tryParse(result);
    if (lower) {
      write(value, bounds.max);
    } else {
      write(bounds.min, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bounds = this.bounds();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        MetaSegments<CountKind>(
          values: CountKind.values,
          label: (e) => e.label,
          selected: kind,
          onPick: (value) => setState(() => kind = value),
        ),
        Row(
          spacing: 8,
          children: [
            Expanded(
              child: MetaField(
                label: 'At least',
                value: bounds.min?.toString(),
                placeholder: 'No limit',
                onTap: () => edit(lower: true),
              ),
            ),
            Expanded(
              child: MetaField(
                label: 'At most',
                value: bounds.max?.toString(),
                placeholder: 'No limit',
                onTap: () => edit(lower: false),
              ),
            ),
          ],
        ),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final int preset in presets)
              MetaOption(
                label: '≥ $preset',
                selected: bounds.min == preset && bounds.max == null,
                onTap: () => write(
                  bounds.min == preset && bounds.max == null ? null : preset,
                  null,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class OrderBuilder extends StatelessWidget {
  const OrderBuilder({super.key, required this.controller});

  final QueryFieldController controller;

  @override
  Widget build(BuildContext context) {
    final String? value = controller.terms
        .map(splitMeta)
        .where((e) => e?.key == 'order')
        .firstOrNull
        ?.value;
    final ({MetaOrder order, bool lowest}) parsed =
        (value != null ? MetaOrder.parse(value) : null) ??
        (order: MetaOrder.newest, lowest: false);
    final MetaOrder order = parsed.order;
    final bool lowest = parsed.lowest;

    void write(MetaOrder order, {required bool lowest}) =>
        controller.replaceWhere((e) => isMetaKey(e, {'order'}), [
          ?order.term(lowest: lowest),
        ]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          childAspectRatio: 4.2,
          children: [
            for (final MetaOrder value in MetaOrder.values)
              MetaOption(
                label: value.label,
                selected: value == order,
                onTap: () => write(value, lowest: lowest),
              ),
          ],
        ),
        if (order.directed)
          MetaSegments<bool>(
            values: const [false, true],
            label: (e) => e ? 'Lowest first' : 'Highest first',
            selected: lowest,
            onPick: (value) => write(order, lowest: value),
          ),
      ],
    );
  }
}

class RatingBuilder extends StatelessWidget {
  const RatingBuilder({super.key, required this.controller});

  final QueryFieldController controller;

  @override
  Widget build(BuildContext context) {
    final String? value = controller.terms
        .map(splitMeta)
        .where((e) => e?.key == 'rating')
        .firstOrNull
        ?.value;
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        MetaOption(
          label: 'Any',
          selected: value == null,
          onTap: () =>
              controller.replaceWhere((e) => isMetaKey(e, {'rating'}), []),
        ),
        for (final MapEntry(key: key, value: name) in ratingNames.entries)
          MetaOption(
            label: name,
            selected: value == key,
            onTap: () => controller.replaceWhere(
              (e) => isMetaKey(e, {'rating'}),
              ['rating:$key'],
            ),
          ),
      ],
    );
  }
}
