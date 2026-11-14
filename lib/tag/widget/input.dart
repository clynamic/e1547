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
            tags[selection] = suggestion.name;
            final String text = tags.join(' ');
            controller.text = suggestion.complete ? '$text ' : text;
            controller.setFocusToEnd();
          },
          itemBuilder: (context, value) => Row(
            children: [
              Container(
                color: TagCategory.values
                    .firstWhereOrNull((e) => e.id == value.category)
                    ?.colorFor(Theme.of(context).brightness),
                height: 54,
                width: 5,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    value.name,
                    style: const TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              if (value.count case final int count)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    NumberFormat.compact().format(count),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
            ],
          ),
          suggestionsCallback: (pattern) async {
            final client = context.read<Client>();
            List<String> tags = controller.text.split(' ');
            int selection = findTag(tags, controller.selection.extent.offset);
            String tag = tags[selection];
            if (tag.isEmpty) return [];
            return suggestTerm(client, tag, category: category);
          },
        ),
      ),
    );
  }
}
