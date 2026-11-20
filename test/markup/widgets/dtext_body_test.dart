import 'package:e1547/markup/markup.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(
  home: Scaffold(
    body: Expandables(
      child: SpoilerProvider(
        builder: (context, _) =>
            Padding(padding: const EdgeInsets.all(8), child: child),
      ),
    ),
  ),
);

TextStyle _styleOf(WidgetTester tester, String text) {
  final RichText rich = tester.widget(
    find.byWidgetPredicate(
      (widget) =>
          widget is RichText && widget.text.toPlainText().contains(text),
    ),
  );
  TextStyle? found;
  void visit(InlineSpan span, TextStyle style) {
    final TextStyle merged = style.merge(span.style);
    if (span is! TextSpan) return;
    if (span.text == text) found = merged;
    for (final InlineSpan child in span.children ?? const []) {
      visit(child, merged);
    }
  }

  visit(rich.text, const TextStyle());
  expect(found, isNotNull, reason: 'no span reads "$text"');
  return found!;
}

String _plainOf(WidgetTester tester, String text) => tester
    .widget<RichText>(
      find.byWidgetPredicate(
        (widget) =>
            widget is RichText && widget.text.toPlainText().contains(text),
      ),
    )
    .text
    .toPlainText();

void main() {
  group('DTextBody renders block kinds', () {
    testWidgets('paragraph with plain text', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const DTextBody(
            content: DTextDocument([
              DTextParagraph([DTextText('hello world')]),
            ]),
          ),
        ),
      );
      expect(find.textContaining('hello world'), findsOneWidget);
    });

    testWidgets('header h1 produces bold larger text', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const DTextBody(
            content: DTextDocument([
              DTextHeader(level: 1, children: [DTextText('Title')]),
              DTextParagraph([DTextText('body')]),
            ]),
          ),
        ),
      );
      final TextStyle title = _styleOf(tester, 'Title');
      expect(title.fontWeight, FontWeight.bold);
      expect(title.fontSize, greaterThan(_styleOf(tester, 'body').fontSize!));
    });

    testWidgets('code block drops the line break it closes on', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const DTextBody(
            content: DTextDocument([DTextCodeBlock('x := 1\ny := 2\n')]),
          ),
        ),
      );
      final SelectableText text = tester.widget(
        find.descendant(
          of: find.byType(CodeWrap),
          matching: find.byType(SelectableText),
        ),
      );
      expect(text.data, 'x := 1\ny := 2');
    });

    testWidgets('raw block drops the line break it closes on', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const DTextBody(
            content: DTextDocument([DTextRawBlockText('plain text\n')]),
          ),
        ),
      );
      final SelectableText text = tester.widget(find.byType(SelectableText));
      expect(text.data, 'plain text');
    });

    testWidgets('quote sets its content in a quote frame', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const DTextBody(
            content: DTextDocument([
              DTextQuote(
                children: [
                  DTextParagraph([DTextText('quoted')]),
                ],
              ),
            ]),
          ),
        ),
      );
      expect(
        find.descendant(
          of: find.byType(QuoteWrap),
          matching: find.textContaining('quoted'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('a collapsed section opens on a tap on its title', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const DTextBody(
            content: DTextDocument([
              DTextSection(
                title: 'Heading',
                expanded: false,
                children: [
                  DTextParagraph([DTextText('inside')]),
                ],
              ),
            ]),
          ),
        ),
      );
      expect(find.textContaining('inside').hitTestable(), findsNothing);

      await tester.tap(find.text('Heading'));
      await tester.pumpAndSettle();

      expect(find.textContaining('inside').hitTestable(), findsOneWidget);
    });

    testWidgets('an expanded section starts open', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const DTextBody(
            content: DTextDocument([
              DTextSection(
                title: 'Heading',
                expanded: true,
                children: [
                  DTextParagraph([DTextText('inside')]),
                ],
              ),
            ]),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('inside').hitTestable(), findsOneWidget);
    });

    testWidgets('section title collapses whitespace', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const DTextBody(
            content: DTextDocument([
              DTextSection(
                title: '   Ember pre-rust (2024)\n - by tester  ',
                expanded: true,
                children: [
                  DTextParagraph([DTextText('inside')]),
                ],
              ),
            ]),
          ),
        ),
      );
      expect(find.text('Ember pre-rust (2024) - by tester'), findsOneWidget);
    });

    testWidgets('list indents each item by its depth behind a bullet', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const DTextBody(
            content: DTextDocument([
              DTextList([
                DTextListItem(depth: 1, children: [DTextText('one')]),
                DTextListItem(depth: 2, children: [DTextText('two')]),
              ]),
            ]),
          ),
        ),
      );
      expect(_plainOf(tester, 'one'), '  • one');
      expect(_plainOf(tester, 'two'), '    • two');
    });

    testWidgets('table shows its header cells in bold', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const DTextBody(
            content: DTextDocument([
              DTextTable([
                DTextTableHead([
                  DTextTableRow([
                    DTextTableCell(
                      cellType: DTextTableCellType.th,
                      children: [DTextText('Name')],
                    ),
                    DTextTableCell(
                      cellType: DTextTableCellType.th,
                      children: [DTextText('Score')],
                    ),
                  ]),
                ]),
                DTextTableBody([
                  DTextTableRow([
                    DTextTableCell(
                      cellType: DTextTableCellType.td,
                      children: [DTextText('tester')],
                    ),
                    DTextTableCell(
                      cellType: DTextTableCellType.td,
                      children: [DTextText('42')],
                    ),
                  ]),
                ]),
              ]),
            ]),
          ),
        ),
      );
      expect(find.byType(Table), findsOneWidget);
      for (final String header in ['Name', 'Score']) {
        expect(_styleOf(tester, header).fontWeight, FontWeight.bold);
      }
      for (final String cell in ['tester', '42']) {
        expect(_styleOf(tester, cell).fontWeight, isNot(FontWeight.bold));
      }
    });

    testWidgets('raw_block_text renders content verbatim', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const DTextBody(
            content: DTextDocument([DTextRawBlockText('[/closetag]')]),
          ),
        ),
      );
      expect(find.textContaining('[/closetag]'), findsOneWidget);
    });

    testWidgets('literal_html renders prefix and inline tail', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const DTextBody(
            content: DTextDocument([
              DTextLiteralHtml(
                prefix: '[/code]',
                children: [DTextText(' trailing')],
              ),
            ]),
          ),
        ),
      );
      expect(find.textContaining('[/code]'), findsOneWidget);
      expect(find.textContaining('trailing'), findsOneWidget);
    });
  });

  group('DTextBody renders inline kinds', () {
    testWidgets('bold, italic, underline and strikeout style their text', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const DTextBody(
            content: DTextDocument([
              DTextParagraph([
                DTextBold([DTextText('bold')]),
                DTextText(' '),
                DTextItalic([DTextText('italic')]),
                DTextText(' '),
                DTextUnderline([DTextText('under')]),
                DTextText(' '),
                DTextStrikeout([DTextText('strike')]),
              ]),
            ]),
          ),
        ),
      );
      expect(_styleOf(tester, 'bold').fontWeight, FontWeight.bold);
      expect(_styleOf(tester, 'italic').fontStyle, FontStyle.italic);
      expect(_styleOf(tester, 'under').decoration, TextDecoration.underline);
      expect(_styleOf(tester, 'strike').decoration, TextDecoration.lineThrough);
    });

    testWidgets('superscript and subscript raise and lower their text', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const DTextBody(
            content: DTextDocument([
              DTextParagraph([
                DTextText('E=mc'),
                DTextSuperscript([DTextText('2')]),
                DTextText('  H'),
                DTextSubscript([DTextText('two')]),
                DTextText('O'),
              ]),
            ]),
          ),
        ),
      );
      expect(_styleOf(tester, '2').fontFeatures, [
        const FontFeature.superscripts(),
      ]);
      expect(_styleOf(tester, 'two').fontFeatures, [
        const FontFeature.subscripts(),
      ]);
    });

    testWidgets('inline code shows its content in monospace', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const DTextBody(
            content: DTextDocument([
              DTextParagraph([
                DTextText('see '),
                DTextInlineCode('foo()'),
                DTextText(' for details'),
              ]),
            ]),
          ),
        ),
      );
      expect(_styleOf(tester, 'foo()').fontFamily, 'JetBrains Mono');
    });

    testWidgets('color span tints its children', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const DTextBody(
            content: DTextDocument([
              DTextParagraph([
                DTextColor(color: 'red', children: [DTextText('warning')]),
              ]),
            ]),
          ),
        ),
      );
      expect(_styleOf(tester, 'warning').color, const Color(0xFFFF0000));
    });

    testWidgets('inline spoiler hides its text until tapped', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const DTextBody(
            content: DTextDocument([
              DTextParagraph([
                DTextInlineSpoiler([DTextText('secret')]),
              ]),
            ]),
          ),
        ),
      );
      expect(_styleOf(tester, 'secret').color, Colors.transparent);

      await tester.tap(find.textContaining('secret'));
      await tester.pump();

      expect(_styleOf(tester, 'secret').color, isNot(Colors.transparent));
    });

    testWidgets('line_break inserts a newline', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const DTextBody(
            content: DTextDocument([
              DTextParagraph([
                DTextText('first'),
                DTextLineBreak(),
                DTextText('second'),
              ]),
            ]),
          ),
        ),
      );
      expect(_plainOf(tester, 'first'), 'first\nsecond');
    });

    testWidgets('internal_anchor renders an invisible keyed widget', (
      tester,
    ) async {
      const node = DTextInternalAnchor('my-section');
      await tester.pumpWidget(
        _wrap(
          const DTextBody(
            content: DTextDocument([
              DTextParagraph([node]),
            ]),
          ),
        ),
      );
      expect(find.byKey(const GlobalObjectKey(node)), findsOneWidget);
    });

    testWidgets('fragment renders children transparently', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const DTextBody(
            content: DTextDocument([
              DTextParagraph([
                DTextText('plain'),
                DTextFragment(
                  wrapper: DTextFragmentWrapper.sup,
                  children: [DTextText('frag-text')],
                ),
              ]),
            ]),
          ),
        ),
      );
      expect(_styleOf(tester, 'frag-text'), _styleOf(tester, 'plain'));
    });
  });

  group('Layout does not overflow', () {
    testWidgets('wide table scrolls horizontally', (tester) async {
      await tester.pumpWidget(
        _wrap(
          SizedBox(
            width: 300,
            child: DTextBody(
              content: DTextDocument([
                DTextTable([
                  DTextTableBody([
                    DTextTableRow([
                      for (var i = 0; i < 8; i++)
                        DTextTableCell(
                          cellType: DTextTableCellType.td,
                          children: [DTextText('column $i')],
                        ),
                    ]),
                  ]),
                ]),
              ]),
            ),
          ),
        ),
      );

      final Scrollable scrollable = tester.widget(
        find.descendant(
          of: find.byType(DTextTableWidget),
          matching: find.byType(Scrollable),
        ),
      );
      expect(scrollable.axisDirection, AxisDirection.right);
      expect(tester.getSize(find.byType(Table)).width, greaterThan(300));
    });
  });
}
