import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/utils/extensions/context_extensions.dart';

class InboxEmptyState extends StatelessWidget {
  const InboxEmptyState({super.key});

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
              width: 88.w,
              height: 88.w,
              decoration: BoxDecoration(
                color: customColors.primarySoft.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inbox_outlined,
                size: 44.r,
                color: colors.primary.withValues(alpha: 0.65),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              context.translate('no_tickets'),
              textAlign: TextAlign.center,
              style: AppTextStyles.titleMedium(
                context,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              context.translate('no_tickets_hint'),
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
