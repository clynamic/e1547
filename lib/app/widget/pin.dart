import 'dart:async';
import 'dart:math';

import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const int pinLength = 4;

class PinEntry extends StatefulWidget {
  const PinEntry({
    super.key,
    required this.title,
    required this.onEntered,
    this.extraKey,
    this.message,
    this.onCancel,
  });

  final String title;
  final String? Function(String pin) onEntered;
  final Widget? extraKey;
  final String? message;
  final VoidCallback? onCancel;

  @override
  State<PinEntry> createState() => _PinEntryState();
}

class _PinEntryState extends State<PinEntry> {
  String _pin = '';
  String? _error;

  static final Map<LogicalKeyboardKey, String> _digitKeys = {
    LogicalKeyboardKey.digit0: '0',
    LogicalKeyboardKey.digit1: '1',
    LogicalKeyboardKey.digit2: '2',
    LogicalKeyboardKey.digit3: '3',
    LogicalKeyboardKey.digit4: '4',
    LogicalKeyboardKey.digit5: '5',
    LogicalKeyboardKey.digit6: '6',
    LogicalKeyboardKey.digit7: '7',
    LogicalKeyboardKey.digit8: '8',
    LogicalKeyboardKey.digit9: '9',
    LogicalKeyboardKey.numpad0: '0',
    LogicalKeyboardKey.numpad1: '1',
    LogicalKeyboardKey.numpad2: '2',
    LogicalKeyboardKey.numpad3: '3',
    LogicalKeyboardKey.numpad4: '4',
    LogicalKeyboardKey.numpad5: '5',
    LogicalKeyboardKey.numpad6: '6',
    LogicalKeyboardKey.numpad7: '7',
    LogicalKeyboardKey.numpad8: '8',
    LogicalKeyboardKey.numpad9: '9',
  };

  @override
  void didUpdateWidget(covariant PinEntry oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.title != widget.title) {
      _pin = '';
      _error = null;
    }
  }

  void _digit(String digit) {
    if (_error != null) {
      _error = null;
      _pin = '';
    }
    if (_pin.length >= pinLength) return;
    setState(() => _pin += digit);
    if (_pin.length == pinLength) {
      final String? error = widget.onEntered(_pin);
      if (error != null) setState(() => _error = error);
    }
  }

  void _delete() {
    if (_pin.isEmpty) return;
    setState(() {
      _error = null;
      _pin = _pin.substring(0, _pin.length - 1);
    });
  }

  KeyEventResult _typed(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (_digitKeys[event.logicalKey] case final String digit) {
      _digit(digit);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.backspace) {
      _delete();
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      if (widget.onCancel case final VoidCallback cancel) {
        cancel();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String? line = _error ?? widget.message;
    Widget key(String digit) => PinKey(
      onTap: () => _digit(digit),
      child: Text(digit, style: const TextStyle(fontSize: 26)),
    );
    final Widget heading = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.title,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(height: 32 / 24),
        ),
        const SizedBox(height: 28),
        PinDots(filled: _pin.length, error: _error != null),
        const SizedBox(height: 16),
        SizedBox(
          height: 20,
          child: line == null
              ? null
              : Text(
                  line,
                  style: TextStyle(
                    fontSize: 14,
                    color: _error != null
                        ? Theme.of(context).colorScheme.error
                        : dimTextColor(context),
                  ),
                ),
        ),
      ],
    );
    final Widget pad = Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 10,
      children: [
        for (final List<String> row in const [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
        ])
          Row(
            spacing: 10,
            children: [for (final String digit in row) key(digit)],
          ),
        Row(
          spacing: 10,
          children: [
            widget.extraKey ?? const Spacer(),
            key('0'),
            PinKey(
              surface: false,
              onTap: _delete,
              child: Icon(Icons.backspace, color: dimTextColor(context)),
            ),
          ],
        ),
      ],
    );
    return Focus(
      autofocus: true,
      onKeyEvent: _typed,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool sideways = constraints.maxWidth > constraints.maxHeight;
          final Size room = sideways
              ? Size(
                  max(constraints.maxWidth, 640),
                  max(constraints.maxHeight, 310),
                )
              : Size(
                  min(constraints.maxWidth, 400),
                  constraints.maxHeight.clamp(
                    492,
                    theme.isDesktop ? 640 : double.infinity,
                  ),
                );
          return Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: SizedBox.fromSize(
                size: room,
                child: sideways
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          heading,
                          SizedBox(width: 352, child: pad),
                        ],
                      )
                    : Column(
                        children: [
                          const Spacer(flex: 43),
                          heading,
                          const Spacer(flex: 50),
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: pad,
                          ),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PinKey extends StatelessWidget {
  const PinKey({
    super.key,
    required this.onTap,
    required this.child,
    this.surface = true,
  });

  final VoidCallback onTap;
  final Widget child;
  final bool surface;

  @override
  Widget build(BuildContext context) => Expanded(
    child: SizedBox(
      height: 64,
      child: Material(
        color: surface ? AppStyle.of(context).well : Colors.transparent,
        borderRadius: BorderRadius.circular(AppStyle.of(context).largeRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppStyle.of(context).largeRadius),
          child: Center(child: child),
        ),
      ),
    ),
  );
}

class PinDots extends StatelessWidget {
  const PinDots({super.key, required this.filled, this.error = false});

  final int filled;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 18,
      children: [
        for (int i = 0; i < pinLength; i++)
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: error
                  ? theme.colorScheme.error
                  : i < filled
                  ? theme.colorScheme.primary
                  : null,
              border: error || i < filled
                  ? null
                  : Border.all(color: AppStyle.of(context).outline, width: 2),
            ),
          ),
      ],
    );
  }
}

class PinSetupPage extends StatefulWidget {
  const PinSetupPage({super.key});

  @override
  State<PinSetupPage> createState() => _PinSetupPageState();
}

class _PinSetupPageState extends State<PinSetupPage> {
  String? _first;
  String? _message;

  String? _entered(String pin) {
    final String? first = _first;
    if (first == null) {
      setState(() {
        _first = pin;
        _message = null;
      });
      return null;
    }
    if (first == pin) {
      Navigator.of(context).pop(pin);
      return null;
    }
    setState(() {
      _first = null;
      _message = 'The two did not match';
    });
    return null;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: TransparentAppBar(child: AppBar()),
    body: SafeArea(
      top: false,
      child: PinEntry(
        title: _first == null ? 'Create a PIN' : 'Confirm your PIN',
        message: _message,
        onEntered: _entered,
        onCancel: () => Navigator.of(context).maybePop(),
      ),
    ),
  );
}

Future<String?> choosePin(BuildContext context) => Navigator.of(
  context,
).push<String>(MaterialPageRoute(builder: (context) => const PinSetupPage()));
