import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/helpers/loading_helper.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/utils/extensions/context_extensions.dart';
import '../../../../app/widgets/app_text_field.dart';

class TicketChatComposer extends StatelessWidget {
  final TextEditingController controller;
  final File? attachment;
  final bool isSubmitting;
  final VoidCallback onPickAttachment;
  final VoidCallback onRemoveAttachment;
  final VoidCallback onSend;

  const TicketChatComposer({
    super.key,
    required this.controller,
    required this.attachment,
    required this.isSubmitting,
    required this.onPickAttachment,
    required this.onRemoveAttachment,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final customColors = context.customColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          top: BorderSide(color: customColors.border, width: 1.r),
        ),
        boxShadow: [
          BoxShadow(
            color: customColors.shadow.withValues(alpha: 0.2),
            blurRadius: 8.r,
            offset: Offset(0, -2.h),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 12.h),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (attachment != null) _AttachmentPreview(
              file: attachment!,
              onRemove: onRemoveAttachment,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _ComposerIconButton(
                  icon: Icons.attach_file_rounded,
                  onTap: isSubmitting ? null : onPickAttachment,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: AppTextField(
                    controller: controller,
                    hintText: context.translate('write_reply'),
                    // maxLines: 2,
                    height: 44,
                    borderRadius: 22,
                    textInputType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    isEnable: !isSubmitting,
                  ),
                ),
                SizedBox(width: 8.w),
                _SendButton(
                  isSubmitting: isSubmitting,
                  onTap: onSend,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AttachmentPreview extends StatelessWidget {
  final File file;
  final VoidCallback onRemove;

  const _AttachmentPreview({
    required this.file,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final customColors = context.customColors;
    final fileName = file.path.split('/').last;

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: customColors.border, width: 1.r),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.file(
                    file,
                    width: 80.w,
                    height: 80.w,
                    fit: BoxFit.cover,
                  ),
                ),
                PositionedDirectional(
                  top: -6.h,
                  end: -6.w,
                  child: Material(
                    color: context.colors.error,
                    shape: const CircleBorder(),
                    elevation: 2,
                    child: InkWell(
                      onTap: onRemove,
                      customBorder: const CircleBorder(),
                      child: Padding(
                        padding: EdgeInsets.all(4.r),
                        child: Icon(
                          Icons.close_rounded,
                          size: 14.r,
                          color: context.colors.surface,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            SizedBox(
              width: 80.w,
              child: Text(
                fileName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium(
                  context,
                  fontSize: 10,
                  color: customColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComposerIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _ComposerIconButton({
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final customColors = context.customColors;

    return Material(
      color: customColors.surfaceLight,
      borderRadius: BorderRadius.circular(22.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22.r),
        splashColor: colors.primary.withValues(alpha: 0.12),
        child: SizedBox(
          width: 44.w,
          height: 44.w,
          child: Icon(
            icon,
            size: 22.r,
            color: onTap == null ? customColors.disabled : colors.primary,
          ),
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  final bool isSubmitting;
  final VoidCallback onTap;

  const _SendButton({
    required this.isSubmitting,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: isSubmitting ? context.customColors.disabled : colors.primary,
      borderRadius: BorderRadius.circular(22.r),
      elevation: 0,
      child: InkWell(
        onTap: isSubmitting ? null : onTap,
        borderRadius: BorderRadius.circular(22.r),
        splashColor: colors.surface.withValues(alpha: 0.2),
        child: SizedBox(
          width: 44.w,
          height: 44.w,
          child: isSubmitting
              ? LoadingHelper.circular(context, strokeWidth: 2)
              : Icon(
                  Icons.send_rounded,
                  size: 20.r,
                  color: colors.surface,
                ),
        ),
      ),
    );
  }
}
