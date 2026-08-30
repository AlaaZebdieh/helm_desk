import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_text_styles.dart';
import '../utils/extensions/context_extensions.dart';

class AppCheckbox extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;

  final bool value;

  final double? radius;
  final double fontSize;

  final Color? textColor;
  final TextDirection? textDirection;
  final EdgeInsetsGeometry? margin;

  final VoidCallback? onTap;

  const AppCheckbox({
    super.key,
    this.title,
    this.titleWidget,
    required this.value,
    this.radius,
    this.fontSize = 12,
    this.textColor,
    this.textDirection,
    this.margin,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final customColors = context.customColors;

    final borderRadius = BorderRadius.circular(10.r);
    final isCircle = radius == null;

    return Semantics(
      checked: value,
      button: true,
      label: title,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: Container(
            margin: margin,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: borderRadius,
              border: Border.all(
                width: 1.r,
                color: customColors.border,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: textDirection,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 18.h,
                  width: 18.h,
                  padding: EdgeInsets.all(3.r),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
                    borderRadius:
                        !isCircle ? BorderRadius.circular(radius!.r) : null,
                    border: Border.all(
                      width: 1.r,
                      color: value ? colors.primary : customColors.border,
                    ),
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
                      borderRadius: !isCircle
                          ? BorderRadius.circular((radius! - 2).r)
                          : null,
                      color: value ? colors.primary : Colors.transparent,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: titleWidget ??
                      Text(
                        title ?? "",
                        style: AppTextStyles.subTitle(
                          context,
                          fontSize: fontSize,
                          color: textColor ?? customColors.primarySoft,
                        ),
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
