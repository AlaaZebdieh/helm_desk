import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/utils/extensions/context_extensions.dart';
import '../../../../app/utils/extensions/datetime_extensions.dart';
import '../../domain/entities/ticket.dart';
import 'ticket_badge.dart';

class TicketCard extends StatelessWidget {
  final Ticket ticket;
  final VoidCallback onTap;

  const TicketCard({
    super.key,
    required this.ticket,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final customColors = context.customColors;
    final replyCount = ticket.replies.length;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Material(
        color: context.colors.surface,
        elevation: 0,
        borderRadius: BorderRadius.circular(14.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14.r),
          splashColor: customColors.primarySoft.withValues(alpha: 0.12),
          highlightColor: customColors.backgroundSelect.withValues(alpha: 0.35),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: customColors.border, width: 1.r),
              boxShadow: [
                BoxShadow(
                  color: customColors.shadow.withValues(alpha: 0.35),
                  blurRadius: 8.r,
                  offset: Offset(0, 2.h),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ticket.subject,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleMedium(
                      context,
                      fontSize: 15,
                      height: 1.35,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline_rounded,
                        size: 16.r,
                        color: customColors.textSecondary,
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          ticket.customer,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodyLarge(
                            context,
                            fontSize: 13,
                            color: customColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      TicketBadge.status(context, ticket.status),
                      SizedBox(width: 8.w),
                      TicketBadge.priority(context, ticket.priority),
                      const Spacer(),
                      if (replyCount > 0) ...[
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 14.r,
                          color: customColors.textSecondary,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          context.translate(
                            'replies_count',
                            arguments: {'count': '$replyCount'},
                          ),
                          style: AppTextStyles.bodyMedium(
                            context,
                            fontSize: 11,
                            color: customColors.textSecondary,
                          ),
                        ),
                        SizedBox(width: 10.w),
                      ],
                      Icon(
                        Icons.schedule_rounded,
                        size: 14.r,
                        color: customColors.textSecondary,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        ticket.updatedAt.formattedDateTime,
                        style: AppTextStyles.bodyMedium(
                          context,
                          fontSize: 11,
                          color: customColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
