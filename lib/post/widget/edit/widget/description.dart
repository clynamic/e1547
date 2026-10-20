import 'package:e1547/markup/markup.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/ticket/ticket.dart';
import 'package:flutter/material.dart';

class DescriptionEditDisplay extends StatefulWidget {
  const DescriptionEditDisplay({
    super.key,
    required this.postId,
    required this.controller,
    this.enabled,
  });

  final TextEditingController controller;
  final int postId;
  final bool? enabled;

  @override
  State<DescriptionEditDisplay> createState() => _DescriptionEditDisplayState();
}

class _DescriptionEditDisplayState extends State<DescriptionEditDisplay> {
  bool _isPreviewMode = false;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      const breakpoint = 600.0;
      final isWideLayout = constraints.maxWidth >= breakpoint;

      return Padding(
        padding: defaultFormPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    t('Description'),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  onPressed: (widget.enabled ?? true)
                      ? isWideLayout
                            ? () => setState(
                                () => _isPreviewMode = !_isPreviewMode,
                              )
                            : () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => DTextEditor(
                                    title: Text(
                                      tf(
                                        '{id} description',
                                        params: {'id': widget.postId},
                                      ),
                                    ),
                                    content: widget.controller.text,
                                    onSubmitted: (text) {
                                      widget.controller.text = text;
                                      return null;
                                    },
                                    onClosed: Navigator.of(context).maybePop,
                                  ),
                                ),
                              )
                      : null,
                  icon: isWideLayout
                      ? Icon(_isPreviewMode ? Icons.edit : Icons.visibility)
                      : const Icon(Icons.edit),
                  tooltip: t(
                    isWideLayout
                        ? (_isPreviewMode ? 'Edit' : 'Preview')
                        : 'Edit',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (isWideLayout && _isPreviewMode) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: widget.controller.text.trim().isNotEmpty
                    ? DText(widget.controller.text)
                    : Text(
                        t('No description'),
                        style: TextStyle(
                          color: dimTextColor(context),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
              ),
            ] else if (isWideLayout) ...[
              TextFormField(
                controller: widget.controller,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: t('Enter post description...'),
                ),
                maxLines: null,
                enabled: widget.enabled,
              ),
            ] else ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: widget.controller.text.trim().isNotEmpty
                    ? DText(widget.controller.text)
                    : Text(
                        t('No description'),
                        style: TextStyle(
                          color: dimTextColor(context),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
              ),
            ],
          ],
        ),
      );
    },
  );
}
