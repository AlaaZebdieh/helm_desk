part of 'startup_cubit.dart';

abstract class StartupState extends Equatable {
  const StartupState();

  @override
  List<Object> get props => [];
}

class StartupInitial extends StartupState {}

class NetworkStateChanged extends StartupState {
  final bool isConnected;

  const NetworkStateChanged({required this.isConnected});

  @override
  List<Object> get props => [isConnected];
}

class SettingsLoaded extends StartupState {
  final String lang;
  final ThemeMode theme;

  const SettingsLoaded({required this.lang, required this.theme});

  @override
  List<Object> get props => [lang, theme];
}

class LanguageChanged extends StartupState {
  final String lang;

  const LanguageChanged({required this.lang});

  @override
  List<Object> get props => [lang];
}

class ThemeChanged extends StartupState {
  final ThemeMode theme;

  const ThemeChanged({required this.theme});

  @override
  List<Object> get props => [theme];
}

class SessionChecking extends StartupState {}

class SessionNavigateToLogin extends StartupState {}

class SessionNavigateToInbox extends StartupState {}
