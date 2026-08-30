import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/utils/extensions/context_extensions.dart';
import '../cubit/inbox_cubit.dart';

class InboxFiltersBar extends StatelessWidget {
  final InboxState state;

  const InboxFiltersBar({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final InboxLoaded? loaded = switch (state) {
      InboxLoaded loaded => loaded,
      _ => null,
    };
    final cubit = context.read<InboxCubit>();

    return SizedBox(
      height: 44.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsetsDirectional.only(start: 16.w, end: 16.w, bottom: 4.h),
        physics: const BouncingScrollPhysics(),
        children: [
          _InboxFilterChip(
            label: context.translate('all'),
            selected: loaded?.statusFilter == null,
            onTap: () => cubit.setStatusFilter(null),
          ),
          SizedBox(width: 8.w),
          for (final status in ['open', 'pending', 'solved']) ...[
            _InboxFilterChip(
              label: context.translate(status),
              selected: loaded?.statusFilter == status,
              onTap: () => cubit.setStatusFilter(status),
            ),
            SizedBox(width: 8.w),
          ],
          _InboxFilterChip(
            label: context.translate('my_tickets'),
            selected: loaded?.myTicketsOnly ?? false,
            icon: Icons.person_outline_rounded,
            onTap: () => cubit.toggleMyTickets(!(loaded?.myTicketsOnly ?? false)),
          ),
        ],
      ),
    );
  }
}

class _InboxFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  const _InboxFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final customColors = context.customColors;

    return Material(
      color: selected
          ? colors.primary.withValues(alpha: 0.1)
          : context.colors.surface,
      borderRadius: BorderRadius.circular(22.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22.r),
        splashColor: customColors.primarySoft.withValues(alpha: 0.15),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(
              color: selected ? colors.primary : customColors.border,
              width: selected ? 1.5.r : 1.r,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 16.r,
                    color: selected ? colors.primary : customColors.textSecondary,
                  ),
                  SizedBox(width: 6.w),
                ],
                Text(
                  label,
                  style: AppTextStyles.subTitle(
                    context,
                    fontSize: 12,
                    color: selected ? colors.primary : customColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
