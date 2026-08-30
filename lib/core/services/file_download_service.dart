import 'dart:io';
import 'package:dio/dio.dart';

import '../errors/exceptions/file_download_exception.dart';

class FileDownloadService {
  final Dio dio;
  FileDownloadService(this.dio);

  /// returns savePath on success
  Future<String> downloadFile({
    required String url,
    required String savePath,
    Map<String, dynamic>? headers,
    Function(double progress)? onProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final file = File(savePath);
      if (!await file.parent.exists()) {
        await file.parent.create(recursive: true);
      }

      await dio.download(
        url,
        savePath,
        options: Options(headers: headers),
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          if (total > 0 && onProgress != null) onProgress(received / total);
        },
      );

      return savePath;
    } on DioException catch (e) {
      throw FileDownloadException(
        code: e.response?.statusCode,
        msg: e.message ?? 'Download error',
        data: e.response?.data,
      );
    } catch (e) {
      throw FileDownloadException(msg: e.toString());
    }
  }
}
