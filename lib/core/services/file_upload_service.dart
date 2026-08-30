import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../errors/exceptions/file_upload_exception.dart';

class FileUploadService {
  final Dio dio;
  FileUploadService(this.dio);

  // multipart/form-data upload
  Future<String> uploadMultipart({
    required String path,
    required File file,
    required ValueNotifier<double> progressNotifier,
    CancelToken? cancelToken,
    Map<String, dynamic>? fields,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final form = FormData.fromMap({
        ...?fields,
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.uri.pathSegments.last,
        ),
      });

      final resp = await dio.post(
        path,
        data: form,
        cancelToken: cancelToken,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data', ...?headers},
        ),
        onSendProgress: (sent, total) {
          if (total > 0) progressNotifier.value = sent / total;
        },
      );

      // adjust depending on your API shape
      if (resp.statusCode != null && resp.statusCode! < 300) {
        return resp.data['file_url'] ?? resp.data['data']?['file_url'] ?? '';
      }
      throw FileUploadException(
        code: resp.statusCode,
        msg: 'Upload failed: ${resp.statusCode}',
        data: resp.data,
      );
    } on DioException catch (e) {
      throw FileUploadException(
        code: e.response?.statusCode,
        msg: e.message ?? 'Upload error',
        data: e.response?.data,
      );
    } catch (e) {
      throw FileUploadException(msg: e.toString());
    }
  }

  // upload to presigned URL (PUT) - good for S3-like
  Future<void> uploadToPresignedUrl({
    required String uploadUrl,
    required File file,
    required ValueNotifier<double> progressNotifier,
    CancelToken? cancelToken,
    String mime = 'application/octet-stream',
  }) async {
    try {
      await dio.put(
        uploadUrl,
        data: file.openRead(),
        options: Options(headers: {'Content-Type': mime}),
        cancelToken: cancelToken,
        onSendProgress: (sent, total) {
          if (total > 0) progressNotifier.value = sent / total;
        },
      );
    } on DioException catch (e) {
      throw FileUploadException(
        code: e.response?.statusCode,
        msg: e.message ?? 'Upload failed',
        data: e.response?.data,
      );
    }
  }
}
