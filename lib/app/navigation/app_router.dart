import 'package:flutter/material.dart';

import '../../features/startup/presentation/screens/splash_screen.dart';

class Routes {
  static const String initialRoute = '/';
  // static const String profileRoute = '/profile';
}

class AppRouter {
  static final Map<String, Widget Function(BuildContext, Object?)> _routes = {
    Routes.initialRoute: (context, args) => const SplashScreen(),
    // Routes.profileRoute: (context, args) => ProfileScreen(userId: args as String?),
    // Routes.changePasswordRoute: (context, args) => const ChangePasswordScreen(),
    // Routes.adsRoute: (context, args) => const AdsScreen(),
    // Routes.mainRoute: (context, args) => const MainScreen(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final routeBuilder = _routes[settings.name];

    if (routeBuilder != null) {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => routeBuilder(context, settings.arguments),
      );
    }

    // Route غير معروف
    return MaterialPageRoute(
      builder: (_) =>
          const Scaffold(body: Center(child: Text("No Route Found"))),
      settings: settings,
    );
  }
}
