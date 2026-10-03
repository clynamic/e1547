import 'package:e1547/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);
    Widget field = TextFormField(
      controller: controller,
      focusNode: focusNode,
      readOnly: widget.readOnly,
      decoration: InputDecoration(
        labelText: l10n.identitySite,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.public),
        prefixText: isHttps ? 'https://' : 'http://',
      ),
      inputFormatters: [FilteringTextInputFormatter.deny(' ')],
      autofillHints: const [AutofillHints.url],
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return l10n.identityHostRequired;
        }
        try {
          if (isHttps) {
            value = 'https://$value';
          } else {
            value = 'http://$value';
          }
          Uri.parse(value);
        } on FormatException {
          return l10n.identityHostInvalid;
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
              message: l10n.identityHostReadOnly,
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
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: TextFormField(
        controller: controller,
        autocorrect: false,
        decoration: InputDecoration(
          labelText: l10n.identityUsernameLabel,
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.person_outline),
        ),
        inputFormatters: [FilteringTextInputFormatter.deny(' ')],
        autofillHints: const [AutofillHints.username],
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value!.trim().isEmpty) {
            return l10n.identityUsernameRequired;
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
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: TextFormField(
        autocorrect: false,
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: l10n.identityApikeyLabel,
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.key),
          suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: obscurePassword ? l10n.actionShow : l10n.actionHide,
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
            return l10n.identityApikeyRequired;
          }

          if (widget.canOmit &&
              value == OmittedPasswordTextInputFormatter.passwordOmitted) {
            return null;
          }

          if (!RegExp(r'^[A-z\d]{24,32}$').hasMatch(value)) {
            return l10n.identityApikeyInvalid;
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
