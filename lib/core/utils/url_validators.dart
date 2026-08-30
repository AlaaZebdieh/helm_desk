class UrlValidators {
  /// تحقق من صحة أي URL عام
  static bool isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && uri.hasScheme && uri.hasAuthority;
  }

  /// تحقق إذا كان URL صورة (png, jpg, jpeg, gif, webp, avif)
  static bool isImageUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;

    final path = uri.path.toLowerCase();
    return path.endsWith('.jpg') ||
        path.endsWith('.jpeg') ||
        path.endsWith('.png') ||
        path.endsWith('.webp') ||
        path.endsWith('.avif') ||
        path.endsWith('.gif');
  }

  /// تحقق إذا كان URL صورة SVG فقط
  static bool isSvgUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;

    final path = uri.path.toLowerCase();
    return path.endsWith('.svg');
  }

  /// تحقق إذا كان URL فيديو (mp4)
  static bool isVideoUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;

    final path = uri.path.toLowerCase();
    return path.endsWith('.mp4');
  }

  /// تحقق إذا كان URL ملف PDF
  static bool isPdfUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;

    final path = uri.path.toLowerCase();
    return path.endsWith('.pdf');
  }
}
