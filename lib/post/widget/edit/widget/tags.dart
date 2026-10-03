import 'package:e1547/client/client.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/logs/logs.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:e1547/ticket/ticket.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TagsEditDisplay extends StatefulWidget {
  const TagsEditDisplay({super.key, required this.controller, this.enabled});

  final TextEditingController controller;
  final bool? enabled;

  @override
  State<TagsEditDisplay> createState() => _TagsEditDisplayState();
}

class _TagsEditDisplayState extends State<TagsEditDisplay> {
  final Map<String, TagPreview> _tagCache = {};
  bool _isPreviewMode = false;
  final Logger _logger = Logger('TagPreview');

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTagsChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTagsChanged);
    super.dispose();
  }

  void _onTagsChanged() {
    if (_isPreviewMode && mounted) {
      _fetchTagPreview();
    }
  }

  List<String> get _tagsArray {
    return TagMap(widget.controller.text).tags;
  }

  List<TagPreview> get _tagRecords {
    final result = <TagPreview>[];
    final implications = <String, List<String>>{};

    for (final input in _tagsArray) {
      final tag = _tagCache[input];
      if (tag != null) {
        result.add(tag);
        if (tag.implies != null && tag.implies!.isNotEmpty) {
          for (final implication in tag.implies!) {
            implications.putIfAbsent(implication, () => []).add(tag.name);
          }
        }
      } else {
        result.add(TagPreview(id: -1, name: input));
      }
    }

    for (final entry in implications.entries) {
      final implication = entry.key;
      final existing = result
          .where((tag) => tag.name == implication)
          .firstOrNull;
      if (existing == null) {
        final implied = _tagCache[implication];
        if (implied != null) {
          result.add(implied);
        }
      }
    }

    return result;
  }

  Future<void> _fetchTagPreview() async {
    final missing = _tagsArray
        .where((tag) => !_tagCache.containsKey(tag))
        .toList();
    if (missing.isEmpty) return;

    // Resolved up front, the context must not cross async gaps.
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);

    try {
      final client = context.read<Client>().tags;
      final previews = await client.preview(tags: missing.join(' '));

      setState(() {
        for (final preview in previews) {
          _tagCache[preview.name] = preview;
        }
      });
    } on Exception catch (e, stackTrace) {
      _logger.warn('Tag preview failed', null, e, stackTrace);
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.editTagPreviewFailed(e.toString()))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: defaultFormPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.filterTags,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              IconButton(
                onPressed: widget.enabled == false
                    ? null
                    : () {
                        setState(() {
                          _isPreviewMode = !_isPreviewMode;
                        });
                        if (_isPreviewMode) {
                          _fetchTagPreview();
                        }
                      },
                icon: Icon(_isPreviewMode ? Icons.edit : Icons.visibility),
                tooltip: _isPreviewMode ? l10n.menuEdit : l10n.editorPreview,
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_isPreviewMode) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(4),
              ),
              child: _tagRecords.isNotEmpty
                  ? Wrap(
                      children: _tagRecords
                          .map((tag) => TagPreviewCard(tag: tag))
                          .toList(),
                    )
                  : Text(
                      l10n.tagNoTags,
                      style: TextStyle(
                        color: dimTextColor(context),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
            ),
          ] else ...[
            TagInput(
              controller: widget.controller,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: l10n.editTagsHint,
              ),
              readOnly: widget.enabled == false,
              autofocus: false,
              cutoutForFab: false,
              maxLines: null,
              textInputAction: TextInputAction.newline,
            ),
          ],
        ],
      ),
    );
  }
}

class TagPreviewCard extends StatelessWidget {
  const TagPreviewCard({super.key, required this.tag});

  final TagPreview tag;

  String _formatTagCount(int count) {
    return NumberFormat.compact().format(count).toLowerCase();
  }

  String _getDisplayName() {
    return tag.alias ?? tag.resolved ?? tag.name;
  }

  Widget? _getStatusText(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    if (tag.id == null) {
      return Text(
        l10n.editTagStatusNew,
        style: TextStyle(fontSize: 10, color: theme.colorScheme.primary),
      );
    } else if (tag.category == TagCategory.invalid.id) {
      return Text(
        l10n.editTagStatusInvalid,
        style: TextStyle(fontSize: 10, color: theme.colorScheme.error),
      );
    } else if (tag.postCount == 0) {
      return Text(
        l10n.editTagStatusEmpty,
        style: TextStyle(fontSize: 10, color: theme.colorScheme.tertiary),
      );
    } else if (tag.postCount == 1 && tag.category == TagCategory.general.id) {
      // Underused general tag
      return Text(
        l10n.editTagStatusUnderused,
        style: TextStyle(fontSize: 10, color: theme.colorScheme.secondary),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final statusText = _getStatusText(context);

    Widget? trailing;
    if (statusText != null) {
      trailing = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 2,
            height: 18,
            color: Theme.of(context).dividerColor,
          ),
          Flexible(
            child: Padding(padding: const EdgeInsets.all(4), child: statusText),
          ),
        ],
      );
    } else if (tag.postCount != null) {
      trailing = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 2,
            height: 18,
            color: Theme.of(context).dividerColor,
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(_formatTagCount(tag.postCount!)),
            ),
          ),
        ],
      );
    }

    return ColoredCard(
      color: tag.category == null
          ? Colors.grey
          : TagCategory.byId(tag.category!).color,
      onTap: () => showTagSearchPrompt(context: context, tag: tag.name),
      onLongPress: () => showTagSearchPrompt(context: context, tag: tag.name),
      onSecondaryTap: () =>
          showTagSearchPrompt(context: context, tag: tag.name),
      trailing: trailing,
      child: Text(
        tagToTitle(_getDisplayName()),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
