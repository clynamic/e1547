import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';

class TagDisplay extends StatefulWidget {
  const TagDisplay({super.key, required this.post});

  final Post post;

  @override
  State<TagDisplay> createState() => _TagDisplayState();
}

class _TagDisplayState extends State<TagDisplay> {
  Map<String, String>? _translations;
  bool _loading = false;

  late final List<String> _allTags = widget.post.tags.values
      .expand((tags) => tags)
      .map(tagToTitle)
      .toList();

  Future<void> _toggle() async {
    if (_loading) {
      return;
    }
    if (_translations != null) {
      setState(() => _translations = null);
      return;
    }
    setState(() => _loading = true);
    final Map<String, String> translations = await Translator.translateAll(
      _allTags,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _translations = translations;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget tagCategory(String category) {
      return Wrap(
        children: [
          ...widget.post.tags[category]!.map(
            (tag) => TagCard(
              tag: tag,
              category: category,
              translation: _translations?[tagToTitle(tag)],
            ),
          ),
        ],
      );
    }

    Widget categoryTile(String category) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Text(
              t('${category[0].toUpperCase()}${category.substring(1)}'),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Row(children: [Expanded(child: tagCategory(category))]),
          const Divider(),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Text(t('Tags'), style: const TextStyle(fontSize: 16)),
              const Spacer(),
              if (_loading)
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: SizedCircularProgressIndicator(size: 16),
                )
              else
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    _translations != null ? Icons.undo : Icons.translate,
                    size: 20,
                  ),
                  tooltip: t(_translations != null ? 'Show original' : 'Translate'),
                  onPressed: _toggle,
                ),
            ],
          ),
        ),
        ...widget.post.tags.keys
            .where((category) => widget.post.tags[category]?.isNotEmpty ?? false)
            .map((category) => categoryTile(category)),
      ],
    );
  }
}
