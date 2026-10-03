import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/logs/logs.dart';
import 'package:e1547/markup/markup.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

final DTextGrammar _grammar = DTextGrammar();

class DText extends StatefulWidget {
  const DText(
    this.value, {
    super.key,
    this.style,
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.textAlign = TextAlign.start,
    this.softWrap = true,
  });

  final TextStyle? style;
  final int? maxLines;
  final TextOverflow overflow;
  final String value;
  final TextAlign textAlign;
  final bool softWrap;

  @override
  State<DText> createState() => _DTextState();
}

class _DTextState extends State<DText> {
  final Logger _logger = Logger('DText');
  DTextDocument? _content;
  Object? _error;

  void _runParse() {
    try {
      _content = _grammar.parse(widget.value);
      _error = null;
    } on Object catch (e, s) {
      _logger.error('Failed to parse DText', null, e, s);
      _error = e;
    }
  }

  @override
  void initState() {
    super.initState();
    _runParse();
  }

  @override
  void didUpdateWidget(covariant DText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _runParse();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null || _content == null) {
      final errorColor = Theme.of(context).colorScheme.error;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              Icons.warning_amber_outlined,
              color: errorColor,
              size: 20,
            ),
          ),
          Text(
            AppLocalizations.of(context).dtextParsingFailed,
            style: TextStyle(color: errorColor),
          ),
        ],
      );
    }

    return LinkPreviewProvider(
      child: SelectionArea(
        child: SpoilerProvider(
          builder: (context, child) => DTextBody(
            content: _content!,
            style: widget.style,
            maxLines: widget.maxLines,
            overflow: widget.overflow,
            textAlign: widget.textAlign,
            softWrap: widget.softWrap,
          ),
        ),
      ),
    );
  }
}

class DTextBody extends StatelessWidget {
  const DTextBody({
    super.key,
    required this.content,
    this.style,
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.textAlign = TextAlign.start,
    this.softWrap = true,
  });

  final DTextNode content;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final bool softWrap;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: style,
      child: Expandables(
        child: Builder(
          builder: (context) {
            final Widget child = Builder(
              builder: (context) => _renderNode(context, content),
            );
            // Nested bodies share the outermost registry, so an anchor in a
            // quote and a link outside it still find each other.
            if (DTextAnchors.of(context) != null) return child;
            return DTextAnchors(child: child);
          },
        ),
      ),
    );
  }

  DTextBody _nested(List<DTextBlock> children) => DTextBody(
    content: DTextDocument(children),
    style: style,
    maxLines: maxLines,
    overflow: overflow,
    textAlign: textAlign,
    softWrap: softWrap,
  );

  Widget _renderNode(BuildContext context, DTextNode node) {
    return switch (node) {
      DTextDocument() => _renderBlocks(context, node.children),
      final DTextBlock block => _renderBlock(context, block),
      final DTextInline inline => Text.rich(
        _buildInline(context, [inline]),
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign,
        softWrap: softWrap,
      ),
      DTextListItem() ||
      DTextTableCell() ||
      DTextTableChild() => const SizedBox.shrink(),
    };
  }

  /// Drops the line break a verbatim block ends on. The parser keeps it
  /// because e621ng does, where a browser draws no line for it inside a
  /// `<pre>`.
  String _withoutClosingBreak(String content) {
    if (content.endsWith('\r\n')) {
      return content.substring(0, content.length - 2);
    }
    if (content.endsWith('\n')) {
      return content.substring(0, content.length - 1);
    }
    return content;
  }

  Widget _renderBlocks(BuildContext context, List<DTextBlock> blocks) {
    if (blocks.isEmpty) return const SizedBox.shrink();
    if (blocks.length == 1) return _renderBlock(context, blocks.first);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < blocks.length; i++)
          Padding(
            padding: EdgeInsets.only(top: i == 0 ? 0 : 4),
            child: _renderBlock(context, blocks[i]),
          ),
      ],
    );
  }

  Widget _renderBlock(BuildContext context, DTextBlock block) {
    return switch (block) {
      DTextHeader() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text.rich(
          _buildInline(context, block.children),
          textAlign: textAlign,
          softWrap: softWrap,
          style: TextStyle(
            fontSize:
                (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14) +
                ((block.level - 7).abs() * 2),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      DTextParagraph() => Text.rich(
        _buildInline(context, block.children),
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign,
        softWrap: softWrap,
      ),
      DTextQuote() => QuoteWrap(child: _nested(block.children)),
      DTextSpoilerBlock() => SpoilerBlockWrap(child: _nested(block.children)),
      DTextSection() => SectionWrap(
        key: ObjectKey(block),
        title: block.title,
        expanded: block.expanded ?? false,
        child: _nested(block.children),
      ),
      DTextCodeBlock() => CodeWrap(
        child: SelectableText(
          _withoutClosingBreak(block.content),
          textAlign: textAlign,
        ),
      ),
      DTextTable() => DTextTableWidget(children: block.children),
      DTextLTable() => DTextTableWidget(children: block.children),
      DTextList() => _renderList(context, block),
      DTextRawBlockText() => SelectableText(
        _withoutClosingBreak(block.content),
        textAlign: textAlign,
      ),
      DTextLiteralHtml() => Text.rich(
        TextSpan(
          children: [
            TextSpan(text: block.prefix),
            ..._inlineSpans(context, block.children),
          ],
        ),
        textAlign: textAlign,
        softWrap: softWrap,
      ),
    };
  }

  Widget _renderList(BuildContext context, DTextList list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final item in list.items)
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: '${'  ' * item.depth}• '),
                ..._inlineSpans(context, item.children),
              ],
            ),
            textAlign: textAlign,
            softWrap: softWrap,
          ),
      ],
    );
  }

  InlineSpan _buildInline(BuildContext context, List<DTextInline> nodes) =>
      TextSpan(children: _inlineSpans(context, nodes));

  List<InlineSpan> _inlineSpans(
    BuildContext context,
    List<DTextInline> nodes,
  ) => [for (final node in nodes) _inlineSpan(context, node)];

  InlineSpan _inlineSpan(BuildContext context, DTextInline node) {
    return switch (node) {
      DTextText() => TextSpan(text: node.content),
      DTextLineBreak() => const TextSpan(text: '\n'),
      DTextBold() => TextSpan(
        children: _inlineSpans(context, node.children),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      DTextItalic() => TextSpan(
        children: _inlineSpans(context, node.children),
        style: const TextStyle(fontStyle: FontStyle.italic),
      ),
      DTextUnderline() => TextSpan(
        children: _inlineSpans(context, node.children),
        style: const TextStyle(decoration: TextDecoration.underline),
      ),
      DTextStrikeout() => TextSpan(
        children: _inlineSpans(context, node.children),
        style: const TextStyle(decoration: TextDecoration.lineThrough),
      ),
      DTextSuperscript() => TextSpan(
        children: _inlineSpans(context, node.children),
        style: const TextStyle(fontFeatures: [FontFeature.superscripts()]),
      ),
      DTextSubscript() => TextSpan(
        children: _inlineSpans(context, node.children),
        style: const TextStyle(fontFeatures: [FontFeature.subscripts()]),
      ),
      DTextInlineSpoiler() => _buildSpoilerSpan(context, node),
      DTextInlineCode() => TextSpan(
        text: node.content,
        style: TextStyle(
          fontFamily: 'JetBrains Mono',
          backgroundColor: Theme.of(context).cardColor,
        ),
      ),
      DTextColor() => TextSpan(
        children: _inlineSpans(context, node.children),
        style: TextStyle(color: parseColor(node.color)),
      ),
      DTextFragment() => TextSpan(
        children: _inlineSpans(context, node.children),
      ),
      DTextInternalAnchor() => WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: DTextAnchorTarget(
          key: GlobalObjectKey(node),
          name: normalizeAnchor(node.name),
        ),
      ),
      DTextLink() => _buildLinkSpan(context, node),
    };
  }

  InlineSpan _buildSpoilerSpan(BuildContext context, DTextInlineSpoiler node) {
    final controller = context.watch<SpoilerController>();
    controller.register(node);
    final hidden = controller.hidden(node);
    final baseColor = Theme.of(context).textTheme.bodyMedium?.color;
    return TextSpan(
      children: _wrapWithRecognizer(
        _inlineSpans(context, node.children),
        controller.recognizer(node),
      ),
      style: TextStyle(
        color: hidden ? Colors.transparent : null,
        backgroundColor: hidden
            ? baseColor?.withAlpha(255)
            : baseColor?.withAlpha(26),
      ),
    );
  }

  InlineSpan _buildLinkSpan(BuildContext context, DTextLink node) {
    final href = node.href;
    final local = _isLocalLink(href);
    final action = _buildLinkAction(context, node, local: local);
    final children = node.children;
    final preview = LinkPreviewProvider.of(context);
    final previewLink = local ? context.read<Client>().withHost(href) : href;
    final spans = children != null && children.isNotEmpty
        ? _inlineSpans(context, children)
        : [TextSpan(text: _linkDisplay(href, node.title))];
    return TextSpan(
      children: _wrapWithRecognizer(
        spans,
        TapGestureRecognizer()..onTap = action,
        onEnter: (_) => preview.showLink(previewLink),
        onExit: (_) => preview.hideLink(),
      ),
      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
    );
  }

  VoidCallback _buildLinkAction(
    BuildContext context,
    DTextLink node, {
    required bool local,
  }) {
    final href = node.href;
    if (!local) return () => launch(href);
    if (href.startsWith('#')) {
      final anchor = node.anchor ?? href.substring(1);
      return () => DTextAnchors.of(context)?.reveal(normalizeAnchor(anchor));
    }
    final action = const E621LinkParser().parseOnTap(context, href);
    if (action != null) return action;
    return () => launch(context.read<Client>().withHost(href));
  }

  bool _isLocalLink(String href) {
    if (href.startsWith('/') || href.startsWith('#')) return true;
    final uri = Uri.tryParse(href);
    if (uri == null) return false;
    return const {'e621.net', 'e926.net'}.contains(uri.host);
  }

  String _linkDisplay(String href, String? title) {
    if (title != null && title.isNotEmpty) return title;
    return linkToDisplay(href);
  }

  List<InlineSpan> _wrapWithRecognizer(
    List<InlineSpan> spans,
    GestureRecognizer recognizer, {
    void Function(PointerEnterEvent)? onEnter,
    void Function(PointerExitEvent)? onExit,
  }) => spans
      .map(
        (e) => switch (e) {
          TextSpan() => TextSpan(
            text: e.text,
            children: e.children == null
                ? null
                : _wrapWithRecognizer(
                    e.children!,
                    recognizer,
                    onEnter: onEnter,
                    onExit: onExit,
                  ),
            recognizer: e.recognizer ?? recognizer,
            style: e.style,
            onEnter: e.onEnter ?? onEnter,
            onExit: e.onExit ?? onExit,
          ),
          _ => e,
        },
      )
      .toList();
}
