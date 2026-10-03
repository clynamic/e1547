import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/markup/markup.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(
    body: Expandables(
      child: SpoilerProvider(
        builder: (context, _) =>
            Padding(padding: const EdgeInsets.all(8), child: child),
      ),
    ),
  ),
);

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
            ]),
          ),
        ),
      );
      expect(find.textContaining('Title'), findsOneWidget);
    });

    testWidgets('code block renders content selectable', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const DTextBody(
            content: DTextDocument([DTextCodeBlock('x := 1\ny := 2')]),
          ),
        ),
      );
      expect(find.byType(CodeWrap), findsOneWidget);
      expect(find.textContaining('x := 1'), findsOneWidget);
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

    testWidgets('quote wraps in QuoteWrap', (tester) async {
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
      expect(find.byType(QuoteWrap), findsOneWidget);
      expect(find.textContaining('quoted'), findsOneWidget);
    });

    testWidgets('section wraps in SectionWrap', (tester) async {
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
      expect(find.byType(SectionWrap), findsOneWidget);
      expect(find.text('Heading'), findsOneWidget);
      expect(find.textContaining('inside'), findsOneWidget);
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

    testWidgets('list renders each item with bullet', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const DTextBody(
            content: DTextDocument([
              DTextList([
                DTextListItem(depth: 1, children: [DTextText('one')]),
                DTextListItem(depth: 1, children: [DTextText('two')]),
              ]),
            ]),
          ),
        ),
      );
      expect(find.textContaining('one'), findsOneWidget);
      expect(find.textContaining('two'), findsOneWidget);
    });

    testWidgets('table renders header and body cells', (tester) async {
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
                      children: [DTextText('Alice')],
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
      expect(find.textContaining('Name'), findsOneWidget);
      expect(find.textContaining('Score'), findsOneWidget);
      expect(find.textContaining('Alice'), findsOneWidget);
      expect(find.textContaining('42'), findsOneWidget);
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
    testWidgets('bold/italic/underline/strikeout all visible', (tester) async {
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
      expect(find.textContaining('bold'), findsOneWidget);
      expect(find.textContaining('italic'), findsOneWidget);
      expect(find.textContaining('under'), findsOneWidget);
      expect(find.textContaining('strike'), findsOneWidget);
    });

    testWidgets('superscript and subscript visible', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const DTextBody(
            content: DTextDocument([
              DTextParagraph([
                DTextText('E=mc'),
                DTextSuperscript([DTextText('2')]),
                DTextText('  H'),
                DTextSubscript([DTextText('2')]),
                DTextText('O'),
              ]),
            ]),
          ),
        ),
      );
      expect(find.textContaining('E=mc'), findsOneWidget);
    });

    testWidgets('inline code shows content', (tester) async {
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
      expect(find.textContaining('foo()'), findsOneWidget);
    });

    testWidgets('color span renders children', (tester) async {
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
      expect(find.textContaining('warning'), findsOneWidget);
    });

    testWidgets('inline_spoiler starts hidden but still in tree', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const DTextBody(
            content: DTextDocument([
              DTextParagraph([
                DTextText('reveal '),
                DTextInlineSpoiler([DTextText('secret')]),
              ]),
            ]),
          ),
        ),
      );
      expect(find.textContaining('reveal'), findsOneWidget);
      expect(find.textContaining('secret'), findsOneWidget);
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
      expect(find.textContaining('first'), findsOneWidget);
      expect(find.textContaining('second'), findsOneWidget);
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
                DTextFragment(
                  wrapper: DTextFragmentWrapper.sup,
                  children: [DTextText('frag-text')],
                ),
              ]),
            ]),
          ),
        ),
      );
      expect(find.textContaining('frag-text'), findsOneWidget);
    });
  });

  group('Layout does not overflow', () {
    testWidgets('long paragraph wraps without RenderFlex overflow', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const SizedBox(
            width: 200,
            child: DTextBody(
              content: DTextDocument([
                DTextParagraph([
                  DTextText(
                    'the quick brown fox jumps over the lazy dog. '
                    'pack my box with five dozen liquor jugs. '
                    'how vexingly quick daft zebras jump.',
                  ),
                ]),
              ]),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('wide table inside narrow container does not throw', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          SizedBox(
            width: 300,
            child: DTextBody(
              content: DTextDocument([
                DTextTable([
                  DTextTableBody([
                    DTextTableRow([
                      for (var i = 0; i < 4; i++)
                        DTextTableCell(
                          cellType: DTextTableCellType.td,
                          children: [DTextText('col $i')],
                        ),
                    ]),
                  ]),
                ]),
              ]),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });

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
