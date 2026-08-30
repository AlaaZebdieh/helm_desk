import 'dart:io';

class AppConfig {
  static const bool isDebug = true;
  static const String langDefault = "ar";

  /// Android emulator uses 10.0.2.2 to reach host localhost.
  static String get baseUrl {
    if (!isDebug) return "https://api.example.com";
    if (Platform.isAndroid) return "http://10.0.2.2:4000";
    return "http://localhost:4000";
  }

  static const int timeoutSeconds = 30;
}
