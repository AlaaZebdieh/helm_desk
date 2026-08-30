import 'dart:io';

import 'package:path_provider/path_provider.dart';

class AttachmentCacheService {
  Future<Directory> _cacheDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final cacheDir = Directory('${dir.path}/attachment_cache');
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }
    return cacheDir;
  }

  Future<void> save(String attachmentId, File source) async {
    final dir = await _cacheDir();
    await source.copy('${dir.path}/$attachmentId');
  }

  Future<File?> get(String attachmentId) async {
    final file = File('${(await _cacheDir()).path}/$attachmentId');
    return file.existsSync() ? file : null;
  }
}
