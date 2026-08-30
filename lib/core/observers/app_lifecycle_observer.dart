import 'package:flutter/widgets.dart';

class AppLifecycleObserver with WidgetsBindingObserver {
  static AppLifecycleState? currentState;

  /// Optional callbacks
  final void Function()? onResume;
  final void Function()? onPause;
  final void Function()? onInactive;
  final void Function()? onDetached;

  AppLifecycleObserver({
    this.onResume,
    this.onPause,
    this.onInactive,
    this.onDetached,
  });

  /// Start observing lifecycle
  void startObserving() {
    WidgetsBinding.instance.addObserver(this);
    currentState = WidgetsBinding.instance.lifecycleState;
  }

  /// Stop observing lifecycle
  void stopObserving() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    currentState = state;

    switch (state) {
      case AppLifecycleState.resumed:
        onResume?.call();
        break;

      case AppLifecycleState.paused:
        onPause?.call();
        break;

      case AppLifecycleState.inactive:
        onInactive?.call();
        break;

      case AppLifecycleState.detached:
        onDetached?.call();
        break;

      default:
        break;
    }
  }

  /// Is app active and visible?
  static bool get isInForeground => currentState == AppLifecycleState.resumed;

  /// Is app in background?
  static bool get isInBackground => currentState == AppLifecycleState.paused;
}
