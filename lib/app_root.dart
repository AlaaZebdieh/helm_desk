import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app/theme/app_theme.dart';
import 'injection_container.dart';
import 'app/config/app_strings.dart';
import 'app/config/app_settings.dart';
import 'app/navigation/app_router.dart';
import 'app/navigation/navigation_service.dart';
import 'app/localization/app_localizations_setup.dart';
import 'features/startup/presentation/cubit/startup_cubit.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<StartupCubit>()
            ..loadSettings()
            ..monitorNetwork(),
        ),
      ],
      child: BlocBuilder<StartupCubit, StartupState>(
        buildWhen: (previous, current) =>
            current is SettingsLoaded ||
            current is LanguageChanged ||
            current is ThemeChanged ||
            previous is StartupInitial,
        builder: (context, state) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            builder: (context, child) {
              return MaterialApp(
                title: AppSettings().isArabic
                    ? AppStrings.appNameAr
                    : AppStrings.appNameEn,
                debugShowCheckedModeBanner: false,
                navigatorKey: sl<NavigationService>().navigationKey,
                onGenerateRoute: AppRouter.onGenerateRoute,
                themeMode: AppSettings().currentTheme,
                locale: Locale(AppSettings().currentLang),
                supportedLocales: AppLocalizationsSetup.supportedLocales,
                theme: AppTheme.lightTheme(Locale(AppSettings().currentLang)),
                darkTheme:
                    AppTheme.darkTheme(Locale(AppSettings().currentLang)),
                localizationsDelegates:
                    AppLocalizationsSetup.localizationsDelegates,
                localeResolutionCallback:
                    AppLocalizationsSetup.localeResolutionCallback,
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaler: const TextScaler.linear(1),
                    ),
                    child: Directionality(
                      textDirection: AppSettings().isArabic
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      child: child ?? const SizedBox.shrink(),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
