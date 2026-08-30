import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/navigation/app_router.dart';
import '../cubit/startup_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StartupCubit>().checkSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StartupCubit, StartupState>(
      listener: (context, state) {
        if (state is SessionNavigateToLogin) {
          Navigator.pushReplacementNamed(context, Routes.loginRoute);
        } else if (state is SessionNavigateToInbox) {
          Navigator.pushReplacementNamed(context, Routes.inboxRoute);
        }
      },
      child: const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
