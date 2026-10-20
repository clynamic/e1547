import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HostFormField extends StatefulWidget {
  const HostFormField({
    super.key,
    required this.controller,
    this.readOnly = false,
  });

  final TextEditingController controller;
  final bool readOnly;

  @override
  State<HostFormField> createState() => _HostFormFieldState();
}

class _HostFormFieldState extends State<HostFormField> {
  late final TextEditingController controller = TextEditingController(
    text: widget.controller.text,
  );
  final FocusNode focusNode = FocusNode();
  final GlobalKey<TooltipState> tooltipKey = GlobalKey<TooltipState>();
  bool isHttps = true;

  final String http = 'http://';
  final String https = 'https://';

  @override
  void initState() {
    super.initState();
    controller.addListener(_updateController);
    focusNode.addListener(_showReadOnlyHint);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateController();
    });
  }

  void _showReadOnlyHint() {
    if (!widget.readOnly) return;
    if (focusNode.hasFocus) {
      tooltipKey.currentState?.ensureTooltipVisible();
    } else {
      Tooltip.dismissAllToolTips();
    }
  }

  void _updateController() {
    if (controller.text.startsWith(http)) {
      setState(() => isHttps = false);
      controller.text = controller.text.replaceFirst(http, '');
    } else if (controller.text.startsWith(https)) {
      setState(() => isHttps = true);
      controller.text = controller.text.replaceFirst(https, '');
    }
    widget.controller.text = '${isHttps ? https : http}${controller.text}';
  }

  @override
  void dispose() {
    controller.removeListener(_updateController);
    focusNode.removeListener(_showReadOnlyHint);
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget field = TextFormField(
      controller: controller,
      focusNode: focusNode,
      readOnly: widget.readOnly,
      decoration: InputDecoration(
        labelText: t('Site'),
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.public),
        prefixText: isHttps ? 'https://' : 'http://',
      ),
      inputFormatters: [FilteringTextInputFormatter.deny(' ')],
      autofillHints: const [AutofillHints.url],
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return t('You must provide a host URL.');
        }
        try {
          if (isHttps) {
            value = 'https://$value';
          } else {
            value = 'http://$value';
          }
          Uri.parse(value);
        } on FormatException {
          return t('Invalid host URL');
        }
        return null;
      },
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: widget.readOnly
          ? Tooltip(
              key: tooltipKey,
              triggerMode: TooltipTriggerMode.manual,
              verticalOffset: 44,
              message: t(
                'Site can\'t be changed. '
                'Add a new account to use a different one.',
              ),
              child: field,
            )
          : field,
    );
  }
}

class UsernameFormField extends StatelessWidget {
  const UsernameFormField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: TextFormField(
        controller: controller,
        autocorrect: false,
        decoration: InputDecoration(
          labelText: t('Username'),
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.person_outline),
        ),
        inputFormatters: [FilteringTextInputFormatter.deny(' ')],
        autofillHints: const [AutofillHints.username],
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value!.trim().isEmpty) {
            return t('You must provide a username.');
          }
          return null;
        },
      ),
    );
  }
}

class ApikeyFormField extends StatefulWidget {
  const ApikeyFormField({
    super.key,
    required this.controller,
    this.canOmit = false,
  });

  final TextEditingController controller;
  final bool canOmit;

  @override
  State<ApikeyFormField> createState() => _ApikeyFormFieldState();
}

class _ApikeyFormFieldState extends State<ApikeyFormField> {
  final String apiKeyExample = '1ca1d165e973d7f8d35b7deb7a2ae54c';
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: TextFormField(
        autocorrect: false,
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: t('API key'),
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.key),
          suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: t(obscurePassword ? 'Show' : 'Hide'),
                  icon: Icon(
                    obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () =>
                      setState(() => obscurePassword = !obscurePassword),
                ),
              ],
            ),
          ),
        ),
        obscureText: obscurePassword,
        inputFormatters: [
          FilteringTextInputFormatter.deny(' '),
          if (widget.canOmit) OmittedPasswordTextInputFormatter(),
        ],
        autofillHints: const [AutofillHints.password],
        textInputAction: TextInputAction.done,
        validator: (value) {
          if (value!.isEmpty) {
            return tf(
              'You must provide an API key.\n'
              'e.g. {example}',
              params: {'example': apiKeyExample},
            );
          }

          if (widget.canOmit &&
              value == OmittedPasswordTextInputFormatter.passwordOmitted) {
            return null;
          }

          if (!RegExp(r'^[A-z\d]{24,32}$').hasMatch(value)) {
            return tf(
              'API key is a 24 or 32-character sequence of {A..z} and {0..9}\n'
              'e.g. {example}',
              params: {'example': apiKeyExample},
            );
          }

          return null;
        },
      ),
    );
  }
}

class OmittedPasswordTextInputFormatter extends TextInputFormatter {
  static final String passwordOmitted = '-' * 24;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (oldValue.text == passwordOmitted) {
      if (newValue.text.contains(passwordOmitted)) {
        newValue = newValue.copyWith(
          text: newValue.text.replaceAll(passwordOmitted, ''),
        );
      } else {
        newValue = newValue.copyWith(text: '');
      }
      newValue = newValue.copyWith(
        selection: TextSelection.collapsed(offset: newValue.text.length),
      );
    }
    return newValue;
  }
}
