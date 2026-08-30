import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/utils/extensions/context_extensions.dart';
import '../../../../app/widgets/app_text_field.dart';

class InboxSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const InboxSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final customColors = context.customColors;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, _) {
          return AppTextField(
            controller: controller,
            hintText: context.translate('search_tickets'),
            textInputType: TextInputType.text,
            textInputAction: TextInputAction.search,
            height: 44,
            borderRadius: 12,
            backgroundColor: customColors.surfaceLight.withValues(alpha: 0.35),
            borderColor: customColors.border,
            contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0),
            prefixIcon: Icon(
              Icons.search_rounded,
              size: 20.r,
              color: customColors.textSecondary,
            ),
            prefixIconConstraints: BoxConstraints(minWidth: 44.w, minHeight: 44.h),
            suffixIcon: value.text.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      size: 18.r,
                      color: customColors.textSecondary,
                    ),
                    onPressed: () {
                      controller.clear();
                      onChanged('');
                    },
                  )
                : null,
            suffixIconConstraints: BoxConstraints(minWidth: 40.w, minHeight: 40.h),
            onChanged: onChanged,
          );
        },
      ),
    );
  }
}
