import 'dart:async';
import 'package:animations/animations.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:flutter_sub/flutter_sub.dart';
import 'package:local_auth/local_auth.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key, required this.child});

  final Widget child;

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  bool get biometrics => context.read<Settings>().biometricAuth.value;
  String? get pin => context.read<Settings>().appPin.value;
  bool get enabled => pin != null || biometrics;
  late bool locked = enabled;

  void lock() => setState(() => locked = true);
  void unlock() => setState(() => locked = false);

  @override
  Widget build(BuildContext context) {
    Widget? lock;

    if (pin != null) {
      lock = ScreenLock(
        title: Text(AppLocalizations.of(context).lockEnterPin),
        correctString: pin!,
        customizedButtonChild: biometrics
            ? const Icon(Icons.fingerprint)
            : null,
        customizedButtonTap: biometrics
            ? () => tryLocalAuth(context: context, onSuccess: unlock)
            : null,
        onOpened: biometrics
            ? () => tryLocalAuth(context: context, onSuccess: unlock)
            : null,
        onUnlocked: unlock,
        config: ScreenLockConfig(themeData: Theme.of(context)),
      );
    } else if (biometrics) {
      lock = BiometricsLockScreen(onSuccess: unlock);
    }

    bool showLock = lock != null && enabled && locked;

    return SubListener(
      listener: this.lock,
      listenable: Listenable.merge([
        context.read<Settings>().appPin,
        context.read<Settings>().biometricAuth,
      ]),
      builder: (context) => Stack(
        fit: StackFit.passthrough,
        children: [
          Visibility(
            visible: !showLock,
            maintainState: true,
            child: widget.child,
          ),
          PageTransitionSwitcher(
            transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
                FadeThroughTransition(
                  animation: primaryAnimation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                ),
            child: showLock ? lock! : null,
          ),
        ],
      ),
    );
  }
}

class BiometricsLockScreen extends StatefulWidget {
  const BiometricsLockScreen({super.key, required this.onSuccess});

  final VoidCallback onSuccess;

  @override
  State<BiometricsLockScreen> createState() => _BiometricsLockScreenState();
}

class _BiometricsLockScreenState extends State<BiometricsLockScreen> {
  bool failed = false;

  Future<void> tryAuth() async {
    setState(() => failed = false);
    await tryLocalAuth(
      context: context,
      onSuccess: widget.onSuccess,
      onFailure: () => setState(() => failed = true),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => tryAuth());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.fingerprint, size: 60),
            const SizedBox(height: 20),
            Text(
              failed
                  ? AppLocalizations.of(context).lockFailedAuth
                  : AppLocalizations.of(context).lockPleaseAuth,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            if (failed)
              TextButton(
                onPressed: tryAuth,
                child: Text(AppLocalizations.of(context).lockRetry),
              ),
          ],
        ),
      ),
    );
  }
}

Future<void> tryLocalAuth({
  required BuildContext context,
  VoidCallback? onSuccess,
  VoidCallback? onFailure,
}) async {
  ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
  final LocalAuthentication localAuth = LocalAuthentication();
  final l10n = AppLocalizations.of(context);
  await localAuth.stopAuthentication();
  try {
    bool success = await localAuth.authenticate(
      localizedReason: l10n.lockBiometricReason,
      persistAcrossBackgrounding: true,
    );
    if (success) {
      onSuccess?.call();
    } else {
      onFailure?.call();
    }
  } on LocalAuthException {
    messenger.showSnackBar(
      SnackBar(
        content: Text(l10n.lockBiometricFailure),
        duration: const Duration(milliseconds: 300),
      ),
    );
    onFailure?.call();
  }
}

Future<String?> registerPin(BuildContext context) async {
  Completer<String?> completer = Completer();
  await screenLockCreate(
    title: Text(AppLocalizations.of(context).lockEnterNewPin),
    confirmTitle: Text(AppLocalizations.of(context).lockConfirmNewPin),
    context: context,
    onConfirmed: (result) {
      completer.complete(result);
      Navigator.of(context).pop();
    },
    onCancelled: () {
      completer.complete(null);
      Navigator.of(context).pop();
    },
    config: ScreenLockConfig(themeData: Theme.of(context)),
  );

  return completer.future;
}
