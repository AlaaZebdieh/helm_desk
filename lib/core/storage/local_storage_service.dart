abstract class LocalStorageService {
  /// كتابة قيمة
  Future<void> write(String key, String value);

  /// قراءة قيمة
  Future<String?> read(String key);

  /// حذف قيمة
  Future<void> delete(String key);

  /// حذف كل القيم
  Future<void> deleteAll();

  /// التأكد إذا المفتاح موجود
  Future<bool> containsKey(String key);

  /// جلب كل القيم
  Future<Map<String, String>> readAll();
}
