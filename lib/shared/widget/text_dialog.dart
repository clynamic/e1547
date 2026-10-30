import 'package:flutter/material.dart';

class TextInputDialog extends StatefulWidget {
  const TextInputDialog({
    super.key,
    required this.title,
    this.initial = '',
    this.label,
    this.keyboardType,
    this.actions = const [],
  });

  final String title;
  final String initial;
  final String? label;
  final TextInputType? keyboardType;
  final List<(String label, String result)> actions;

  @override
  State<TextInputDialog> createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<TextInputDialog> {
  late final TextEditingController text = TextEditingController(
    text: widget.initial,
  );

  @override
  void dispose() {
    text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.title),
    content: TextField(
      controller: text,
      autofocus: true,
      keyboardType: widget.keyboardType,
      decoration: widget.label == null
          ? null
          : InputDecoration(labelText: widget.label),
      onSubmitted: (value) => Navigator.of(context).pop(value),
    ),
    actions: [
      for (final (String label, String result) in widget.actions)
        TextButton(
          onPressed: () => Navigator.of(context).pop(result),
          child: Text(label),
        ),
      TextButton(
        onPressed: () => Navigator.of(context).pop(text.text),
        child: const Text('Set'),
      ),
    ],
  );
}
