import '../../../../core/storage/keys.dart';
import '../../../../core/storage/local_storage_service.dart';

abstract class StartupLocalDatasource {
  Future<String?> getSavedLang();
  Future<String?> getSavedTheme();

  Future<void> changeLang(String lang);
  Future<void> changeTheme(String theme);
}

class StartupLocalDatasourceImpl implements StartupLocalDatasource {
  final LocalStorageService localStorageService;

  StartupLocalDatasourceImpl({required this.localStorageService});

  @override
  Future<String?> getSavedLang() async {
    try {
      return await localStorageService.read(Keys.lang);
    } catch (e) {
      throw Exception("Failed to load language: $e");
    }
  }

  @override
  Future<String?> getSavedTheme() async {
    try {
      return await localStorageService.read(Keys.theme);
    } catch (e) {
      throw Exception("Failed to load theme: $e");
    }
  }

  @override
  Future<void> changeLang(String lang) async {
    try {
      await localStorageService.write(Keys.lang, lang);
    } catch (e) {
      throw Exception("Failed to save language: $e");
    }
  }

  @override
  Future<void> changeTheme(String theme) async {
    try {
      await localStorageService.write(Keys.theme, theme);
    } catch (e) {
      throw Exception("Failed to save theme: $e");
    }
  }
}
