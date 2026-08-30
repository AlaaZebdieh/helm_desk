import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../app/utils/extensions/context_extensions.dart';

class TicketDetailSkeleton extends StatelessWidget {
  const TicketDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final customColors = context.customColors;

    return Shimmer.fromColors(
      baseColor: customColors.surfaceLight,
      highlightColor: context.colors.surface,
      child: Column(
        children: [
          Container(
            height: 180.h,
            width: double.infinity,
            color: customColors.surfaceLight,
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (_, index) {
                final isRight = index.isOdd;
                return Align(
                  alignment: isRight
                      ? AlignmentDirectional.centerEnd
                      : AlignmentDirectional.centerStart,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 6.h),
                    width: context.width * (isRight ? 0.55 : 0.65),
                    height: 64.h,
                    decoration: BoxDecoration(
                      color: customColors.surfaceLight,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
