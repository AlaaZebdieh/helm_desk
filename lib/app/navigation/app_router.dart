import 'package:flutter/material.dart';

import '../../features/auth/presentation/screens/home_placeholder_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/startup/presentation/screens/splash_screen.dart';
import '../../features/tickets/presentation/screens/inbox_screen.dart';

class Routes {
  static const String initialRoute = '/';
  static const String loginRoute = '/login';
  static const String homeRoute = '/home';
  static const String inboxRoute = '/inbox';
}

class AppRouter {
  static final Map<String, Widget Function(BuildContext, Object?)> _routes = {
    Routes.initialRoute: (context, args) => const SplashScreen(),
    Routes.loginRoute: (context, args) => const LoginScreen(),
    Routes.homeRoute: (context, args) => const HomePlaceholderScreen(),
    Routes.inboxRoute: (context, args) => const InboxScreen(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final routeBuilder = _routes[settings.name];

    if (routeBuilder != null) {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => routeBuilder(context, settings.arguments),
      );
    }

    return MaterialPageRoute(
      builder: (_) =>
          const Scaffold(body: Center(child: Text("No Route Found"))),
      settings: settings,
    );
  }
}
