import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  void pop([dynamic result]) {
    debugPrint("Navigation: pop");
    _navigationKey.currentState?.pop(result);
  }

  Future<dynamic> pushNamed(String routeName, {dynamic arguments}) {
    debugPrint("Navigation: pushNamed -> $routeName");
    return _navigationKey.currentState!.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  Future<dynamic> pushReplacementNamed(String routeName, {dynamic arguments}) {
    debugPrint("Navigation: pushReplacementNamed -> $routeName");
    return _navigationKey.currentState!.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  Future<dynamic> pushNamedAndRemoveUntil(
    String routeName, {
    dynamic arguments,
  }) {
    debugPrint("Navigation: pushNamedAndRemoveUntil -> $routeName");
    return _navigationKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  void popUntil(bool Function(Route<dynamic>) predicate) {
    debugPrint("Navigation: popUntil");
    _navigationKey.currentState?.popUntil(predicate);
  }
}
