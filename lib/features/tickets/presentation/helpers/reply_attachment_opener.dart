import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

import '../../../../app/config/app_config.dart';
import '../../../../app/config/app_settings.dart';
import '../../../../app/helpers/toast_helper.dart';
import '../../../../app/utils/extensions/context_extensions.dart';
import '../../../../app/utils/extensions/string_extensions.dart';
import '../../../../core/services/attachment_cache_service.dart';
import '../../../../core/services/file_download_service.dart';
import '../../data/network/tickets_endpoints.dart';
import '../../domain/entities/reply_attachment.dart';
import '../widgets/attachment_image_preview_dialog.dart';

class ReplyAttachmentOpener {
  final AttachmentCacheService cacheService;
  final FileDownloadService downloadService;

  ReplyAttachmentOpener({
    required this.cacheService,
    required this.downloadService,
  });

  Future<void> open(BuildContext context, ReplyAttachment attachment) async {
    final cached = await cacheService.get(attachment.id);
    if (!context.mounted) return;
    if (cached != null) {
      await _openLocalFile(context, cached, attachment);
      return;
    }

    try {
      final tempDir = await getTemporaryDirectory();
      final savePath = '${tempDir.path}/${attachment.id}_${attachment.filename}';
      await downloadService.downloadFile(
        url: '${AppConfig.baseUrl}${TicketsEndpoints.attachment(attachment.id)}',
        savePath: savePath,
      );
      if (!context.mounted) return;
      await _openLocalFile(context, File(savePath), attachment);
    } catch (_) {
      if (!context.mounted) return;
      await _openRemoteUrl(context, attachment);
    }
  }

  Future<void> _openLocalFile(
    BuildContext context,
    File file,
    ReplyAttachment attachment,
  ) async {
    if (attachment.isImage) {
      if (!context.mounted) return;
      AttachmentImagePreviewDialog.show(
        context,
        file: file,
        title: attachment.filename,
      );
      return;
    }

    final uri = Uri.file(file.path);
    if (await launcher.canLaunchUrl(uri)) {
      await launcher.launchUrl(
        uri,
        mode: launcher.LaunchMode.externalApplication,
      );
      return;
    }

    if (!context.mounted) return;
    ToastHelper().error(
      context,
      msg: (ctx) => ctx.translate('file_download_failed'),
    );
  }

  Future<void> _openRemoteUrl(
    BuildContext context,
    ReplyAttachment attachment,
  ) async {
    final token = AppSettings().token;
    final url =
        '${AppConfig.baseUrl}${TicketsEndpoints.attachment(attachment.id)}'
        '?access_token=$token';

    try {
      await url.launchUrl;
    } catch (_) {
      if (!context.mounted) return;
      ToastHelper().error(
        context,
        msg: (ctx) => ctx.translate('file_download_failed'),
      );
    }
  }
}
