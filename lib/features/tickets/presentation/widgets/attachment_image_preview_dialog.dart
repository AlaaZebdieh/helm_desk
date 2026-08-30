import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/utils/extensions/context_extensions.dart';

class AttachmentImagePreviewDialog extends StatelessWidget {
  final File file;
  final String title;

  const AttachmentImagePreviewDialog({
    super.key,
    required this.file,
    required this.title,
  });

  static Future<void> show(
    BuildContext context, {
    required File file,
    required String title,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: context.colors.shadow.withValues(alpha: 0.85),
      builder: (_) => AttachmentImagePreviewDialog(
        file: file,
        title: title,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final customColors = context.customColors;

    return Dialog(
      backgroundColor: colors.surface,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 8.w, 8.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleMedium(
                      context,
                      fontSize: 14,
                      color: customColors.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close_rounded,
                    color: customColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4,
              child: Image.file(
                file,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
