import 'dart:async' show StreamSubscription;

import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../../app/config/app_settings.dart';
import '../../../../core/usecases/execute_usecase.dart';
import '../../../../core/usecases/no_params.dart';
import '../../../auth/domain/usecases/is_logged_in_usecase.dart';
import '../../domain/usecases/change_lang_usecase.dart';
import '../../domain/usecases/change_theme_usecase.dart';
import '../../domain/usecases/get_saved_lang_usecase.dart';
import '../../domain/usecases/get_saved_theme_usecase.dart';
import '../../domain/usecases/get_country_code_usecase.dart';
import '../../../../app/utils/extensions/enum_extensions.dart';
import '../../../../core/observers/app_lifecycle_observer.dart';
import '../../../../app/utils/extensions/either_future_extensions.dart';

part 'startup_state.dart';

class StartupCubit extends Cubit<StartupState> with UsecaseExecutor<StartupState> {
  final GetSavedLangUsecase getSavedLangUsecase;
  final GetSavedThemeUsecase getSavedThemeUsecase;
  final ChangeLangUsecase changeLangUsecase;
  final ChangeThemeUsecase changeThemeUsecase;
  final GetCountryCodeUsecase getCountryCodeUsecase;
  final IsLoggedInUsecase isLoggedInUsecase;

  StartupCubit({
    required this.getSavedLangUsecase,
    required this.getSavedThemeUsecase,
    required this.changeLangUsecase,
    required this.changeThemeUsecase,
    required this.getCountryCodeUsecase,
    required this.isLoggedInUsecase,
  }) : super(StartupInitial());

  StreamSubscription<InternetConnectionStatus>? _subscription;
  InternetConnectionStatus _lastStatus = InternetConnectionStatus.connected;

  /// متابعة حالة الإنترنت
  Future<void> monitorNetwork() async {
    final hasConnection =
        await InternetConnectionChecker.instance.hasConnection;
    _lastStatus = hasConnection
        ? InternetConnectionStatus.connected
        : InternetConnectionStatus.disconnected;

    _subscription = InternetConnectionChecker.instance.onStatusChange.listen((
      status,
    ) {
      if (AppLifecycleObserver.isInForeground && status != _lastStatus) {
        _lastStatus = status;
        emit(
          NetworkStateChanged(
            isConnected: status == InternetConnectionStatus.connected,
          ),
        );
      }
    });
  }

  Future<void> loadSettings() async {
    // getCountryCodeUsecase(NoParams());
    
    await getSavedLangUsecase(NoParams()).handle(
      onSuccess: (res) {
        if (res != null) {
          AppSettings().setLanguage(res);
        }
      },
    );

    await getSavedThemeUsecase(NoParams()).handle(
      onSuccess: (res) {
        if (res != null) {
          AppSettings().currentTheme = ThemeModeX.fromString(res);
        }
      },
    );

    emit(
      SettingsLoaded(
        lang: AppSettings().currentLang,
        theme: AppSettings().currentTheme,
      ),
    );
  }

  void toArabic() => _changeLang("ar");
  void toEnglish() => _changeLang("en");

  Future<void> _changeLang(String lang) async {
    await changeLangUsecase(
      lang,
    ).handle(onSuccess: (_) => AppSettings().currentLang = lang);
    emit(LanguageChanged(lang: AppSettings().currentLang));
  }

  Future<void> changeTheme(ThemeMode theme) async {
    await changeThemeUsecase(
      theme.name,
    ).handle(onSuccess: (_) => AppSettings().currentTheme = theme);
    emit(ThemeChanged(theme: AppSettings().currentTheme));
  }

  Future<void> checkSession() async {
    await executeUsecase(
      () => isLoggedInUsecase(NoParams()),
      onLoading: () => emit(SessionChecking()),
      onSuccess: (isLoggedIn) {
        emit(isLoggedIn ? SessionNavigateToInbox() : SessionNavigateToLogin());
      },
      onFailure: (_) => emit(SessionNavigateToLogin()),
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
