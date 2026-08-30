import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  // _goNext(BuildContext context) {
  // sl<NotificationsService>().setUpNotifications(true);//todo uncommit when connect firebase project
  // if (Constants.token.isNotEmpty) {
  //   Navigator.pushReplacementNamed(context, Routes.mainRoute);
  // } else if (sl<SharedPreferences>().containsKey(
  //   AppStrings.isSeenOnboarding,
  // )) {
  //   Navigator.pushReplacementNamed(
  //     context,
  //     Routes.mainRoute,
  //   ); //todo change for navigate auth
  // } else {
  //   Navigator.pushReplacementNamed(context, Routes.onboardingRoute);
  // }
  // }

  // _startDelay(BuildContext context) {
  //   Future.delayed(const Duration(milliseconds: 5000), () => _goNext(context));
  // }

  @override
  Widget build(BuildContext context) {
    // _startDelay(context);
    return Scaffold(body: Container());
  }
}
