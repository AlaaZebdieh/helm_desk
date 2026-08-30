import 'package:shared_preferences/shared_preferences.dart';

import 'local_storage_service.dart';

class SharedPrefsService implements LocalStorageService {
  final SharedPreferences _prefs;

  SharedPrefsService(this._prefs);

  @override
  Future<void> write(String key, String value) async {
    await _prefs.setString(key, value);
  }

  @override
  Future<String?> read(String key) async {
    return _prefs.getString(key);
  }

  @override
  Future<void> delete(String key) async {
    await _prefs.remove(key);
  }

  @override
  Future<void> deleteAll() async {
    await _prefs.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    return _prefs.containsKey(key);
  }

  @override
  Future<Map<String, String>> readAll() async {
    final keys = _prefs.getKeys();
    final Map<String, String> allData = {};
    for (var key in keys) {
      final value = _prefs.getString(key);
      if (value != null) {
        allData[key] = value;
      }
    }
    return allData;
  }
}
