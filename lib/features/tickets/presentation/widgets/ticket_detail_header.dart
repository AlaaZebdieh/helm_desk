import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/utils/extensions/context_extensions.dart';
import '../../../../app/widgets/app_button.dart';
import '../../domain/entities/ticket.dart';
import 'ticket_badge.dart';
import 'ticket_priority_dropdown.dart';
import 'ticket_status_dropdown.dart';

class TicketDetailHeader extends StatelessWidget {
  final Ticket ticket;
  final bool isSubmitting;
  final ValueChanged<String>? onStatusChanged;
  final ValueChanged<String>? onPriorityChanged;
  final VoidCallback? onClaim;

  const TicketDetailHeader({
    super.key,
    required this.ticket,
    required this.isSubmitting,
    this.onStatusChanged,
    this.onPriorityChanged,
    this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    final customColors = context.customColors;
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          bottom: BorderSide(color: customColors.border, width: 1.r),
        ),
        boxShadow: [
          BoxShadow(
            color: customColors.shadow.withValues(alpha: 0.25),
            blurRadius: 6.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TicketBadge.status(context, ticket.status),
              SizedBox(width: 8.w),
              TicketBadge.priority(context, ticket.priority),
            ],
          ),
          SizedBox(height: 12.h),
          _InfoRow(
            icon: Icons.person_outline_rounded,
            label: context.translate('customer'),
            value: ticket.customer,
          ),
          SizedBox(height: 8.h),
          _InfoRow(
            icon: Icons.support_agent_outlined,
            label: context.translate('assignee'),
            value: ticket.assigneeId ?? context.translate('unassigned'),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              TicketStatusDropdown(
                value: ticket.status,
                onChanged: isSubmitting ? null : onStatusChanged,
              ),
              SizedBox(width: 10.w),
              TicketPriorityDropdown(
                value: ticket.priority,
                onChanged: isSubmitting ? null : onPriorityChanged,
              ),
            ],
          ),
          if (ticket.assigneeId == null) ...[
            SizedBox(height: 12.h),
            AppButton(
              text: context.translate('claim'),
              height: 42,
              radius: 12,
              isLoading: isSubmitting,
              onClickEvent: isSubmitting ? null : onClaim,
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final customColors = context.customColors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18.r, color: customColors.textSecondary),
        SizedBox(width: 8.w),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: AppTextStyles.bodyLarge(context, fontSize: 13),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: AppTextStyles.subTitle(
                    context,
                    fontSize: 13,
                    color: customColors.textSecondary,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: AppTextStyles.bodyLarge(
                    context,
                    fontSize: 13,
                    color: customColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
