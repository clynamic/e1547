import 'package:collection/collection.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sub/flutter_sub.dart';
import 'package:intl/intl.dart';

class TagInput extends StatelessWidget {
  const TagInput({
    super.key,
    required this.controller,
    this.submit,
    this.multiInput = true,
    this.category,
    this.direction,
    this.readOnly = false,
    this.autofocus,
    this.labelText,
    this.decoration,
    this.textInputAction,
    this.focusNode,
    this.maxLines = 1,
    this.cutoutForFab,
    this.metatagSuggestions = false,
  });

  final SubmitString? submit;
  final TextEditingController? controller;
  final bool multiInput;
  final int? category;
  final VerticalDirection? direction;
  final bool readOnly;
  final bool? autofocus;
  final String? labelText;
  final InputDecoration? decoration;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final int? maxLines;
  final bool? cutoutForFab;

  /// Whether to suggest fixed metatag values for inputs like `order:`.
  ///
  /// The server's autocomplete rejects searches that contain a colon, so
  /// these suggestions are served from a local directory instead. Only inputs
  /// whose tags reach the server should enable this; tag inputs that match
  /// locally (like the denylist) must keep it off.
  final bool metatagSuggestions;

  int findTag(List<String> tags, int offset) {
    List<String> before = [];
    for (final tag in tags) {
      before.add(tag);
      if (before.join(' ').length >= offset) {
        return tags.indexOf(tag);
      }
    }
    return tags.length - 1;
  }

  @override
  Widget build(BuildContext context) {
    return SubDefault<TextEditingController>(
      value: controller,
      create: TextEditingController.new,
      builder: (context, controller) => SubValue(
        create: () {
          if (controller.text.isNotEmpty) {
            controller.text = controller.text.trimRight();
            controller.text += ' ';
          }
          return controller;
        },
        keys: [controller],
        builder: (context, controller) => AutocompleteTextField<TagSuggestion>(
          controller: controller,
          submit: submit,
          direction: direction,
          readOnly: readOnly,
          autofocus: autofocus ?? true,
          labelText: labelText,
          decoration: decoration,
          inputFormatters: [
            LowercaseTextInputFormatter(),
            if (!multiInput) FilteringTextInputFormatter.deny(' '),
          ],
          private: PrivateTextFields.of(context),
          textInputAction: textInputAction,
          focusNode: focusNode,
          maxLines: maxLines,
          cutoutForFab: cutoutForFab ?? true,
          onSelected: (suggestion) {
            List<String> tags = controller.text.split(' ');
            int selection = findTag(tags, controller.selection.extent.offset);
            String tag = tags[selection];
            // A stale suggestion can outlive the text it belonged to, like
            // after picking one suggestion right after another, which leaves
            // the current tag empty.
            if (tag.isEmpty) return;
            String operator = tag[0];
            if (['-', '~'].contains(operator)) {
              tags[selection] = tag.substring(1);
            } else {
              operator = '';
            }
            tags[selection] = operator + suggestion.insertText;
            controller.text = '${tags.join(' ')} ';
            controller.setFocusToEnd();
          },
          itemBuilder: (context, suggestion) => switch (suggestion) {
            TagNameSuggestion(:final tag) => Row(
              children: [
                Container(
                  color: TagCategory.values
                      .firstWhereOrNull((e) => e.id == tag.category)
                      ?.color,
                  height: 54,
                  width: 5,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      tag.name,
                      style: const TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    NumberFormat.compact().format(tag.count),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            MetatagValueSuggestion() => Row(
              children: [
                Container(color: TagCategory.meta.color, height: 54, width: 5),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      suggestion.insertText,
                      style: const TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    localizedFilterName(context, suggestion.name),
                    style: TextStyle(
                      fontSize: 16,
                      color: dimTextColor(context),
                    ),
                  ),
                ),
              ],
            ),
          },
          suggestionsCallback: (pattern) async {
            List<String> tags = controller.text.split(' ');
            int selection = findTag(tags, controller.selection.extent.offset);
            String tag = tags[selection];
            if (tag.isEmpty) return [];
            final raw = tagToRaw(tag);
            // The server's autocomplete rejects colons, so metatags get their
            // values from the local directory instead.
            if (metatagSuggestions && raw.contains(':')) {
              return suggestMetatagValues(raw);
            }
            final client = context.read<Client>();
            return [
              for (final tag in await client.tags.autocomplete(
                search: raw,
                category: category,
                limit: 3,
              ))
                TagNameSuggestion(tag),
            ];
          },
        ),
      ),
    );
  }
}
