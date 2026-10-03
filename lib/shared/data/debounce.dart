import 'dart:async';
import 'dart:ui';

/// Runs an action only after [delay] has passed without another call.
///
/// A pending action can be applied right away with [flush],
/// which keeps "live apply" semantics when a widget is torn down.
class Debouncer {
  Debouncer({this.delay = const Duration(milliseconds: 300)});

  /// The idle time after the last call before the action runs.
  final Duration delay;

  Timer? _timer;
  VoidCallback? _pending;

  /// Schedules [action], replacing any pending one.
  void call(VoidCallback action) {
    _pending = action;
    _timer?.cancel();
    _timer = Timer(delay, _run);
  }

  void _run() {
    final action = _pending;
    _pending = null;
    _timer = null;
    action?.call();
  }

  /// Applies a pending action right away, if any.
  void flush() {
    if (_timer == null) return;
    _timer!.cancel();
    _run();
  }

  /// Drops any pending action without running it.
  void dispose() {
    _timer?.cancel();
    _timer = null;
    _pending = null;
  }
}
