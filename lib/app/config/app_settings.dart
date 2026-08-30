import 'dart:io';
import 'app_config.dart';

import 'package:flutter/material.dart';

import '../../core/storage/keys.dart';
import '../../injection_container.dart';
import '../../app/utils/extensions/getit_extensions.dart';

class AppSettings {
  // Singleton
  static final AppSettings _instance = AppSettings._internal();
  factory AppSettings() => _instance;
  AppSettings._internal();

  // Runtime values
  String token = "";
  String countryCode = "Sy";
  ThemeMode currentTheme = ThemeMode.light;
  String currentLang = AppConfig.langDefault;
  String platform = Platform.isIOS ? "ios" : "android";

  /// استدعاء مرة واحدة عند بدء التطبيق
  Future<void> init() async {
    final storedToken = await sl.secureStorage.read(Keys.authToken);
    token = storedToken ?? "";
  }

  String get countryCodeUpperCase => countryCode.toUpperCase();

  /// هل المستخدم مسجل دخول
  bool get isLoggedIn => token.isNotEmpty;

  /// تحديث token
  Future<void> setToken(String newToken) async {
    token = newToken;
    await sl.secureStorage.write(Keys.authToken, newToken);
  }

  /// مسح token عند تسجيل الخروج
  Future<void> clearToken() async {
    token = "";
    await sl.secureStorage.delete(Keys.authToken);
  }

  bool get isArabic => currentLang == "ar";

  Future<void> setLanguage(String langCode) async {
    currentLang = langCode;
  }
}
