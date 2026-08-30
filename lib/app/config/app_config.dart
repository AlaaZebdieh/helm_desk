class AppConfig {
  // Environment: dev / prod
  static const bool isDebug = true;
  static const String langDefault = "ar";

  // API URL
  static String get baseUrl {
    return isDebug ? "https://dev-api.example.com" : "https://api.example.com";
  }

  // أي إعدادات أخرى للتطبيق
  static const int timeoutSeconds = 30;
}
