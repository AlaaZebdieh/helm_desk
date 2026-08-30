import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_text_styles.dart';
import '../utils/extensions/context_extensions.dart';

class DropdownSearchField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final String? hintText;

  const DropdownSearchField({
    super.key,
    required this.controller,
    this.onChanged,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final customColors = context.customColors;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1.r, color: customColors.border),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: AppTextStyles.subTitle(context),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.bodyMedium(
            context,
            fontSize: 12,
            color: customColors.textSecondary,
          ),
          filled: true,
          fillColor: colors.surface,
          contentPadding: EdgeInsets.symmetric(
            vertical: 12.h,
            horizontal: 12.w,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide.none,
            gapPadding: 0,
          ),
        ),
      ),
    );
  }
}
