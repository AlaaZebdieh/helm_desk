import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/config/app_settings.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/utils/extensions/context_extensions.dart';
import '../../../../app/utils/extensions/datetime_extensions.dart';
import '../../domain/entities/reply.dart';
import '../../domain/entities/reply_body_parser.dart';
import 'reply_attachment_button.dart';

class ReplyBubble extends StatelessWidget {
  final Reply reply;

  const ReplyBubble({super.key, required this.reply});

  bool get _isMine {
    final agentId = AppSettings().agent?.id;
    return agentId != null && reply.authorId == agentId;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final customColors = context.customColors;
    final isMine = _isMine;
    final parsed = ReplyBodyParser.parse(reply.body);
    final hasAttachment = parsed.attachment != null;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Align(
        alignment: isMine
            ? AlignmentDirectional.centerEnd
            : AlignmentDirectional.centerStart,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: context.width * 0.78),
          child: Column(
            crossAxisAlignment: isMine
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              if (!isMine)
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 4.w, bottom: 4.h),
                  child: Text(
                    reply.authorName,
                    style: AppTextStyles.subTitle(
                      context,
                      fontSize: 12,
                      color: customColors.textSecondary,
                    ),
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: isMine
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isMine && hasAttachment)
                    ReplyAttachmentButton(
                      attachment: parsed.attachment!,
                      isMine: isMine,
                    ),
                  if (parsed.text.isNotEmpty)
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        constraints: BoxConstraints(maxWidth: 300.w),
                        decoration: BoxDecoration(
                          color: isMine
                              ? colors.primary.withValues(alpha: 0.1)
                              : customColors.surfaceLight,
                          borderRadius: BorderRadiusDirectional.only(
                            topStart: Radius.circular(12.r),
                            topEnd: Radius.circular(isMine ? 0 : 12.r),
                            bottomStart: Radius.circular(isMine ? 12.r : 0),
                            bottomEnd: Radius.circular(12.r),
                          ),
                          border: Border.all(
                            color: isMine
                                ? colors.primary.withValues(alpha: 0.2)
                                : customColors.border,
                            width: 1.r,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: customColors.shadow.withValues(alpha: 0.05),
                              blurRadius: 3.r,
                              offset: Offset(1.w, 2.h),
                            ),
                          ],
                        ),
                        child: Text(
                          parsed.text,
                          style: AppTextStyles.bodyLarge(
                            context,
                            fontSize: 12,
                            height: 1.45,
                            color: customColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  if (!isMine && hasAttachment)
                    ReplyAttachmentButton(
                      attachment: parsed.attachment!,
                      isMine: isMine,
                    ),
                ],
              ),
              Padding(
                padding: EdgeInsetsDirectional.only(
                  start: 4.w,
                  end: 4.w,
                  top: 4.h,
                ),
                child: Text(
                  reply.createdAt.formattedTime_hhmm_a,
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
      ),
    );
  }
}
