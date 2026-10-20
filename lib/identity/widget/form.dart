import 'dart:io';

import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class AccountForm extends StatefulWidget {
  const AccountForm({
    super.key,
    this.identity,
    this.initialHost,
    this.onSubmitted,
  });

  final Identity? identity;
  final String? initialHost;
  final VoidCallback? onSubmitted;

  @override
  State<AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final TextEditingController hostController = TextEditingController(
    text: widget.identity?.host ?? widget.initialHost,
  );
  late final TextEditingController usernameController = TextEditingController(
    text: widget.identity?.username,
  );
  late final TextEditingController apikeyController = TextEditingController(
    text: widget.identity?.headers?[HttpHeaders.authorizationHeader] != null
        ? OmittedPasswordTextInputFormatter.passwordOmitted
        : null,
  );

  late bool? withAuth = isEditing ? widget.identity!.username != null : null;
  String? error;

  bool get isEditing => widget.identity != null;

  bool get isFulfilled {
    if (isEditing) return true;
    switch (withAuth) {
      case null:
        return false;
      case false:
        return true;
      case true:
        return usernameController.text.trim().isNotEmpty &&
            apikeyController.text.trim().isNotEmpty;
    }
  }

  @override
  void dispose() {
    hostController.dispose();
    usernameController.dispose();
    apikeyController.dispose();
    super.dispose();
  }

  void submit() {
    if (!formKey.currentState!.validate()) return;
    if (withAuth == null) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoginLoadingDialog(
        identity: widget.identity,
        host: hostController.text,
        username: withAuth! ? usernameController.text : null,
        apikey: withAuth! ? apikeyController.text : null,
        activate: !isEditing,
        onError: (value) => setState(() {
          value ??= t('Check your network connection and login details');
          error = tf('Failed to log in. \n{error}', params: {'error': value});
        }),
        onDone: widget.onSubmitted,
      ),
    );
  }

  Widget apiKeyLink() {
    return ListenableBuilder(
      listenable: hostController,
      builder: (context, _) {
        ClientFactory factory = context.watch<ClientFactory>();
        String? apiKeysUrl = factory.apiKeysUrl(hostController.text);
        String? registrationUrl = factory.registrationUrl(hostController.text);
        if (apiKeysUrl != null) {
          return Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => launch(apiKeysUrl),
              child: Text(t('Where do I find my API key?')),
            ),
          );
        }
        if (registrationUrl != null) {
          return Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => launch(registrationUrl),
              child: Text(t('Don\'t have an account? Sign up here')),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HostFormField(controller: hostController, readOnly: isEditing),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              t('The site is where your posts and account live.'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 16),
          _AuthModeSelector(
            withAuth: withAuth,
            onChanged: (value) => setState(() {
              withAuth = value;
              error = null;
            }),
          ),
          AnimatedSize(
            duration: defaultAnimationDuration,
            alignment: Alignment.topCenter,
            child: withAuth == true
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 12),
                      UsernameFormField(controller: usernameController),
                      ApikeyFormField(
                        controller: apikeyController,
                        canOmit: isEditing,
                      ),
                      apiKeyLink(),
                    ],
                  )
                : const SizedBox(width: double.infinity),
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          IgnorePointer(
            ignoring: withAuth == null,
            child: ExcludeSemantics(
              excluding: withAuth == null,
              child: AnimatedOpacity(
                opacity: withAuth == null ? 0 : 1,
                duration: defaultAnimationDuration,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    ListenableBuilder(
                      listenable: Listenable.merge([
                        usernameController,
                        apikeyController,
                      ]),
                      builder: (context, _) {
                        Widget child = Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                t(
                                  isEditing
                                      ? 'Save'
                                      : (withAuth == true
                                            ? 'Log in'
                                            : 'Browse anonymously'),
                                ),
                              ),
                              if (!isEditing) ...[
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward, size: 18),
                              ],
                            ],
                          ),
                        );
                        return isFulfilled
                            ? ElevatedButton(onPressed: submit, child: child)
                            : OutlinedButton(onPressed: submit, child: child);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthModeSelector extends StatelessWidget {
  const _AuthModeSelector({required this.withAuth, required this.onChanged});

  final bool? withAuth;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    ButtonStyle? themeStyle = TextButtonTheme.of(context).style;

    Widget segment(String label, bool selected, VoidCallback onTap) {
      return Expanded(
        child: TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            foregroundColor: scheme.onSurface,
            backgroundColor: selected
                ? scheme.primary.withValues(alpha: 0.08)
                : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(
                color: selected ? scheme.primary : Colors.transparent,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.standard,
            textStyle: TextStyle(
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ).merge(themeStyle),
          child: Text(label),
        ),
      );
    }

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          segment(t('Sign in'), withAuth == true, () => onChanged(true)),
          segment(t('Guest'), withAuth == false, () => onChanged(false)),
        ],
      ),
    );
  }
}
