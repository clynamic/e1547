import 'package:e1547/post/post.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';

class PostSearchDock extends StatelessWidget {
  const PostSearchDock({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final PostParamsController params = context.watch<PostParamsController>();
    if (!params.canSearch) return child;
    final PostFilter filter = context.watch<PostFilter>();
    return DockLayout(
      onTap: () => showPostSearchSheet(context),
      mark: const Icon(Icons.search),
      content: Row(
        spacing: 12,
        children: [
          Expanded(child: QueryLine(query: params.value.tags ?? '')),
          ListenableBuilder(
            listenable: filter,
            builder: (context, child) {
              if (!filter.denying || filter.blockedCount == 0) {
                return const SizedBox.shrink();
              }
              return HiddenCount(count: filter.blockedCount);
            },
          ),
        ],
      ),
      child: child,
    );
  }
}

class QueryLine extends StatelessWidget {
  const QueryLine({super.key, required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<String> tokens = query.split(RegExp(r'\s+'))
      ..removeWhere((e) => e.isEmpty);
    if (tokens.isEmpty) {
      return Text(
        'Search',
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      );
    }
    return ClipRect(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Row(
          spacing: 10,
          children: [for (final String token in tokens) QueryToken(token)],
        ),
      ),
    );
  }
}

class QueryToken extends StatelessWidget {
  const QueryToken(this.token, {super.key});

  final String token;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String prefix = switch (token[0]) {
      '-' || '~' => token[0],
      _ => '',
    };
    final String name = token.substring(prefix.length).replaceAll('_', ' ');
    return Container(
      padding: const EdgeInsets.only(left: 5),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 2,
            color: name.contains(':')
                ? Colors.grey
                : theme.colorScheme.onSurface.withValues(alpha: 0.38),
          ),
        ),
      ),
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
            TextSpan(text: name),
          ],
        ),
        maxLines: 1,
        style: theme.textTheme.bodyLarge?.copyWith(fontSize: 15, height: 1.2),
      ),
    );
  }
}

class HiddenCount extends StatelessWidget {
  const HiddenCount({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = theme.colorScheme.onSurface.withValues(alpha: 0.6);
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        Icon(Icons.block, size: 14, color: color),
        Text(
          '$count',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 13,
            color: color,
          ),
        ),
      ],
    );
  }
}

Future<void> showPostSearchSheet(BuildContext context) {
  final PostParamsController params = context.read<PostParamsController>();
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).canvasColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
    ),
    builder: (context) => PostSearchSheet(
      query: params.value.tags ?? '',
      onSubmit: (value) =>
          params.update((p) => p.copyWith(tags: TagMap(value).toString())),
    ),
  );
}

class PostSearchSheet extends StatefulWidget {
  const PostSearchSheet({
    super.key,
    required this.query,
    required this.onSubmit,
  });

  final String query;
  final ValueSetter<String> onSubmit;

  @override
  State<PostSearchSheet> createState() => _PostSearchSheetState();
}

class _PostSearchSheetState extends State<PostSearchSheet> {
  late final TextEditingController controller = TextEditingController(
    text: widget.query.isEmpty ? '' : '${widget.query} ',
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void submit() {
    widget.onSubmit(controller.text);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool left = Handedness.of(context) == Handedness.left;
    final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.12),
      ),
    );
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                width: 32,
                height: 3,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                spacing: 10,
                children: [
                  Row(
                    textDirection: left ? TextDirection.rtl : TextDirection.ltr,
                    children: [
                      const Spacer(),
                      SizedBox.square(
                        dimension: dockHeight,
                        child: Material(
                          color: theme.colorScheme.secondary,
                          elevation: 3,
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            onTap: submit,
                            borderRadius: BorderRadius.circular(8),
                            child: Icon(
                              Icons.search,
                              color: theme.colorScheme.onSecondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TagInput(
                    controller: controller,
                    autofocus: true,
                    direction: VerticalDirection.up,
                    textInputAction: TextInputAction.search,
                    submit: (_) => submit(),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: theme.cardColor,
                      border: border,
                      enabledBorder: border,
                      focusedBorder: border.copyWith(
                        borderSide: BorderSide(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
