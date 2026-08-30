import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../features/auth/domain/entities/agent.dart';
import 'app_config.dart';
import '../../core/storage/keys.dart';
import '../../injection_container.dart';
import '../../app/utils/extensions/getit_extensions.dart';

class AppSettings {
  static final AppSettings _instance = AppSettings._internal();
  factory AppSettings() => _instance;
  AppSettings._internal();

  String token = "";
  String refreshToken = "";
  Agent? agent;
  String countryCode = "Sy";
  ThemeMode currentTheme = ThemeMode.light;
  String currentLang = AppConfig.langDefault;
  String platform = Platform.isIOS ? "ios" : "android";

  Future<void> init() async {
    final storage = sl.secureStorage;
    token = await storage.read(Keys.authToken) ?? "";
    refreshToken = await storage.read(Keys.refreshToken) ?? "";
    final agentRaw = await storage.read(Keys.agentJson);
    if (agentRaw != null && agentRaw.isNotEmpty) {
      try {
        final map = jsonDecode(agentRaw) as Map<String, dynamic>;
        agent = Agent(
          id: map['id'] as String,
          name: map['name'] as String,
          email: map['email'] as String,
        );
      } catch (_) {
        agent = null;
      }
    }
  }

  String get countryCodeUpperCase => countryCode.toUpperCase();

  bool get isLoggedIn => token.isNotEmpty;

  Future<void> setToken(String newToken) async {
    token = newToken;
    await sl.secureStorage.write(Keys.authToken, newToken);
  }

  Future<void> setSession({
    required String accessToken,
    required String refresh,
    required Agent agentData,
  }) async {
    token = accessToken;
    refreshToken = refresh;
    agent = agentData;
    final storage = sl.secureStorage;
    await storage.write(Keys.authToken, accessToken);
    await storage.write(Keys.refreshToken, refresh);
    await storage.write(
      Keys.agentJson,
      jsonEncode({
        'id': agentData.id,
        'name': agentData.name,
        'email': agentData.email,
      }),
    );
  }

  Future<void> clearSession() async {
    token = "";
    refreshToken = "";
    agent = null;
    final storage = sl.secureStorage;
    await storage.delete(Keys.authToken);
    await storage.delete(Keys.refreshToken);
    await storage.delete(Keys.agentJson);
  }

  @Deprecated('Use clearSession')
  Future<void> clearToken() => clearSession();

  bool get isArabic => currentLang == "ar";

  Future<void> setLanguage(String langCode) async {
    currentLang = langCode;
  }
}
