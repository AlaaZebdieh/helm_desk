import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/utils/extensions/context_extensions.dart';

class TicketBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const TicketBadge({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  factory TicketBadge.status(BuildContext context, String status) {
    final colors = context.colors;
    final customColors = context.customColors;

    final (bg, fg) = switch (status.toLowerCase()) {
      'open' => (customColors.primarySoft.withValues(alpha: 0.15), colors.primary),
      'pending' => (customColors.secondarySoft.withValues(alpha: 0.45), colors.secondary),
      'solved' => (customColors.surfaceLight, customColors.primaryMuted),
      _ => (customColors.surfaceLight, customColors.textSecondary),
    };

    return TicketBadge(
      label: context.translate(status),
      backgroundColor: bg,
      textColor: fg,
    );
  }

  factory TicketBadge.priority(BuildContext context, String priority) {
    final colors = context.colors;
    final customColors = context.customColors;

    final (bg, fg) = switch (priority.toLowerCase()) {
      'urgent' || 'high' => (colors.error.withValues(alpha: 0.12), colors.error),
      'medium' || 'normal' => (
          customColors.secondarySoft.withValues(alpha: 0.45),
          colors.secondary,
        ),
      'low' => (customColors.surfaceLight, customColors.textSecondary),
      _ => (customColors.surfaceLight, customColors.textSecondary),
    };

    return TicketBadge(
      label: context.translate(priority),
      backgroundColor: bg,
      textColor: fg,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodyMedium(
          context,
          fontSize: 11,
          color: textColor,
        ),
      ),
    );
  }
}
