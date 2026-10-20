import 'package:e1547/markup/markup.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class DescriptionDisplay extends StatefulWidget {
  const DescriptionDisplay({super.key, required this.post});

  final Post post;

  @override
  State<DescriptionDisplay> createState() => _DescriptionDisplayState();
}

class _DescriptionDisplayState extends State<DescriptionDisplay> {
  String? _translation;
  bool _loading = false;

  Future<void> _translate() async {
    if (_loading) {
      return;
    }
    if (_translation != null) {
      setState(() => _translation = null);
      return;
    }
    setState(() => _loading = true);
    final String? result = await Translator.translate(widget.post.description);
    if (!mounted) {
      return;
    }
    setState(() => _loading = false);
    if (result == null || result.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t('Translation failed'))),
      );
      return;
    }
    setState(() => _translation = result);
  }

  @override
  Widget build(BuildContext context) {
    final bool translated = _translation != null;
    return HiddenWidget(
      show: widget.post.description.trim().isNotEmpty,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _loading
                        ? const Center(
                            child: SizedCircularProgressIndicator(size: 24),
                          )
                        : translated
                        ? Text(_translation!)
                        : DText(widget.post.description),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(translated ? Icons.undo : Icons.translate),
                tooltip: t(translated ? 'Show original' : 'Translate'),
                onPressed: _translate,
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
