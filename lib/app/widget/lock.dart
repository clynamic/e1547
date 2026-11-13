import 'package:animations/animations.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';

enum FingerprintOutcome {
  unlocked,
  canceled,
  lockedOut,
  lockedOutLong,
  unavailable;

  String? get words => switch (this) {
    unlocked || canceled => null,
    lockedOut => 'Too many attempts. Try again in 30 seconds.',
    lockedOutLong => 'Too many attempts. Use your screen lock instead.',
    unavailable =>
      'Your fingerprint is not available. Use your screen lock instead.',
  };
}

Future<FingerprintOutcome> askFingerprint({
  String cancel = 'Cancel',
  bool screenLock = false,
}) async {
  final String app = AppInfo.instance.appName;
  try {
    final bool unlocked = await LocalAuthentication().authenticate(
      localizedReason: '$app is locked',
      authMessages: [
        AndroidAuthMessages(
          signInTitle: 'Unlock $app',
          signInHint: '',
          cancelButton: cancel,
        ),
      ],
      biometricOnly: !screenLock,
      persistAcrossBackgrounding: true,
    );
    return unlocked ? FingerprintOutcome.unlocked : FingerprintOutcome.canceled;
  } on LocalAuthException catch (e) {
    return switch (e.code) {
      LocalAuthExceptionCode.temporaryLockout => FingerprintOutcome.lockedOut,
      LocalAuthExceptionCode.biometricLockout =>
        FingerprintOutcome.lockedOutLong,
      LocalAuthExceptionCode.noBiometricsEnrolled ||
      LocalAuthExceptionCode.noBiometricHardware ||
      LocalAuthExceptionCode.biometricHardwareTemporarilyUnavailable =>
        FingerprintOutcome.unavailable,
      _ => FingerprintOutcome.canceled,
    };
  }
}

class LockScreen extends StatefulWidget {
  const LockScreen({
    super.key,
    required this.child,
    this.relockAfter = const Duration(seconds: 30),
  });

  final Widget child;
  final Duration relockAfter;

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  late final AppLifecycleListener _lifecycle;

  DateTime? _hiddenAt;
  late bool locked = enabled;
  int _locks = 0;

  Settings get settings => context.read<Settings>();
  bool get enabled =>
      settings.appPin.value != null || settings.biometricAuth.value;

  void lock() => setState(() {
    locked = true;
    _locks++;
  });

  void unlock() => setState(() => locked = false);

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onHide: () => _hiddenAt = DateTime.now(),
      onShow: () {
        final DateTime? hiddenAt = _hiddenAt;
        _hiddenAt = null;
        if (hiddenAt == null || locked || !enabled) return;
        if (DateTime.now().difference(hiddenAt) >= widget.relockAfter) lock();
      },
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: Listenable.merge([settings.appPin, settings.biometricAuth]),
    builder: (context, child) {
      final bool shown = enabled && locked;
      return Stack(
        fit: StackFit.passthrough,
        children: [
          Visibility(visible: !shown, maintainState: true, child: widget.child),
          PageTransitionSwitcher(
            transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
                FadeThroughTransition(
                  animation: primaryAnimation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                ),
            child: shown
                ? AppLock(
                    key: ValueKey(_locks),
                    pin: settings.appPin.value,
                    fingerprint: settings.biometricAuth.value,
                    onUnlock: unlock,
                  )
                : null,
          ),
        ],
      );
    },
  );
}

class AppLock extends StatefulWidget {
  const AppLock({
    super.key,
    required this.pin,
    required this.fingerprint,
    required this.onUnlock,
  });

  final String? pin;
  final bool fingerprint;
  final VoidCallback onUnlock;

  @override
  State<AppLock> createState() => _AppLockState();
}

class _AppLockState extends State<AppLock> {
  bool _asking = false;
  FingerprintOutcome? _outcome;

  Future<void> _ask({bool screenLock = false}) async {
    if (_asking) return;
    setState(() => _asking = true);
    final FingerprintOutcome outcome = await askFingerprint(
      cancel: widget.pin != null ? 'Use PIN' : 'Cancel',
      screenLock: screenLock,
    );
    if (!mounted) return;
    if (outcome == FingerprintOutcome.unlocked) {
      widget.onUnlock();
      return;
    }
    setState(() {
      _asking = false;
      _outcome = outcome;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.fingerprint) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _ask());
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? message = _outcome?.words;
    if (widget.pin case final pin?) {
      return Scaffold(
        body: SafeArea(
          child: PinEntry(
            title: 'Enter your PIN',
            message: message,
            extraKey: widget.fingerprint
                ? PinKey(
                    surface: false,
                    onTap: _ask,
                    child: Icon(
                      Icons.fingerprint,
                      semanticLabel: 'Fingerprint',
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                : null,
            onEntered: (entered) {
              if (entered != pin) return 'Wrong PIN. Try again.';
              widget.onUnlock();
              return null;
            },
          ),
        ),
      );
    }
    return FingerprintLock(
      message: message,
      screenLock: message != null,
      asking: _asking,
      onUnlock: () => _ask(screenLock: message != null),
    );
  }
}

class FingerprintLock extends StatelessWidget {
  const FingerprintLock({
    super.key,
    required this.message,
    required this.screenLock,
    required this.asking,
    required this.onUnlock,
  });

  final String? message;
  final bool screenLock;
  final bool asking;
  final VoidCallback onUnlock;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final RoundedRectangleBorder shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppStyle.of(context).largeRadius),
    );
    const Size size = Size.fromHeight(48);
    const TextStyle label = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
    );
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 40,
            right: 40,
            top: 196,
            child: Column(
              spacing: 16,
              children: [
                Text(
                  '${AppInfo.instance.appName} is locked',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    height: 32 / 24,
                  ),
                ),
                if (message case final message?)
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 20 / 14,
                      color: dimTextColor(context),
                    ),
                  ),
              ],
            ),
          ),
          if (!asking)
            Positioned(
              left: 32,
              right: 32,
              bottom: 56,
              child: screenLock
                  ? OutlinedButton(
                      onPressed: onUnlock,
                      style: OutlinedButton.styleFrom(
                        shape: shape,
                        minimumSize: size,
                        foregroundColor: theme.colorScheme.onSurface,
                        side: BorderSide(color: AppStyle.of(context).outline),
                        textStyle: label,
                      ),
                      child: const Text('Use screen lock'),
                    )
                  : FilledButton.icon(
                      onPressed: onUnlock,
                      style: FilledButton.styleFrom(
                        shape: shape,
                        minimumSize: size,
                        textStyle: label,
                      ),
                      icon: const Icon(Icons.fingerprint),
                      label: const Text('Unlock'),
                    ),
            ),
        ],
      ),
    );
  }
}
