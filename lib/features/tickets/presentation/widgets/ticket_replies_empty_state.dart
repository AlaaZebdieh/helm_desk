import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/utils/extensions/context_extensions.dart';

class TicketRepliesEmptyState extends StatelessWidget {
  const TicketRepliesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final customColors = context.customColors;
    final colors = context.colors;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                color: customColors.primarySoft.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                size: 36.r,
                color: colors.primary.withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              context.translate('no_replies'),
              textAlign: TextAlign.center,
              style: AppTextStyles.titleMedium(context, fontSize: 15),
            ),
            SizedBox(height: 6.h),
            Text(
              context.translate('no_replies_hint'),
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium(
                context,
                fontSize: 13,
                color: customColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
