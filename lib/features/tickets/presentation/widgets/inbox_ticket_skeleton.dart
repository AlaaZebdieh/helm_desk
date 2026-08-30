import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../app/utils/extensions/context_extensions.dart';

class InboxTicketSkeleton extends StatelessWidget {
  const InboxTicketSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final customColors = context.customColors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Shimmer.fromColors(
        baseColor: customColors.surfaceLight,
        highlightColor: context.colors.surface,
        child: Container(
          height: 118.h,
          decoration: BoxDecoration(
            color: customColors.surfaceLight,
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
      ),
    );
  }
}
